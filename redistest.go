package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/garyburd/redigo/redis"
)

func main() {

	err := newRedisPool("", "")
	if err != nil {
		fmt.Println(err)
		return
	}

	//put job on stack
	redisInstance.Enqueue()

	//get job on stack
	redisInstance.GetJob()
	redisInstance.GetJob()
}

type RedisPool struct {
	pool *redis.Pool
}


var redisInstance *RedisPool
func init(){
	redisInstance = &RedisPool{}
}
func newRedisPool(server, pwd string) error {

	if server == "" {
		server = ":6379"
	}

	pool := &redis.Pool{
		MaxIdle:     3,
		IdleTimeout: 240 * time.Second,
		Dial: func() (redis.Conn, error) {
			c, err := redis.Dial("tcp", server)
			if err != nil {
				return nil, err
			}

			if pwd != "" {
				if _, err := c.Do("AUTH", pwd); err != nil {
					c.Close()
					return nil, err
				}
			}
			return c, err
		},
		TestOnBorrow: func(c redis.Conn, t time.Time) error {
			_, err := c.Do("PING")
			return err
		},
	}
	redisInstance.pool=pool
	//&RedisPool{pool},
	return  nil
}

type Job struct {
	Class string        `json:"Class"`
	Args  []interface{} `json:"Args"`
}

//client
func (r *RedisPool) Enqueue() error {

	c := r.pool.Get()
	defer c.Close()

	j := &Job{}
	j.Class = "mail"
	j.Args = append(j.Args, "test@mtanlocal.cn", "", "body", 2, true)

	j2 := &Job{}
	j2.Class = "Log"
	j2.Args = append(j2.Args, "test.log", "test1.log", []int{222, 333})

	for _, v := range []*Job{j, j2} {
		b, err := json.Marshal(v)
		if err != nil {
			return err
		}

		_, err = c.Do("rpush", "queue", b)
		if err != nil {
			return err
		}
	}

	fmt.Println("[Enqueue()] succeed!")

	return nil
}

//server
func (r *RedisPool) GetJob() error {
	count, err := r.QueuedJobCount()
	if err != nil || count == 0 {
		return errors.New("no job.")
	}
	fmt.Println("[GetJob()] Jobs count:", count)

	c := r.pool.Get()
	defer c.Close()

	for i := 0; i < int(count); i++ {
		reply, err := c.Do("LPOP", "queue")
		if err != nil {
			return err
		}

		var j Job
		decoder := json.NewDecoder(bytes.NewReader(reply.([]byte)))
		if err := decoder.Decode(&j); err != nil {
			return err
		}

		fmt.Println("[GetJob()] ", j.Class, " : ", j.Args)
	}
	return nil
}

func (r *RedisPool) QueuedJobCount() (int, error) {
	c := r.pool.Get()
	defer c.Close()

	lenqueue, err := c.Do("llen", "queue")
	if err != nil {
		return 0, err
	}

	count, ok := lenqueue.(int64)
	if !ok {
		return 0, errors.New("covert type error!")
	}
	return int(count), nil
}
