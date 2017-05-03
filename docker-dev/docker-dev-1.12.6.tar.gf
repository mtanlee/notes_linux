date. Values are `continue` and `pause`.
- **Networks** ‚Äì Array of network names or IDs to attach the service to.
- **EndpointSpec** ‚Äì Properties that can be configured to access and load balance a service.
    - **Mode** ‚Äì The mode of resolution to use for internal load balancing
      between tasks (`vip` or `dnsrr`). Defaults to `vip` if not provided.
    - **Ports** ‚Äì List of exposed ports that this service is accessible on from
      the outside, in the form of:
      `{"Protocol": <"tcp"|"udp">, "PublishedPort": <port>, "TargetPort": <port>}`.
      Ports can only be provided if `vip` resolution mode is used.

**Request Headers**:

- **Content-type** ‚Äì Set to `"application/json"`.
- **X-Registry-Auth** ‚Äì base64-encoded AuthConfig object, containing either
  login information, or a token. Refer to the [create an image](docker_remote_api_v1.24.md#create-an-image)
  section for more details.


### Remove a service


`DELETE /services/(id or name)`

Stop and remove the service `id`

**Example request**:

    DELETE /services/16253994b7c4 HTTP/1.1

**Example response**:

    HTTP/1.1 200 No Content

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such service
-   **500** ‚Äì server error

### Inspect one or more services


`GET /services/(id or name)`

Return information on the service `id`.

**Example request**:

    GET /services/1cb4dnqcyx6m66g2t538x3rxha HTTP/1.1

**Example response**:

    {
      "ID": "ak7w3gjqoa3kuz8xcpnyy0pvl",
      "Version": {
        "Index": 95
      },
      "CreatedAt": "2016-06-07T21:10:20.269723157Z",
      "UpdatedAt": "2016-06-07T21:10:20.276301259Z",
      "Spec": {
        "Name": "redis",
        "TaskTemplate": {
          "ContainerSpec": {
            "Image": "redis"
          },
          "Resources": {
            "Limits": {},
            "Reservations": {}
          },
          "RestartPolicy": {
            "Condition": "any",
            "MaxAttempts": 0
          },
          "Placement": {}
        },
        "Mode": {
          "Replicated": {
            "Replicas": 1
          }
        },
        "UpdateConfig": {
          "Parallelism": 1,
          "FailureAction": "pause"
        },
        "EndpointSpec": {
          "Mode": "vip",
          "Ports": [
            {
              "Protocol": "tcp",
              "TargetPort": 6379,
              "PublishedPort": 30001
            }
          ]
        }
      },
      "Endpoint": {
        "Spec": {
          "Mode": "vip",
          "Ports": [
            {
              "Protocol": "tcp",
              "TargetPort": 6379,
              "PublishedPort": 30001
            }
          ]
        },
        "Ports": [
          {
            "Protocol": "tcp",
            "TargetPort": 6379,
            "PublishedPort": 30001
          }
        ],
        "VirtualIPs": [
          {
            "NetworkID": "4qvuz4ko70xaltuqbt8956gd1",
            "Addr": "10.255.0.4/16"
          }
        ]
      }
    }

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such service
-   **500** ‚Äì server error

### Update a service

`POST /services/(id or name)/update`

Update a service. When using this endpoint to create a service using a
private repository from the registry, the `X-Registry-Auth` header can be used
to update the authentication information for that is stored for the service.
The header contains a base64-encoded AuthConfig object. Refer to the [create an
image](docker_remote_api_v1.24.md#create-an-image) section for more details.

**Example request**:

    POST /services/1cb4dnqcyx6m66g2t538x3rxha/update?version=23 HTTP/1.1
    Content-Type: application/json

    {
      "Name": "top",
      "TaskTemplate": {
        "ContainerSpec": {
          "Image": "busybox",
          "Args": [
            "top"
          ]
        },
        "Resources": {
          "Limits": {},
          "Reservations": {}
        },
        "RestartPolicy": {
          "Condition": "any",
          "MaxAttempts": 0
        },
        "Placement": {}
      },
      "Mode": {
        "Replicated": {
          "Replicas": 1
        }
      },
      "UpdateConfig": {
        "Parallelism": 1
      },
      "EndpointSpec": {
        "Mode": "vip"
      }
    }

**Example response**:

    HTTP/1.1 200 OK
    Content-Length: 0
    Content-Type: text/plain; charset=utf-8

**JSON Parameters**:

- **Name** ‚Äì User-defined name for the service.
- **Labels** ‚Äì A map of labels to associate with the service (e.g., `{"key":"value", "key2":"value2"}`).
- **TaskTemplate** ‚Äì Specification of the tasks to start as part of the new service.
    - **ContainerSpec** - Container settings for containers started as part of this task.
        - **Image** ‚Äì A string specifying the image name to use for the container.
        - **Command** ‚Äì The command to be run in the image.
        - **Args** ‚Äì Arguments to the command.
        - **Env** ‚Äì A list of environment variables in the form of `["VAR=value"[,"VAR2=value2"]]`.
        - **Dir** ‚Äì A string specifying the working directory for commands to run in.
        - **User** ‚Äì A string value specifying the user inside the container.
        - **Labels** ‚Äì A map of labels to associate with the service (e.g.,
          `{"key":"value", "key2":"value2"}`).
        - **Mounts** ‚Äì Specification for mounts to be added to containers created as part of the new
          service.
            - **Target** ‚Äì Container path.
            - **Source** ‚Äì Mount source (e.g. a volume name, a host path).
            - **Type** ‚Äì The mount type (`bind`, or `volume`).
            - **ReadOnly** ‚Äì A boolean indicating whether the mount should be read-only.
            - **BindOptions** - Optional configuration for the `bind` type
              - **Propagation** ‚Äì A propagation mode with the value `[r]private`, `[r]shared`, or `[r]slave`.
            - **VolumeOptions** ‚Äì Optional configuration for the `volume` type.
                - **NoCopy** ‚Äì A boolean indicating if volume should be
                  populated with the data from the target. (Default false)
                - **Labels** ‚Äì User-defined name and labels for the volume.
                - **DriverConfig** ‚Äì Map of driver-specific options.
                  - **Name** - Name of the driver to use to create the volume
                  - **Options** - key/value map of driver specific options
        - **StopGracePeriod** ‚Äì Amount of time to wait for the container to terminate before
          forcefully killing it.
    - **Resources** ‚Äì Resource requirements which apply to each individual container created as part
      of the service.
        - **Limits** ‚Äì Define resources limits.
            - **CPU** ‚Äì CPU limit
            - **Memory** ‚Äì Memory limit
        - **Reservation** ‚Äì Define resources reservation.
            - **CPU** ‚Äì CPU reservation
            - **Memory** ‚Äì Memory reservation
    - **RestartPolicy** ‚Äì Specification for the restart policy which applies to containers created
      as part of this service.
        - **Condition** ‚Äì Condition for restart (`none`, `on-failure`, or `any`).
        - **Delay** ‚Äì Delay between restart attempts.
        - **MaxAttempts** ‚Äì Maximum attempts to restart a given container before giving up (default value
          is 0, which is ignored).
        - **Window** ‚Äì Windows is the time window used to evaluate the restart policy (default value is
          0, which is unbounded).
    - **Placement** ‚Äì An array of constraints.
- **Mode** ‚Äì Scheduling mode for the service (`replicated` or `global`, defaults to `replicated`).
- **UpdateConfig** ‚Äì Specification for the update strategy of the service.
    - **Parallelism** ‚Äì Maximum number of tasks to be updated in one iteration (0 means unlimited
      parallelism).
    - **Delay** ‚Äì Amount of time between updates.
- **Networks** ‚Äì Array of network names or IDs to attach the service to.
- **EndpointSpec** ‚Äì Properties that can be configured to access and load balance a service.
    - **Mode** ‚Äì The mode of resolution to use for internal load balancing
      between tasks (`vip` or `dnsrr`). Defaults to `vip` if not provided.
    - **Ports** ‚Äì List of exposed ports that this service is accessible on from
      the outside, in the form of:
      `{"Protocol": <"tcp"|"udp">, "PublishedPort": <port>, "TargetPort": <port>}`.
      Ports can only be provided if `vip` resolution mode is used.

**Query parameters**:

- **version** ‚Äì The version number of the service object being updated. This is
  required to avoid conflicting writes.

**Request Headers**:

- **Content-type** ‚Äì Set to `"application/json"`.
- **X-Registry-Auth** ‚Äì base64-encoded AuthConfig object, containing either
  login information, or a token. Refer to the [create an image](docker_remote_api_v1.24.md#create-an-image)
  section for more details.

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such service
-   **500** ‚Äì server error

## 3.10 Tasks

**Note**: Task operations require the engine to be part of a swarm.

### List tasks


`GET /tasks`

List tasks

**Example request**:

    GET /tasks HTTP/1.1

**Example response**:

    [
      {
        "ID": "0kzzo1i0y4jz6027t0k7aezc7",
        "Version": {
          "Index": 71
        },
        "CreatedAt": "2016-06-07T21:07:31.171892745Z",
        "UpdatedAt": "2016-06-07T21:07:31.376370513Z",
        "Spec": {
          "ContainerSpec": {
            "Image": "redis"
          },
          "Resources": {
            "Limits": {},
            "Reservations": {}
          },
          "RestartPolicy": {
            "Condition": "any",
            "MaxAttempts": 0
          },
          "Placement": {}
        },
        "ServiceID": "9mnpnzenvg8p8tdbtq4wvbkcz",
        "Slot": 1,
        "NodeID": "60gvrl6tm78dmak4yl7srz94v",
        "Status": {
          "Timestamp": "2016-06-07T21:07:31.290032978Z",
          "State": "running",
          "Message": "started",
          "ContainerStatus": {
            "ContainerID": "e5d62702a1b48d01c3e02ca1e0212a250801fa8d67caca0b6f35919ebc12f035",
            "PID": 677
          }
        },
        "DesiredState": "running",
        "NetworksAttachments": [
          {
            "Network": {
              "ID": "4qvuz4ko70xaltuqbt8956gd1",
              "Version": {
                "Index": 18
              },
              "CreatedAt": "2016-06-07T20:31:11.912919752Z",
              "UpdatedAt": "2016-06-07T21:07:29.955277358Z",
              "Spec": {
                "Name": "ingress",
                "Labels": {
                  "com.docker.swarm.internal": "true"
                },
                "DriverConfiguration": {},
                "IPAMOptions": {
                  "Driver": {},
                  "Configs": [
                    {
                      "Subnet": "10.255.0.0/16",
                      "Gateway": "10.255.0.1"
                    }
                  ]
                }
              },
              "DriverState": {
                "Name": "overlay",
                "Options": {
                  "com.docker.network.driver.overlay.vxlanid_list": "256"
                }
              },
              "IPAMOptions": {
                "Driver": {
                  "Name": "default"
                },
                "Configs": [
                  {
                    "Subnet": "10.255.0.0/16",
                    "Gateway": "10.255.0.1"
                  }
                ]
              }
            },
            "Addresses": [
              "10.255.0.10/16"
            ]
          }
        ],
      },
      {
        "ID": "1yljwbmlr8er2waf8orvqpwms",
        "Version": {
          "Index": 30
        },
        "CreatedAt": "2016-06-07T21:07:30.019104782Z",
        "UpdatedAt": "2016-06-07T21:07:30.231958098Z",
        "Name": "hopeful_cori",
        "Spec": {
          "ContainerSpec": {
            "Image": "redis"
          },
          "Resources": {
            "Limits": {},
            "Reservations": {}
          },
          "RestartPolicy": {
            "Condition": "any",
            "MaxAttempts": 0
          },
          "Placement": {}
        },
        "ServiceID": "9mnpnzenvg8p8tdbtq4wvbkcz",
        "Slot": 1,
        "NodeID": "60gvrl6tm78dmak4yl7srz94v",
        "Status": {
          "Timestamp": "2016-06-07T21:07:30.202183143Z",
          "State": "shutdown",
          "Message": "shutdown",
          "ContainerStatus": {
            "ContainerID": "1cf8d63d18e79668b0004a4be4c6ee58cddfad2dae29506d8781581d0688a213"
          }
        },
        "DesiredState": "shutdown",
        "NetworksAttachments": [
          {
            "Network": {
              "ID": "4qvuz4ko70xaltuqbt8956gd1",
              "Version": {
                "Index": 18
              },
              "CreatedAt": "2016-06-07T20:31:11.912919752Z",
              "UpdatedAt": "2016-06-07T21:07:29.955277358Z",
              "Spec": {
                "Name": "ingress",
                "Labels": {
                  "com.docker.swarm.internal": "true"
                },
                "DriverConfiguration": {},
                "IPAMOptions": {
                  "Driver": {},
                  "Configs": [
                    {
                      "Subnet": "10.255.0.0/16",
                      "Gateway": "10.255.0.1"
                    }
                  ]
                }
              },
              "DriverState": {
                "Name": "overlay",
                "Options": {
                  "com.docker.network.driver.overlay.vxlanid_list": "256"
                }
              },
              "IPAMOptions": {
                "Driver": {
                  "Name": "default"
                },
                "Configs": [
                  {
                    "Subnet": "10.255.0.0/16",
                    "Gateway": "10.255.0.1"
                  }
                ]
              }
            },
            "Addresses": [
              "10.255.0.5/16"
            ]
          }
        ]
      }
    ]

**Query parameters**:

- **filters** ‚Äì a JSON encoded value of the filters (a `map[string][]string`) to process on the
  services list. Available filters:
  - `id=<task id>`
  - `name=<task name>`
  - `service=<service name>`
  - `node=<node id or name>`
  - `label=key` or `label="key=value"`
  - `desired-state=(running | shutdown | accepted)`

**Status codes**:

- **200** ‚Äì no error
- **500** ‚Äì server error

### Inspect a task


`GET /tasks/(task id)`

Get details on a task

**Example request**:

    GET /tasks/0kzzo1i0y4jz6027t0k7aezc7 HTTP/1.1

**Example response**:

    {
      "ID": "0kzzo1i0y4jz6027t0k7aezc7",
      "Version": {
        "Index": 71
      },
      "CreatedAt": "2016-06-07T21:07:31.171892745Z",
      "UpdatedAt": "2016-06-07T21:07:31.376370513Z",
      "Spec": {
        "ContainerSpec": {
          "Image": "redis"
        },
        "Resources": {
          "Limits": {},
          "Reservations": {}
        },
        "RestartPolicy": {
          "Condition": "any",
          "MaxAttempts": 0
        },
        "Placement": {}
      },
      "ServiceID": "9mnpnzenvg8p8tdbtq4wvbkcz",
      "Slot": 1,
      "NodeID": "60gvrl6tm78dmak4yl7srz94v",
      "Status": {
        "Timestamp": "2016-06-07T21:07:31.290032978Z",
        "State": "running",
        "Message": "started",
        "ContainerStatus": {
          "ContainerID": "e5d62702a1b48d01c3e02ca1e0212a250801fa8d67caca0b6f35919ebc12f035",
          "PID": 677
        }
      },
      "DesiredState": "running",
      "NetworksAttachments": [
        {
          "Network": {
            "ID": "4qvuz4ko70xaltuqbt8956gd1",
            "Version": {
              "Index": 18
            },
            "CreatedAt": "2016-06-07T20:31:11.912919752Z",
            "UpdatedAt": "2016-06-07T21:07:29.955277358Z",
            "Spec": {
              "Name": "ingress",
              "Labels": {
                "com.docker.swarm.internal": "true"
              },
              "DriverConfiguration": {},
              "IPAMOptions": {
                "Driver": {},
                "Configs": [
                  {
                    "Subnet": "10.255.0.0/16",
                    "Gateway": "10.255.0.1"
                  }
                ]
              }
            },
            "DriverState": {
              "Name": "overlay",
              "Options": {
                "com.docker.network.driver.overlay.vxlanid_list": "256"
              }
            },
            "IPAMOptions": {
              "Driver": {
                "Name": "default"
              },
              "Configs": [
                {
                  "Subnet": "10.255.0.0/16",
                  "Gateway": "10.255.0.1"
                }
              ]
            }
          },
          "Addresses": [
            "10.255.0.10/16"
          ]
        }
      ]
    }

**Status codes**:

- **200** ‚Äì no error
- **404** ‚Äì unknown task
- **500** ‚Äì server error

# 4. Going further

## 4.1 Inside `docker run`

As an example, the `docker run` command line makes the following API calls:

- Create the container

- If the status code is 404, it means the image doesn't exist:
    - Try to pull it.
    - Then, retry to create the container.

- Start the container.

- If you are not in detached mode:
- Attach to the container, using `logs=1` (to have `stdout` and
      `stderr` from the container's start) and `stream=1`

- If in detached mode or only `stdin` is attached, display the container's id.

## 4.2 Hijacking

In this version of the API, `/attach`, uses hijacking to transport `stdin`,
`stdout`, and `stderr` on the same socket.

To hint potential proxies about connection hijacking, Docker client sends
connection upgrade headers similarly to websocket.

    Upgrade: tcp
    Connection: Upgrade

When Docker daemon detects the `Upgrade` header, it switches its status code
from **200 OK** to **101 UPGRADED** and resends the same headers.


## 4.3 CORS Requests

To set cross origin requests to the remote api please give values to
`--api-cors-header` when running Docker in daemon mode. Set * (asterisk) allows all,
default or blank means CORS disabled

    $ dockerd -H="192.168.1.9:2375" --api-cors-header="http://foo.bar"
                                                   go/src/github.com/docker/docker/docs/reference/api/docker_remote_api_v1.25.md                       0100644 0000000 0000000 00000456536 13101060260 025515  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/api/docker_remote_api_v1.25/
description: API Documentation for Docker
published: false
keywords:
- API, Docker, rcli, REST,  documentation
title: Docker Remote API v1.25
---

# 1. Brief introduction

 - The Remote API has replaced `rcli`.
 - The daemon listens on `unix:///var/run/docker.sock` but you can
   [Bind Docker to another host/port or a Unix socket](../commandline/dockerd.md#bind-docker-to-another-host-port-or-a-unix-socket).
 - The API tends to be REST. However, for some complex commands, like `attach`
   or `pull`, the HTTP connection is hijacked to transport `stdout`,
   `stdin` and `stderr`.
 - When the client API version is newer than the daemon's, these calls return an HTTP
   `400 Bad Request` error message.

# 2. Errors

The Remote API uses standard HTTP status codes to indicate the success or failure of the API call. The body of the response will be JSON in the following format:

    {
        "message": "page not found"
    }

The status codes that are returned for each endpoint are specified in the endpoint documentation below.

# 3. Endpoints

## 3.1 Containers

### List containers

`GET /containers/json`

List containers

**Example request**:

    GET /containers/json?all=1&before=8dfafdbc3a40&size=1 HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    [
         {
                 "Id": "8dfafdbc3a40",
                 "Names":["/boring_feynman"],
                 "Image": "ubuntu:latest",
                 "ImageID": "d74508fb6632491cea586a1fd7d748dfc5274cd6fdfedee309ecdcbc2bf5cb82",
                 "Command": "echo 1",
                 "Created": 1367854155,
                 "State": "Exited",
                 "Status": "Exit 0",
                 "Ports": [{"PrivatePort": 2222, "PublicPort": 3333, "Type": "tcp"}],
                 "Labels": {
                         "com.example.vendor": "Acme",
                         "com.example.license": "GPL",
                         "com.example.version": "1.0"
                 },
                 "SizeRw": 12288,
                 "SizeRootFs": 0,
                 "HostConfig": {
                         "NetworkMode": "default"
                 },
                 "NetworkSettings": {
                         "Networks": {
                                 "bridge": {
                                          "IPAMConfig": null,
                                          "Links": null,
                                          "Aliases": null,
                                          "NetworkID": "7ea29fc1412292a2d7bba362f9253545fecdfa8ce9a6e37dd10ba8bee7129812",
                                          "EndpointID": "2cdc4edb1ded3631c81f57966563e5c8525b81121bb3706a9a9a3ae102711f3f",
                                          "Gateway": "172.17.0.1",
                                          "IPAddress": "172.17.0.2",
                                          "IPPrefixLen": 16,
                                          "IPv6Gateway": "",
                                          "GlobalIPv6Address": "",
                                          "GlobalIPv6PrefixLen": 0,
                                          "MacAddress": "02:42:ac:11:00:02"
                                  }
                         }
                 },
                 "Mounts": [
                         {
                                  "Name": "fac362...80535",
                                  "Source": "/data",
                                  "Destination": "/data",
                                  "Driver": "local",
                                  "Mode": "ro,Z",
                                  "RW": false,
                                  "Propagation": ""
                         }
                 ]
         },
         {
                 "Id": "9cd87474be90",
                 "Names":["/coolName"],
                 "Image": "ubuntu:latest",
                 "ImageID": "d74508fb6632491cea586a1fd7d748dfc5274cd6fdfedee309ecdcbc2bf5cb82",
                 "Command": "echo 222222",
                 "Created": 1367854155,
                 "State": "Exited",
                 "Status": "Exit 0",
                 "Ports": [],
                 "Labels": {},
                 "SizeRw": 12288,
                 "SizeRootFs": 0,
                 "HostConfig": {
                         "NetworkMode": "default"
                 },
                 "NetworkSettings": {
                         "Networks": {
                                 "bridge": {
                                          "IPAMConfig": null,
                                          "Links": null,
                                          "Aliases": null,
                                          "NetworkID": "7ea29fc1412292a2d7bba362f9253545fecdfa8ce9a6e37dd10ba8bee7129812",
                                          "EndpointID": "88eaed7b37b38c2a3f0c4bc796494fdf51b270c2d22656412a2ca5d559a64d7a",
                                          "Gateway": "172.17.0.1",
                                          "IPAddress": "172.17.0.8",
                                          "IPPrefixLen": 16,
                                          "IPv6Gateway": "",
                                          "GlobalIPv6Address": "",
                                          "GlobalIPv6PrefixLen": 0,
                                          "MacAddress": "02:42:ac:11:00:08"
                                  }
                         }
                 },
                 "Mounts": []
         },
         {
                 "Id": "3176a2479c92",
                 "Names":["/sleepy_dog"],
                 "Image": "ubuntu:latest",
                 "ImageID": "d74508fb6632491cea586a1fd7d748dfc5274cd6fdfedee309ecdcbc2bf5cb82",
                 "Command": "echo 3333333333333333",
                 "Created": 1367854154,
                 "State": "Exited",
                 "Status": "Exit 0",
                 "Ports":[],
                 "Labels": {},
                 "SizeRw":12288,
                 "SizeRootFs":0,
                 "HostConfig": {
                         "NetworkMode": "default"
                 },
                 "NetworkSettings": {
                         "Networks": {
                                 "bridge": {
                                          "IPAMConfig": null,
                                          "Links": null,
                                          "Aliases": null,
                                          "NetworkID": "7ea29fc1412292a2d7bba362f9253545fecdfa8ce9a6e37dd10ba8bee7129812",
                                          "EndpointID": "8b27c041c30326d59cd6e6f510d4f8d1d570a228466f956edf7815508f78e30d",
                                          "Gateway": "172.17.0.1",
                                          "IPAddress": "172.17.0.6",
                                          "IPPrefixLen": 16,
                                          "IPv6Gateway": "",
                                          "GlobalIPv6Address": "",
                                          "GlobalIPv6PrefixLen": 0,
                                          "MacAddress": "02:42:ac:11:00:06"
                                  }
                         }
                 },
                 "Mounts": []
         },
         {
                 "Id": "4cb07b47f9fb",
                 "Names":["/running_cat"],
                 "Image": "ubuntu:latest",
                 "ImageID": "d74508fb6632491cea586a1fd7d748dfc5274cd6fdfedee309ecdcbc2bf5cb82",
                 "Command": "echo 444444444444444444444444444444444",
                 "Created": 1367854152,
                 "State": "Exited",
                 "Status": "Exit 0",
                 "Ports": [],
                 "Labels": {},
                 "SizeRw": 12288,
                 "SizeRootFs": 0,
                 "HostConfig": {
                         "NetworkMode": "default"
                 },
                 "NetworkSettings": {
                         "Networks": {
                                 "bridge": {
                                          "IPAMConfig": null,
                                          "Links": null,
                                          "Aliases": null,
                                          "NetworkID": "7ea29fc1412292a2d7bba362f9253545fecdfa8ce9a6e37dd10ba8bee7129812",
                                          "EndpointID": "d91c7b2f0644403d7ef3095985ea0e2370325cd2332ff3a3225c4247328e66e9",
                                          "Gateway": "172.17.0.1",
                                          "IPAddress": "172.17.0.5",
                                          "IPPrefixLen": 16,
                                          "IPv6Gateway": "",
                                          "GlobalIPv6Address": "",
                                          "GlobalIPv6PrefixLen": 0,
                                          "MacAddress": "02:42:ac:11:00:05"
                                  }
                         }
                 },
                 "Mounts": []
         }
    ]

**Query parameters**:

-   **all** ‚Äì 1/True/true or 0/False/false, Show all containers.
        Only running containers are shown by default (i.e., this defaults to false)
-   **limit** ‚Äì Show `limit` last created
        containers, include non-running ones.
-   **since** ‚Äì Show only containers created since Id, include
        non-running ones.
-   **before** ‚Äì Show only containers created before Id, include
        non-running ones.
-   **size** ‚Äì 1/True/true or 0/False/false, Show the containers
        sizes
-   **filters** - a JSON encoded value of the filters (a `map[string][]string`) to process on the containers list. Available filters:
  -   `exited=<int>`; -- containers with exit code of  `<int>` ;
  -   `status=`(`created`|`restarting`|`running`|`paused`|`exited`|`dead`)
  -   `label=key` or `label="key=value"` of a container label
  -   `isolation=`(`default`|`process`|`hyperv`)   (Windows daemon only)
  -   `ancestor`=(`<image-name>[:<tag>]`,  `<image id>` or `<image@digest>`)
  -   `before`=(`<container id>` or `<container name>`)
  -   `since`=(`<container id>` or `<container name>`)
  -   `volume`=(`<volume name>` or `<mount point destination>`)
  -   `network`=(`<network id>` or `<network name>`)

**Status codes**:

-   **200** ‚Äì no error
-   **400** ‚Äì bad parameter
-   **500** ‚Äì server error

### Create a container

`POST /containers/create`

Create a container

**Example request**:

    POST /containers/create HTTP/1.1
    Content-Type: application/json

    {
           "Hostname": "",
           "Domainname": "",
           "User": "",
           "AttachStdin": false,
           "AttachStdout": true,
           "AttachStderr": true,
           "Tty": false,
           "OpenStdin": false,
           "StdinOnce": false,
           "Env": [
                   "FOO=bar",
                   "BAZ=quux"
           ],
           "Cmd": [
                   "date"
           ],
           "Entrypoint": "",
           "Image": "ubuntu",
           "Labels": {
                   "com.example.vendor": "Acme",
                   "com.example.license": "GPL",
                   "com.example.version": "1.0"
           },
           "Volumes": {
             "/volumes/data": {}
           },
           "WorkingDir": "",
           "NetworkDisabled": false,
           "MacAddress": "12:34:56:78:9a:bc",
           "ExposedPorts": {
                   "22/tcp": {}
           },
           "StopSignal": "SIGTERM",
           "HostConfig": {
             "Binds": ["/tmp:/tmp"],
             "Tmpfs": { "/run": "rw,noexec,nosuid,size=65536k" },
             "Links": ["redis3:redis"],
             "Memory": 0,
             "MemorySwap": 0,
             "MemoryReservation": 0,
             "KernelMemory": 0,
             "CpuPercent": 80,
             "CpuShares": 512,
             "CpuPeriod": 100000,
             "CpuQuota": 50000,
             "CpusetCpus": "0,1",
             "CpusetMems": "0,1",
             "IOMaximumBandwidth": 0,
             "IOMaximumIOps": 0,
             "BlkioWeight": 300,
             "BlkioWeightDevice": [{}],
             "BlkioDeviceReadBps": [{}],
             "BlkioDeviceReadIOps": [{}],
             "BlkioDeviceWriteBps": [{}],
             "BlkioDeviceWriteIOps": [{}],
             "MemorySwappiness": 60,
             "OomKillDisable": false,
             "OomScoreAdj": 500,
             "PidMode": "",
             "PidsLimit": -1,
             "PortBindings": { "22/tcp": [{ "HostPort": "11022" }] },
             "PublishAllPorts": false,
             "Privileged": false,
             "ReadonlyRootfs": false,
             "Dns": ["8.8.8.8"],
             "DnsOptions": [""],
             "DnsSearch": [""],
             "ExtraHosts": null,
             "VolumesFrom": ["parent", "other:ro"],
             "CapAdd": ["NET_ADMIN"],
             "CapDrop": ["MKNOD"],
             "GroupAdd": ["newgroup"],
             "RestartPolicy": { "Name": "", "MaximumRetryCount": 0 },
             "AutoRemove": true,
             "NetworkMode": "bridge",
             "Devices": [],
             "Sysctls": { "net.ipv4.ip_forward": "1" },
             "Ulimits": [{}],
             "LogConfig": { "Type": "json-file", "Config": {} },
             "SecurityOpt": [],
             "StorageOpt": {},
             "CgroupParent": "",
             "VolumeDriver": "",
             "ShmSize": 67108864
          },
          "NetworkingConfig": {
              "EndpointsConfig": {
                  "isolated_nw" : {
                      "IPAMConfig": {
                          "IPv4Address":"172.20.30.33",
                          "IPv6Address":"2001:db8:abcd::3033",
                          "LinkLocalIPs":["169.254.34.68", "fe80::3468"]
                      },
                      "Links":["container_1", "container_2"],
                      "Aliases":["server_x", "server_y"]
                  }
              }
          }
      }

**Example response**:

      HTTP/1.1 201 Created
      Content-Type: application/json

      {
           "Id":"e90e34656806",
           "Warnings":[]
      }

**JSON parameters**:

-   **Hostname** - A string value containing the hostname to use for the
      container. This must be a valid RFC 1123 hostname.
-   **Domainname** - A string value containing the domain name to use
      for the container.
-   **User** - A string value specifying the user inside the container.
-   **AttachStdin** - Boolean value, attaches to `stdin`.
-   **AttachStdout** - Boolean value, attaches to `stdout`.
-   **AttachStderr** - Boolean value, attaches to `stderr`.
-   **Tty** - Boolean value, Attach standard streams to a `tty`, including `stdin` if it is not closed.
-   **OpenStdin** - Boolean value, opens `stdin`,
-   **StdinOnce** - Boolean value, close `stdin` after the 1 attached client disconnects.
-   **Env** - A list of environment variables in the form of `["VAR=value", ...]`
-   **Labels** - Adds a map of labels to a container. To specify a map: `{"key":"value", ... }`
-   **Cmd** - Command to run specified as a string or an array of strings.
-   **Entrypoint** - Set the entry point for the container as a string or an array
      of strings. If the array consists of exactly one empty string (`[""]`) then the entry point
      is reset to system default (i.e., the entry point used by docker when there is no `ENTRYPOINT`
      instruction in the Dockerfile).
-   **Image** - A string specifying the image name to use for the container.
-   **Volumes** - An object mapping mount point paths (strings) inside the
      container to empty objects.
-   **WorkingDir** - A string specifying the working directory for commands to
      run in.
-   **NetworkDisabled** - Boolean value, when true disables networking for the
      container
-   **ExposedPorts** - An object mapping ports to an empty object in the form of:
      `"ExposedPorts": { "<port>/<tcp|udp>: {}" }`
-   **StopSignal** - Signal to stop a container as a string or unsigned integer. `SIGTERM` by default.
-   **HostConfig**
    -   **Binds** ‚Äì A list of volume bindings for this container. Each volume binding is a string in one of these forms:
           + `host-src:container-dest` to bind-mount a host path into the
             container. Both `host-src`, and `container-dest` must be an
             _absolute_ path.
           + `host-src:container-dest:ro` to make the bind-mount read-only
             inside the container. Both `host-src`, and `container-dest` must be
             an _absolute_ path.
           + `volume-name:container-dest` to bind-mount a volume managed by a
             volume driver into the container. `container-dest` must be an
             _absolute_ path.
           + `volume-name:container-dest:ro` to mount the volume read-only
             inside the container.  `container-dest` must be an _absolute_ path.
    -   **Tmpfs** ‚Äì A map of container directories which should be replaced by tmpfs mounts, and their corresponding
          mount options. A JSON object in the form `{ "/run": "rw,noexec,nosuid,size=65536k" }`.
    -   **Links** - A list of links for the container. Each link entry should be
          in the form of `container_name:alias`.
    -   **Memory** - Memory limit in bytes.
    -   **MemorySwap** - Total memory limit (memory + swap); set `-1` to enable unlimited swap.
          You must use this with `memory` and make the swap value larger than `memory`.
    -   **MemoryReservation** - Memory soft limit in bytes.
    -   **KernelMemory** - Kernel memory limit in bytes.
    -   **CpuPercent** - An integer value containing the usable percentage of the available CPUs. (Windows daemon only)
    -   **CpuShares** - An integer value containing the container's CPU Shares
          (ie. the relative weight vs other containers).
    -   **CpuPeriod** - The length of a CPU period in microseconds.
    -   **CpuQuota** - Microseconds of CPU time that the container can get in a CPU period.
    -   **CpusetCpus** - String value containing the `cgroups CpusetCpus` to use.
    -   **CpusetMems** - Memory nodes (MEMs) in which to allow execution (0-3, 0,1). Only effective on NUMA systems.
    -   **IOMaximumBandwidth** - Maximum IO absolute rate in terms of IOps.
    -   **IOMaximumIOps** - Maximum IO absolute rate in terms of bytes per second.
    -   **BlkioWeight** - Block IO weight (relative weight) accepts a weight value between 10 and 1000.
    -   **BlkioWeightDevice** - Block IO weight (relative device weight) in the form of:        `"BlkioWeightDevice": [{"Path": "device_path", "Weight": weight}]`
    -   **BlkioDeviceReadBps** - Limit read rate (bytes per second) from a device in the form of:	`"BlkioDeviceReadBps": [{"Path": "device_path", "Rate": rate}]`, for example:
        `"BlkioDeviceReadBps": [{"Path": "/dev/sda", "Rate": "1024"}]"`
    -   **BlkioDeviceWriteBps** - Limit write rate (bytes per second) to a device in the form of:	`"BlkioDeviceWriteBps": [{"Path": "device_path", "Rate": rate}]`, for example:
        `"BlkioDeviceWriteBps": [{"Path": "/dev/sda", "Rate": "1024"}]"`
    -   **BlkioDeviceReadIOps** - Limit read rate (IO per second) from a device in the form of:	`"BlkioDeviceReadIOps": [{"Path": "device_path", "Rate": rate}]`, for example:
        `"BlkioDeviceReadIOps": [{"Path": "/dev/sda", "Rate": "1000"}]`
    -   **BlkioDeviceWiiteIOps** - Limit write rate (IO per second) to a device in the form of:	`"BlkioDeviceWriteIOps": [{"Path": "device_path", "Rate": rate}]`, for example:
        `"BlkioDeviceWriteIOps": [{"Path": "/dev/sda", "Rate": "1000"}]`
    -   **MemorySwappiness** - Tune a container's memory swappiness behavior. Accepts an integer between 0 and 100.
    -   **OomKillDisable** - Boolean value, whether to disable OOM Killer for the container or not.
    -   **OomScoreAdj** - An integer value containing the score given to the container in order to tune OOM killer preferences.
    -   **PidMode** - Set the PID (Process) Namespace mode for the container;
          `"container:<name|id>"`: joins another container's PID namespace
          `"host"`: use the host's PID namespace inside the container
    -   **PidsLimit** - Tune a container's pids limit. Set -1 for unlimited.
    -   **PortBindings** - A map of exposed container ports and the host port they
          should map to. A JSON object in the form
          `{ <port>/<protocol>: [{ "HostPort": "<port>" }] }`
          Take note that `port` is specified as a string and not an integer value.
    -   **PublishAllPorts** - Allocates a random host port for all of a container's
          exposed ports. Specified as a boolean value.
    -   **Privileged** - Gives the container full access to the host. Specified as
          a boolean value.
    -   **ReadonlyRootfs** - Mount the container's root filesystem as read only.
          Specified as a boolean value.
    -   **Dns** - A list of DNS servers for the container to use.
    -   **DnsOptions** - A list of DNS options
    -   **DnsSearch** - A list of DNS search domains
    -   **ExtraHosts** - A list of hostnames/IP mappings to add to the
        container's `/etc/hosts` file. Specified in the form `["hostname:IP"]`.
    -   **VolumesFrom** - A list of volumes to inherit from another container.
          Specified in the form `<container name>[:<ro|rw>]`
    -   **CapAdd** - A list of kernel capabilities to add to the container.
    -   **Capdrop** - A list of kernel capabilities to drop from the container.
    -   **GroupAdd** - A list of additional groups that the container process will run as
    -   **RestartPolicy** ‚Äì The behavior to apply when the container exits.  The
            value is an object with a `Name` property of either `"always"` to
            always restart, `"unless-stopped"` to restart always except when
            user has manually stopped the container or `"on-failure"` to restart only when the container
            exit code is non-zero.  If `on-failure` is used, `MaximumRetryCount`
            controls the number of times to retry before giving up.
            The default is not to restart. (optional)
            An ever increasing delay (double the previous delay, starting at 100mS)
            is added before each restart to prevent flooding the server.
    -   **AutoRemove** - Boolean value, set to `true` to automatically remove the container on daemon side
            when the container's process exits. Note that `RestartPolicy` other than `none` is exclusive to `AutoRemove`.
    -   **UsernsMode**  - Sets the usernamespace mode for the container when usernamespace remapping option is enabled.
           supported values are: `host`.
    -   **NetworkMode** - Sets the networking mode for the container. Supported
          standard values are: `bridge`, `host`, `none`, and `container:<name|id>`. Any other value is taken
          as a custom network's name to which this container should connect to.
    -   **Devices** - A list of devices to add to the container specified as a JSON object in the
      form
          `{ "PathOnHost": "/dev/deviceName", "PathInContainer": "/dev/deviceName", "CgroupPermissions": "mrw"}`
    -   **Ulimits** - A list of ulimits to set in the container, specified as
          `{ "Name": <name>, "Soft": <soft limit>, "Hard": <hard limit> }`, for example:
          `Ulimits: { "Name": "nofile", "Soft": 1024, "Hard": 2048 }`
    -   **Sysctls** - A list of kernel parameters (sysctls) to set in the container, specified as
          `{ <name>: <Value> }`, for example:
	  `{ "net.ipv4.ip_forward": "1" }`
    -   **SecurityOpt**: A list of string values to customize labels for MLS
        systems, such as SELinux.
    -   **StorageOpt**: Storage driver options per container. Options can be passed in the form
        `{"size":"120G"}`
    -   **LogConfig** - Log configuration for the container, specified as a JSON object in the form
          `{ "Type": "<driver_name>", "Config": {"key1": "val1"}}`.
          Available types: `json-file`, `syslog`, `journald`, `gelf`, `fluentd`, `awslogs`, `splunk`, `etwlogs`, `none`.
          `json-file` logging driver.
    -   **CgroupParent** - Path to `cgroups` under which the container's `cgroup` is created. If the path is not absolute, the path is considered to be relative to the `cgroups` path of the init process. Cgroups are created if they do not already exist.
    -   **VolumeDriver** - Driver that this container users to mount volumes.
    -   **ShmSize** - Size of `/dev/shm` in bytes. The size must be greater than 0.  If omitted the system uses 64MB.

**Query parameters**:

-   **name** ‚Äì Assign the specified name to the container. Must
    match `/?[a-zA-Z0-9_-]+`.

**Status codes**:

-   **201** ‚Äì no error
-   **400** ‚Äì bad parameter
-   **404** ‚Äì no such container
-   **406** ‚Äì impossible to attach (container not running)
-   **409** ‚Äì conflict
-   **500** ‚Äì server error

### Inspect a container

`GET /containers/(id or name)/json`

Return low-level information on the container `id`

**Example request**:

      GET /containers/4fa6e0f0c678/json HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

	{
		"AppArmorProfile": "",
		"Args": [
			"-c",
			"exit 9"
		],
		"Config": {
			"AttachStderr": true,
			"AttachStdin": false,
			"AttachStdout": true,
			"Cmd": [
				"/bin/sh",
				"-c",
				"exit 9"
			],
			"Domainname": "",
			"Entrypoint": null,
			"Env": [
				"PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
			],
			"ExposedPorts": null,
			"Hostname": "ba033ac44011",
			"Image": "ubuntu",
			"Labels": {
				"com.example.vendor": "Acme",
				"com.example.license": "GPL",
				"com.example.version": "1.0"
			},
			"MacAddress": "",
			"NetworkDisabled": false,
			"OnBuild": null,
			"OpenStdin": false,
			"StdinOnce": false,
			"Tty": false,
			"User": "",
			"Volumes": {
				"/volumes/data": {}
			},
			"WorkingDir": "",
			"StopSignal": "SIGTERM"
		},
		"Created": "2015-01-06T15:47:31.485331387Z",
		"Driver": "devicemapper",
		"ExecIDs": null,
		"HostConfig": {
			"Binds": null,
			"IOMaximumBandwidth": 0,
			"IOMaximumIOps": 0,
			"BlkioWeight": 0,
			"BlkioWeightDevice": [{}],
			"BlkioDeviceReadBps": [{}],
			"BlkioDeviceWriteBps": [{}],
			"BlkioDeviceReadIOps": [{}],
			"BlkioDeviceWriteIOps": [{}],
			"CapAdd": null,
			"CapDrop": null,
			"ContainerIDFile": "",
			"CpusetCpus": "",
			"CpusetMems": "",
			"CpuPercent": 80,
			"CpuShares": 0,
			"CpuPeriod": 100000,
			"Devices": [],
			"Dns": null,
			"DnsOptions": null,
			"DnsSearch": null,
			"ExtraHosts": null,
			"IpcMode": "",
			"Links": null,
			"LxcConf": [],
			"Memory": 0,
			"MemorySwap": 0,
			"MemoryReservation": 0,
			"KernelMemory": 0,
			"OomKillDisable": false,
			"OomScoreAdj": 500,
			"NetworkMode": "bridge",
			"PidMode": "",
			"PortBindings": {},
			"Privileged": false,
			"ReadonlyRootfs": false,
			"PublishAllPorts": false,
			"RestartPolicy": {
				"MaximumRetryCount": 2,
				"Name": "on-failure"
			},
			"AutoRemove": true,
			"LogConfig": {
				"Config": null,
				"Type": "json-file"
			},
			"SecurityOpt": null,
			"Sysctls": {
			        "net.ipv4.ip_forward": "1"
			},
			"StorageOpt": null,
			"VolumesFrom": null,
			"Ulimits": [{}],
			"VolumeDriver": "",
			"ShmSize": 67108864
		},
		"HostnamePath": "/var/lib/docker/containers/ba033ac4401106a3b513bc9d639eee123ad78ca3616b921167cd74b20e25ed39/hostname",
		"HostsPath": "/var/lib/docker/containers/ba033ac4401106a3b513bc9d639eee123ad78ca3616b921167cd74b20e25ed39/hosts",
		"LogPath": "/var/lib/docker/containers/1eb5fabf5a03807136561b3c00adcd2992b535d624d5e18b6cdc6a6844d9767b/1eb5fabf5a03807136561b3c00adcd2992b535d624d5e18b6cdc6a6844d9767b-json.log",
		"Id": "ba033ac4401106a3b513bc9d639eee123ad78ca3616b921167cd74b20e25ed39",
		"Image": "04c5d3b7b0656168630d3ba35d8889bd0e9caafcaeb3004d2bfbc47e7c5d35d2",
		"MountLabel": "",
		"Name": "/boring_euclid",
		"NetworkSettings": {
			"Bridge": "",
			"SandboxID": "",
			"HairpinMode": false,
			"LinkLocalIPv6Address": "",
			"LinkLocalIPv6PrefixLen": 0,
			"Ports": null,
			"SandboxKey": "",
			"SecondaryIPAddresses": null,
			"SecondaryIPv6Addresses": null,
			"EndpointID": "",
			"Gateway": "",
			"GlobalIPv6Address": "",
			"GlobalIPv6PrefixLen": 0,
			"IPAddress": "",
			"IPPrefixLen": 0,
			"IPv6Gateway": "",
			"MacAddress": "",
			"Networks": {
				"bridge": {
					"NetworkID": "7ea29fc1412292a2d7bba362f9253545fecdfa8ce9a6e37dd10ba8bee7129812",
					"EndpointID": "7587b82f0dada3656fda26588aee72630c6fab1536d36e394b2bfbcf898c971d",
					"Gateway": "172.17.0.1",
					"IPAddress": "172.17.0.2",
					"IPPrefixLen": 16,
					"IPv6Gateway": "",
					"GlobalIPv6Address": "",
					"GlobalIPv6PrefixLen": 0,
					"MacAddress": "02:42:ac:12:00:02"
				}
			}
		},
		"Path": "/bin/sh",
		"ProcessLabel": "",
		"ResolvConfPath": "/var/lib/docker/containers/ba033ac4401106a3b513bc9d639eee123ad78ca3616b921167cd74b20e25ed39/resolv.conf",
		"RestartCount": 1,
		"State": {
			"Error": "",
			"ExitCode": 9,
			"FinishedAt": "2015-01-06T15:47:32.080254511Z",
			"OOMKilled": false,
			"Dead": false,
			"Paused": false,
			"Pid": 0,
			"Restarting": false,
			"Running": true,
			"StartedAt": "2015-01-06T15:47:32.072697474Z",
			"Status": "running"
		},
		"Mounts": [
			{
				"Name": "fac362...80535",
				"Source": "/data",
				"Destination": "/data",
				"Driver": "local",
				"Mode": "ro,Z",
				"RW": false,
				"Propagation": ""
			}
		]
	}

**Example request, with size information**:

    GET /containers/4fa6e0f0c678/json?size=1 HTTP/1.1

**Example response, with size information**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
    ....
    "SizeRw": 0,
    "SizeRootFs": 972,
    ....
    }

**Query parameters**:

-   **size** ‚Äì 1/True/true or 0/False/false, return container size information. Default is `false`.

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### List processes running inside a container

`GET /containers/(id or name)/top`

List processes running inside the container `id`. On Unix systems this
is done by running the `ps` command. This endpoint is not
supported on Windows.

**Example request**:

    GET /containers/4fa6e0f0c678/top HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
       "Titles" : [
         "UID", "PID", "PPID", "C", "STIME", "TTY", "TIME", "CMD"
       ],
       "Processes" : [
         [
           "root", "13642", "882", "0", "17:03", "pts/0", "00:00:00", "/bin/bash"
         ],
         [
           "root", "13735", "13642", "0", "17:06", "pts/0", "00:00:00", "sleep 10"
         ]
       ]
    }

**Example request**:

    GET /containers/4fa6e0f0c678/top?ps_args=aux HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
      "Titles" : [
        "USER","PID","%CPU","%MEM","VSZ","RSS","TTY","STAT","START","TIME","COMMAND"
      ]
      "Processes" : [
        [
          "root","13642","0.0","0.1","18172","3184","pts/0","Ss","17:03","0:00","/bin/bash"
        ],
        [
          "root","13895","0.0","0.0","4348","692","pts/0","S+","17:15","0:00","sleep 10"
        ]
      ],
    }

**Query parameters**:

-   **ps_args** ‚Äì `ps` arguments to use (e.g., `aux`), defaults to `-ef`

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Get container logs

`GET /containers/(id or name)/logs`

Get `stdout` and `stderr` logs from the container ``id``

> **Note**:
> This endpoint works only for containers with the `json-file` or `journald` logging drivers.

**Example request**:

     GET /containers/4fa6e0f0c678/logs?stderr=1&stdout=1&timestamps=1&follow=1&tail=10&since=1428990821 HTTP/1.1

**Example response**:

     HTTP/1.1 101 UPGRADED
     Content-Type: application/vnd.docker.raw-stream
     Connection: Upgrade
     Upgrade: tcp

     {% raw %}
     {{ STREAM }}
     {% endraw %}

**Query parameters**:

-   **details** - 1/True/true or 0/False/flase, Show extra details provided to logs. Default `false`.
-   **follow** ‚Äì 1/True/true or 0/False/false, return stream. Default `false`.
-   **stdout** ‚Äì 1/True/true or 0/False/false, show `stdout` log. Default `false`.
-   **stderr** ‚Äì 1/True/true or 0/False/false, show `stderr` log. Default `false`.
-   **since** ‚Äì UNIX timestamp (integer) to filter logs. Specifying a timestamp
    will only output log-entries since that timestamp. Default: 0 (unfiltered)
-   **timestamps** ‚Äì 1/True/true or 0/False/false, print timestamps for
        every log line. Default `false`.
-   **tail** ‚Äì Output specified number of lines at the end of logs: `all` or `<number>`. Default all.

**Status codes**:

-   **101** ‚Äì no error, hints proxy about hijacking
-   **200** ‚Äì no error, no upgrade header found
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Inspect changes on a container's filesystem

`GET /containers/(id or name)/changes`

Inspect changes on container `id`'s filesystem

**Example request**:

    GET /containers/4fa6e0f0c678/changes HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    [
         {
                 "Path": "/dev",
                 "Kind": 0
         },
         {
                 "Path": "/dev/kmsg",
                 "Kind": 1
         },
         {
                 "Path": "/test",
                 "Kind": 1
         }
    ]

Values for `Kind`:

- `0`: Modify
- `1`: Add
- `2`: Delete

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Export a container

`GET /containers/(id or name)/export`

Export the contents of container `id`

**Example request**:

    GET /containers/4fa6e0f0c678/export HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/octet-stream

    {% raw %}
    {{ TAR STREAM }}
    {% endraw %}

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Get container stats based on resource usage

`GET /containers/(id or name)/stats`

This endpoint returns a live stream of a container's resource usage statistics.

**Example request**:

    GET /containers/redis1/stats HTTP/1.1

**Example response**:

      HTTP/1.1 200 OK
      Content-Type: application/json

      {
         "read" : "2015-01-08T22:57:31.547920715Z",
         "pids_stats": {
            "current": 3
         },
         "networks": {
                 "eth0": {
                     "rx_bytes": 5338,
                     "rx_dropped": 0,
                     "rx_errors": 0,
                     "rx_packets": 36,
                     "tx_bytes": 648,
                     "tx_dropped": 0,
                     "tx_errors": 0,
                     "tx_packets": 8
                 },
                 "eth5": {
                     "rx_bytes": 4641,
                     "rx_dropped": 0,
                     "rx_errors": 0,
                     "rx_packets": 26,
                     "tx_bytes": 690,
                     "tx_dropped": 0,
                     "tx_errors": 0,
                     "tx_packets": 9
                 }
         },
         "memory_stats" : {
            "stats" : {
               "total_pgmajfault" : 0,
               "cache" : 0,
               "mapped_file" : 0,
               "total_inactive_file" : 0,
               "pgpgout" : 414,
               "rss" : 6537216,
               "total_mapped_file" : 0,
               "writeback" : 0,
               "unevictable" : 0,
               "pgpgin" : 477,
               "total_unevictable" : 0,
               "pgmajfault" : 0,
               "total_rss" : 6537216,
               "total_rss_huge" : 6291456,
               "total_writeback" : 0,
               "total_inactive_anon" : 0,
               "rss_huge" : 6291456,
               "hierarchical_memory_limit" : 67108864,
               "total_pgfault" : 964,
               "total_active_file" : 0,
               "active_anon" : 6537216,
               "total_active_anon" : 6537216,
               "total_pgpgout" : 414,
               "total_cache" : 0,
               "inactive_anon" : 0,
               "active_file" : 0,
               "pgfault" : 964,
               "inactive_file" : 0,
               "total_pgpgin" : 477
            },
            "max_usage" : 6651904,
            "usage" : 6537216,
            "failcnt" : 0,
            "limit" : 67108864
         },
         "blkio_stats" : {},
         "cpu_stats" : {
            "cpu_usage" : {
               "percpu_usage" : [
                  8646879,
                  24472255,
                  36438778,
                  30657443
               ],
               "usage_in_usermode" : 50000000,
               "total_usage" : 100215355,
               "usage_in_kernelmode" : 30000000
            },
            "system_cpu_usage" : 739306590000000,
            "throttling_data" : {"periods":0,"throttled_periods":0,"throttled_time":0}
         },
         "precpu_stats" : {
            "cpu_usage" : {
               "percpu_usage" : [
                  8646879,
                  24350896,
                  36438778,
                  30657443
               ],
               "usage_in_usermode" : 50000000,
               "total_usage" : 100093996,
               "usage_in_kernelmode" : 30000000
            },
            "system_cpu_usage" : 9492140000000,
            "throttling_data" : {"periods":0,"throttled_periods":0,"throttled_time":0}
         }
      }

The precpu_stats is the cpu statistic of last read, which is used for calculating the cpu usage percent. It is not the exact copy of the ‚Äúcpu_stats‚Äù field.

**Query parameters**:

-   **stream** ‚Äì 1/True/true or 0/False/false, pull stats once then disconnect. Default `true`.

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Resize a container TTY

`POST /containers/(id or name)/resize`

Resize the TTY for container with  `id`. The unit is number of characters. You must restart the container for the resize to take effect.

**Example request**:

      POST /containers/4fa6e0f0c678/resize?h=40&w=80 HTTP/1.1

**Example response**:

      HTTP/1.1 200 OK
      Content-Length: 0
      Content-Type: text/plain; charset=utf-8

**Query parameters**:

-   **h** ‚Äì height of `tty` session
-   **w** ‚Äì width

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì No such container
-   **500** ‚Äì Cannot resize container

### Start a container

`POST /containers/(id or name)/start`

Start the container `id`

**Example request**:

    POST /containers/e90e34656806/start HTTP/1.1

**Example response**:

    HTTP/1.1 204 No Content

**Query parameters**:

-   **detachKeys** ‚Äì Override the key sequence for detaching a
        container. Format is a single character `[a-Z]` or `ctrl-<value>`
        where `<value>` is one of: `a-z`, `@`, `^`, `[`, `,` or `_`.

**Status codes**:

-   **204** ‚Äì no error
-   **304** ‚Äì container already started
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Stop a container

`POST /containers/(id or name)/stop`

Stop the container `id`

**Example request**:

    POST /containers/e90e34656806/stop?t=5 HTTP/1.1

**Example response**:

    HTTP/1.1 204 No Content

**Query parameters**:

-   **t** ‚Äì number of seconds to wait before killing the container

**Status codes**:

-   **204** ‚Äì no error
-   **304** ‚Äì container already stopped
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Restart a container

`POST /containers/(id or name)/restart`

Restart the container `id`

**Example request**:

    POST /containers/e90e34656806/restart?t=5 HTTP/1.1

**Example response**:

    HTTP/1.1 204 No Content

**Query parameters**:

-   **t** ‚Äì number of seconds to wait before killing the container

**Status codes**:

-   **204** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Kill a container

`POST /containers/(id or name)/kill`

Kill the container `id`

**Example request**:

    POST /containers/e90e34656806/kill HTTP/1.1

**Example response**:

    HTTP/1.1 204 No Content

**Query parameters**:

-   **signal** - Signal to send to the container: integer or string like `SIGINT`.
        When not set, `SIGKILL` is assumed and the call waits for the container to exit.

**Status codes**:

-   **204** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Update a container

`POST /containers/(id or name)/update`

Update configuration of one or more containers.

**Example request**:

       POST /containers/e90e34656806/update HTTP/1.1
       Content-Type: application/json

       {
         "BlkioWeight": 300,
         "CpuShares": 512,
         "CpuPeriod": 100000,
         "CpuQuota": 50000,
         "CpusetCpus": "0,1",
         "CpusetMems": "0",
         "Memory": 314572800,
         "MemorySwap": 514288000,
         "MemoryReservation": 209715200,
         "KernelMemory": 52428800,
         "RestartPolicy": {
           "MaximumRetryCount": 4,
           "Name": "on-failure"
         },
       }

**Example response**:

       HTTP/1.1 200 OK
       Content-Type: application/json

       {
           "Warnings": []
       }

**Status codes**:

-   **200** ‚Äì no error
-   **400** ‚Äì bad parameter
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Rename a container

`POST /containers/(id or name)/rename`

Rename the container `id` to a `new_name`

**Example request**:

    POST /containers/e90e34656806/rename?name=new_name HTTP/1.1

**Example response**:

    HTTP/1.1 204 No Content

**Query parameters**:

-   **name** ‚Äì new name for the container

**Status codes**:

-   **204** ‚Äì no error
-   **404** ‚Äì no such container
-   **409** - conflict name already assigned
-   **500** ‚Äì server error

### Pause a container

`POST /containers/(id or name)/pause`

Pause the container `id`

**Example request**:

    POST /containers/e90e34656806/pause HTTP/1.1

**Example response**:

    HTTP/1.1 204 No Content

**Status codes**:

-   **204** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Unpause a container

`POST /containers/(id or name)/unpause`

Unpause the container `id`

**Example request**:

    POST /containers/e90e34656806/unpause HTTP/1.1

**Example response**:

    HTTP/1.1 204 No Content

**Status codes**:

-   **204** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Attach to a container

`POST /containers/(id or name)/attach`

Attach to the container `id`

**Example request**:

    POST /containers/16253994b7c4/attach?logs=1&stream=0&stdout=1 HTTP/1.1

**Example response**:

    HTTP/1.1 101 UPGRADED
    Content-Type: application/vnd.docker.raw-stream
    Connection: Upgrade
    Upgrade: tcp

    {% raw %}
    {{ STREAM }}
    {% endraw %}

**Query parameters**:

-   **detachKeys** ‚Äì Override the key sequence for detaching a
        container. Format is a single character `[a-Z]` or `ctrl-<value>`
        where `<value>` is one of: `a-z`, `@`, `^`, `[`, `,` or `_`.
-   **logs** ‚Äì 1/True/true or 0/False/false, return logs. Default `false`.
-   **stream** ‚Äì 1/True/true or 0/False/false, return stream.
        Default `false`.
-   **stdin** ‚Äì 1/True/true or 0/False/false, if `stream=true`, attach
        to `stdin`. Default `false`.
-   **stdout** ‚Äì 1/True/true or 0/False/false, if `logs=true`, return
        `stdout` log, if `stream=true`, attach to `stdout`. Default `false`.
-   **stderr** ‚Äì 1/True/true or 0/False/false, if `logs=true`, return
        `stderr` log, if `stream=true`, attach to `stderr`. Default `false`.

**Status codes**:

-   **101** ‚Äì no error, hints proxy about hijacking
-   **200** ‚Äì no error, no upgrade header found
-   **400** ‚Äì bad parameter
-   **404** ‚Äì no such container
-   **409** - container is paused
-   **500** ‚Äì server error

**Stream details**:

When using the TTY setting is enabled in
[`POST /containers/create`
](docker_remote_api_v1.25.md#create-a-container),
the stream is the raw data from the process PTY and client's `stdin`.
When the TTY is disabled, then the stream is multiplexed to separate
`stdout` and `stderr`.

The format is a **Header** and a **Payload** (frame).

**HEADER**

The header contains the information which the stream writes (`stdout` or
`stderr`). It also contains the size of the associated frame encoded in the
last four bytes (`uint32`).

It is encoded on the first eight bytes like this:

    header := [8]byte{STREAM_TYPE, 0, 0, 0, SIZE1, SIZE2, SIZE3, SIZE4}

`STREAM_TYPE` can be:

-   0: `stdin` (is written on `stdout`)
-   1: `stdout`
-   2: `stderr`

`SIZE1, SIZE2, SIZE3, SIZE4` are the four bytes of
the `uint32` size encoded as big endian.

**PAYLOAD**

The payload is the raw stream.

**IMPLEMENTATION**

The simplest way to implement the Attach protocol is the following:

    1.  Read eight bytes.
    2.  Choose `stdout` or `stderr` depending on the first byte.
    3.  Extract the frame size from the last four bytes.
    4.  Read the extracted size and output it on the correct output.
    5.  Goto 1.

### Attach to a container (websocket)

`GET /containers/(id or name)/attach/ws`

Attach to the container `id` via websocket

Implements websocket protocol handshake according to [RFC 6455](http://tools.ietf.org/html/rfc6455)

**Example request**

    GET /containers/e90e34656806/attach/ws?logs=0&stream=1&stdin=1&stdout=1&stderr=1 HTTP/1.1

**Example response**

    {% raw %}
    {{ STREAM }}
    {% endraw %}

**Query parameters**:

-   **detachKeys** ‚Äì Override the key sequence for detaching a
        container. Format is a single character `[a-Z]` or `ctrl-<value>`
        where `<value>` is one of: `a-z`, `@`, `^`, `[`, `,` or `_`.
-   **logs** ‚Äì 1/True/true or 0/False/false, return logs. Default `false`.
-   **stream** ‚Äì 1/True/true or 0/False/false, return stream.
        Default `false`.
-   **stdin** ‚Äì 1/True/true or 0/False/false, if `stream=true`, attach
        to `stdin`. Default `false`.
-   **stdout** ‚Äì 1/True/true or 0/False/false, if `logs=true`, return
        `stdout` log, if `stream=true`, attach to `stdout`. Default `false`.
-   **stderr** ‚Äì 1/True/true or 0/False/false, if `logs=true`, return
        `stderr` log, if `stream=true`, attach to `stderr`. Default `false`.

**Status codes**:

-   **200** ‚Äì no error
-   **400** ‚Äì bad parameter
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Wait a container

`POST /containers/(id or name)/wait`

Block until container `id` stops, then returns the exit code

**Example request**:

    POST /containers/16253994b7c4/wait HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {"StatusCode": 0}

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Remove a container

`DELETE /containers/(id or name)`

Remove the container `id` from the filesystem

**Example request**:

    DELETE /containers/16253994b7c4?v=1 HTTP/1.1

**Example response**:

    HTTP/1.1 204 No Content

**Query parameters**:

-   **v** ‚Äì 1/True/true or 0/False/false, Remove the volumes
        associated to the container. Default `false`.
-   **force** - 1/True/true or 0/False/false, Kill then remove the container.
        Default `false`.

**Status codes**:

-   **204** ‚Äì no error
-   **400** ‚Äì bad parameter
-   **404** ‚Äì no such container
-   **409** ‚Äì conflict
-   **500** ‚Äì server error

### Retrieving information about files and folders in a container

`HEAD /containers/(id or name)/archive`

See the description of the `X-Docker-Container-Path-Stat` header in the
following section.

### Get an archive of a filesystem resource in a container

`GET /containers/(id or name)/archive`

Get a tar archive of a resource in the filesystem of container `id`.

**Query parameters**:

- **path** - resource in the container's filesystem to archive. Required.

    If not an absolute path, it is relative to the container's root directory.
    The resource specified by **path** must exist. To assert that the resource
    is expected to be a directory, **path** should end in `/` or  `/.`
    (assuming a path separator of `/`). If **path** ends in `/.` then this
    indicates that only the contents of the **path** directory should be
    copied. A symlink is always resolved to its target.

    > **Note**: It is not possible to copy certain system files such as resources
    > under `/proc`, `/sys`, `/dev`, and mounts created by the user in the
    > container.

**Example request**:

    GET /containers/8cce319429b2/archive?path=/root HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/x-tar
    X-Docker-Container-Path-Stat: eyJuYW1lIjoicm9vdCIsInNpemUiOjQwOTYsIm1vZGUiOjIxNDc0ODQwOTYsIm10aW1lIjoiMjAxNC0wMi0yN1QyMDo1MToyM1oiLCJsaW5rVGFyZ2V0IjoiIn0=

    {% raw %}
    {{ TAR STREAM }}
    {% endraw %}

On success, a response header `X-Docker-Container-Path-Stat` will be set to a
base64-encoded JSON object containing some filesystem header information about
the archived resource. The above example value would decode to the following
JSON object (whitespace added for readability):

```json
{
    "name": "root",
    "size": 4096,
    "mode": 2147484096,
    "mtime": "2014-02-27T20:51:23Z",
    "linkTarget": ""
}
```

A `HEAD` request can also be made to this endpoint if only this information is
desired.

**Status codes**:

- **200** - success, returns archive of copied resource
- **400** - client error, bad parameter, details in JSON response body, one of:
    - must specify path parameter (**path** cannot be empty)
    - not a directory (**path** was asserted to be a directory but exists as a
      file)
- **404** - client error, resource not found, one of:
    ‚Äì no such container (container `id` does not exist)
    - no such file or directory (**path** does not exist)
- **500** - server error

### Extract an archive of files or folders to a directory in a container

`PUT /containers/(id or name)/archive`

Upload a tar archive to be extracted to a path in the filesystem of container
`id`.

**Query parameters**:

- **path** - path to a directory in the container
    to extract the archive's contents into. Required.

    If not an absolute path, it is relative to the container's root directory.
    The **path** resource must exist.
- **noOverwriteDirNonDir** - If "1", "true", or "True" then it will be an error
    if unpacking the given content would cause an existing directory to be
    replaced with a non-directory and vice versa.

**Example request**:

    PUT /containers/8cce319429b2/archive?path=/vol1 HTTP/1.1
    Content-Type: application/x-tar

    {% raw %}
    {{ TAR STREAM }}
    {% endraw %}

**Example response**:

    HTTP/1.1 200 OK

**Status codes**:

- **200** ‚Äì the content was extracted successfully
- **400** - client error, bad parameter, details in JSON response body, one of:
    - must specify path parameter (**path** cannot be empty)
    - not a directory (**path** should be a directory but exists as a file)
    - unable to overwrite existing directory with non-directory
      (if **noOverwriteDirNonDir**)
    - unable to overwrite existing non-directory with directory
      (if **noOverwriteDirNonDir**)
- **403** - client error, permission denied, the volume
    or container rootfs is marked as read-only.
- **404** - client error, resource not found, one of:
    ‚Äì no such container (container `id` does not exist)
    - no such file or directory (**path** resource does not exist)
- **500** ‚Äì server error

## 3.2 Images

### List Images

`GET /images/json`

**Example request**:

    GET /images/json?all=0 HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    [
      {
         "RepoTags": [
           "ubuntu:12.04",
           "ubuntu:precise",
           "ubuntu:latest"
         ],
         "Id": "8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c",
         "Created": 1365714795,
         "Size": 131506275,
         "VirtualSize": 131506275,
         "Labels": {}
      },
      {
         "RepoTags": [
           "ubuntu:12.10",
           "ubuntu:quantal"
         ],
         "ParentId": "27cf784147099545",
         "Id": "b750fe79269d2ec9a3c593ef05b4332b1d1a02a62b4accb2c21d589ff2f5f2dc",
         "Created": 1364102658,
         "Size": 24653,
         "VirtualSize": 180116135,
         "Labels": {
            "com.example.version": "v1"
         }
      }
    ]

**Example request, with digest information**:

    GET /images/json?digests=1 HTTP/1.1

**Example response, with digest information**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    [
      {
        "Created": 1420064636,
        "Id": "4986bf8c15363d1c5d15512d5266f8777bfba4974ac56e3270e7760f6f0a8125",
        "ParentId": "ea13149945cb6b1e746bf28032f02e9b5a793523481a0a18645fc77ad53c4ea2",
        "RepoDigests": [
          "localhost:5000/test/busybox@sha256:cbbf2f9a99b47fc460d422812b6a5adff7dfee951d8fa2e4a98caa0382cfbdbf"
        ],
        "RepoTags": [
          "localhost:5000/test/busybox:latest",
          "playdate:latest"
        ],
        "Size": 0,
        "VirtualSize": 2429728,
        "Labels": {}
      }
    ]

The response shows a single image `Id` associated with two repositories
(`RepoTags`): `localhost:5000/test/busybox`: and `playdate`. A caller can use
either of the `RepoTags` values `localhost:5000/test/busybox:latest` or
`playdate:latest` to reference the image.

You can also use `RepoDigests` values to reference an image. In this response,
the array has only one reference and that is to the
`localhost:5000/test/busybox` repository; the `playdate` repository has no
digest. You can reference this digest using the value:
`localhost:5000/test/busybox@sha256:cbbf2f9a99b47fc460d...`

See the `docker run` and `docker build` commands for examples of digest and tag
references on the command line.

**Query parameters**:

-   **all** ‚Äì 1/True/true or 0/False/false, default false
-   **filters** ‚Äì a JSON encoded value of the filters (a map[string][]string) to process on the images list. Available filters:
  -   `dangling=true`
  -   `label=key` or `label="key=value"` of an image label
  -   `before`=(`<image-name>[:<tag>]`,  `<image id>` or `<image@digest>`)
  -   `since`=(`<image-name>[:<tag>]`,  `<image id>` or `<image@digest>`)
-   **filter** - only return images with the specified name

### Build image from a Dockerfile

`POST /build`

Build an image from a Dockerfile

**Example request**:

    POST /build HTTP/1.1

    {% raw %}
    {{ TAR STREAM }}
    {% endraw %}

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {"stream": "Step 1..."}
    {"stream": "..."}
    {"error": "Error...", "errorDetail": {"code": 123, "message": "Error..."}}

The input stream must be a `tar` archive compressed with one of the
following algorithms: `identity` (no compression), `gzip`, `bzip2`, `xz`.

The archive must include a build instructions file, typically called
`Dockerfile` at the archive's root. The `dockerfile` parameter may be
used to specify a different build instructions file. To do this, its value must be
the path to the alternate build instructions file to use.

The archive may include any number of other files,
which are accessible in the build context (See the [*ADD build
command*](../../reference/builder.md#add)).

The build is canceled if the client drops the connection by quitting
or being killed.

**Query parameters**:

-   **dockerfile** - Path within the build context to the `Dockerfile`. This is
        ignored if `remote` is specified and points to an external `Dockerfile`.
-   **t** ‚Äì A name and optional tag to apply to the image in the `name:tag` format.
        If you omit the `tag` the default `latest` value is assumed.
        You can provide one or more `t` parameters.
-   **remote** ‚Äì A Git repository URI or HTTP/HTTPS context URI. If the
        URI points to a single text file, the file's contents are placed into
        a file called `Dockerfile` and the image is built from that file. If
        the URI points to a tarball, the file is downloaded by the daemon and
        the contents therein used as the context for the build. If the URI
        points to a tarball and the `dockerfile` parameter is also specified,
        there must be a file with the corresponding path inside the tarball.
-   **q** ‚Äì Suppress verbose build output.
-   **nocache** ‚Äì Do not use the cache when building the image.
-   **pull** - Attempt to pull the image even if an older image exists locally.
-   **rm** - Remove intermediate containers after a successful build (default behavior).
-   **forcerm** - Always remove intermediate containers (includes `rm`).
-   **memory** - Set memory limit for build.
-   **memswap** - Total memory (memory + swap), `-1` to enable unlimited swap.
-   **cpushares** - CPU shares (relative weight).
-   **cpusetcpus** - CPUs in which to allow execution (e.g., `0-3`, `0,1`).
-   **cpuperiod** - The length of a CPU period in microseconds.
-   **cpuquota** - Microseconds of CPU time that the container can get in a CPU period.
-   **buildargs** ‚Äì JSON map of string pairs for build-time variables. Users pass
        these values at build-time. Docker uses the `buildargs` as the environment
        context for command(s) run via the Dockerfile's `RUN` instruction or for
        variable expansion in other Dockerfile instructions. This is not meant for
        passing secret values. [Read more about the buildargs instruction](../../reference/builder.md#arg)
-   **shmsize** - Size of `/dev/shm` in bytes. The size must be greater than 0.  If omitted the system uses 64MB.
-   **labels** ‚Äì JSON map of string pairs for labels to set on the image.

**Request Headers**:

-   **Content-type** ‚Äì Set to `"application/tar"`.
-   **X-Registry-Config** ‚Äì A base64-url-safe-encoded Registry Auth Config JSON
        object with the following structure:

            {
                "docker.example.com": {
                    "username": "janedoe",
                    "password": "hunter2"
                },
                "https://index.docker.io/v1/": {
                    "username": "mobydock",
                    "password": "conta1n3rize14"
                }
            }

    This object maps the hostname of a registry to an object containing the
    "username" and "password" for that registry. Multiple registries may
    be specified as the build may be based on an image requiring
    authentication to pull from any arbitrary registry. Only the registry
    domain name (and port if not the default "443") are required. However
    (for legacy reasons) the "official" Docker, Inc. hosted registry must
    be specified with both a "https://" prefix and a "/v1/" suffix even
    though Docker will prefer to use the v2 registry API.

**Status codes**:

-   **200** ‚Äì no error
-   **500** ‚Äì server error

### Create an image

`POST /images/create`

Create an image either by pulling it from the registry or by importing it

**Example request**:

    POST /images/create?fromImage=busybox&tag=latest HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {"status":"Pulling from library/busybox","id":"latest"}
    {"status":"Pulling fs layer","progressDetail":{},"id":"8ddc19f16526"}
    {"status":"Downloading","progressDetail":{"current":15881,"total":667590},"progress":"[=\u003e                                                 ] 15.88 kB/667.6 kB","id":"8ddc19f16526"}
    {"status":"Downloading","progressDetail":{"current":556269,"total":667590},"progress":"[=========================================\u003e         ] 556.3 kB/667.6 kB","id":"8ddc19f16526"}
    {"status":"Download complete","progressDetail":{},"id":"8ddc19f16526"}
    {"status":"Extracting","progressDetail":{"current":32768,"total":667590},"progress":"[==\u003e                                                ] 32.77 kB/667.6 kB","id":"8ddc19f16526"}
    {"status":"Extracting","progressDetail":{"current":491520,"total":667590},"progress":"[====================================\u003e              ] 491.5 kB/667.6 kB","id":"8ddc19f16526"}
    {"status":"Extracting","progressDetail":{"current":667590,"total":667590},"progress":"[==================================================\u003e] 667.6 kB/667.6 kB","id":"8ddc19f16526"}
    {"status":"Extracting","progressDetail":{"current":667590,"total":667590},"progress":"[==================================================\u003e] 667.6 kB/667.6 kB","id":"8ddc19f16526"}
    {"status":"Pull complete","progressDetail":{},"id":"8ddc19f16526"}
    {"status":"Digest: sha256:a59906e33509d14c036c8678d687bd4eec81ed7c4b8ce907b888c607f6a1e0e6"}
    {"status":"Status: Downloaded newer image for busybox:latest"}
    ...

When using this endpoint to pull an image from the registry, the
`X-Registry-Auth` header can be used to include
a base64-encoded AuthConfig object.

**Query parameters**:

-   **fromImage** ‚Äì Name of the image to pull. The name may include a tag or
        digest. This parameter may only be used when pulling an image.
        The pull is cancelled if the HTTP connection is closed.
-   **fromSrc** ‚Äì Source to import.  The value may be a URL from which the image
        can be retrieved or `-` to read the image from the request body.
        This parameter may only be used when importing an image.
-   **repo** ‚Äì Repository name given to an image when it is imported.
        The repo may include a tag. This parameter may only be used when importing
        an image.
-   **tag** ‚Äì Tag or digest. If empty when pulling an image, this causes all tags
        for the given image to be pulled.

**Request Headers**:

-   **X-Registry-Auth** ‚Äì base64-encoded AuthConfig object, containing either login information, or a token
    - Credential based login:

        ```
    {
            "username": "jdoe",
            "password": "secret",
            "email": "jdoe@acme.com"
    }
        ```

    - Token based login:

        ```
    {
            "identitytoken": "9cbaf023786cd7..."
    }
        ```

**Status codes**:

-   **200** ‚Äì no error
-   **500** ‚Äì server error



### Inspect an image

`GET /images/(name)/json`

Return low-level information on the image `name`

**Example request**:

    GET /images/example/json HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
       "Id" : "sha256:85f05633ddc1c50679be2b16a0479ab6f7637f8884e0cfe0f4d20e1ebb3d6e7c",
       "Container" : "cb91e48a60d01f1e27028b4fc6819f4f290b3cf12496c8176ec714d0d390984a",
       "Comment" : "",
       "Os" : "linux",
       "Architecture" : "amd64",
       "Parent" : "sha256:91e54dfb11794fad694460162bf0cb0a4fa710cfa3f60979c177d920813e267c",
       "ContainerConfig" : {
          "Tty" : false,
          "Hostname" : "e611e15f9c9d",
          "Volumes" : null,
          "Domainname" : "",
          "AttachStdout" : false,
          "PublishService" : "",
          "AttachStdin" : false,
          "OpenStdin" : false,
          "StdinOnce" : false,
          "NetworkDisabled" : false,
          "OnBuild" : [],
          "Image" : "91e54dfb11794fad694460162bf0cb0a4fa710cfa3f60979c177d920813e267c",
          "User" : "",
          "WorkingDir" : "",
          "Entrypoint" : null,
          "MacAddress" : "",
          "AttachStderr" : false,
          "Labels" : {
             "com.example.license" : "GPL",
             "com.example.version" : "1.0",
             "com.example.vendor" : "Acme"
          },
          "Env" : [
             "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
          ],
          "ExposedPorts" : null,
          "Cmd" : [
             "/bin/sh",
             "-c",
             "#(nop) LABEL com.example.vendor=Acme com.example.license=GPL com.example.version=1.0"
          ]
       },
       "DockerVersion" : "1.9.0-dev",
       "VirtualSize" : 188359297,
       "Size" : 0,
       "Author" : "",
       "Created" : "2015-09-10T08:30:53.26995814Z",
       "GraphDriver" : {
          "Name" : "aufs",
          "Data" : null
       },
       "RepoDigests" : [
          "localhost:5000/test/busybox/example@sha256:cbbf2f9a99b47fc460d422812b6a5adff7dfee951d8fa2e4a98caa0382cfbdbf"
       ],
       "RepoTags" : [
          "example:1.0",
          "example:latest",
          "example:stable"
       ],
       "Config" : {
          "Image" : "91e54dfb11794fad694460162bf0cb0a4fa710cfa3f60979c177d920813e267c",
          "NetworkDisabled" : false,
          "OnBuild" : [],
          "StdinOnce" : false,
          "PublishService" : "",
          "AttachStdin" : false,
          "OpenStdin" : false,
          "Domainname" : "",
          "AttachStdout" : false,
          "Tty" : false,
          "Hostname" : "e611e15f9c9d",
          "Volumes" : null,
          "Cmd" : [
             "/bin/bash"
          ],
          "ExposedPorts" : null,
          "Env" : [
             "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
          ],
          "Labels" : {
             "com.example.vendor" : "Acme",
             "com.example.version" : "1.0",
             "com.example.license" : "GPL"
          },
          "Entrypoint" : null,
          "MacAddress" : "",
          "AttachStderr" : false,
          "WorkingDir" : "",
          "User" : ""
       },
       "RootFS": {
           "Type": "layers",
           "Layers": [
               "sha256:1834950e52ce4d5a88a1bbd131c537f4d0e56d10ff0dd69e66be3b7dfa9df7e6",
               "sha256:5f70bf18a086007016e948b04aed3b82103a36bea41755b6cddfaf10ace3c6ef"
           ]
       }
    }

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such image
-   **500** ‚Äì server error

### Get the history of an image

`GET /images/(name)/history`

Return the history of the image `name`

**Example request**:

    GET /images/ubuntu/history HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    [
        {
            "Id": "3db9c44f45209632d6050b35958829c3a2aa256d81b9a7be45b362ff85c54710",
            "Created": 1398108230,
            "CreatedBy": "/bin/sh -c #(nop) ADD file:eb15dbd63394e063b805a3c32ca7bf0266ef64676d5a6fab4801f2e81e2a5148 in /",
            "Tags": [
                "ubuntu:lucid",
                "ubuntu:10.04"
            ],
            "Size": 182964289,
            "Comment": ""
        },
        {
            "Id": "6cfa4d1f33fb861d4d114f43b25abd0ac737509268065cdfd69d544a59c85ab8",
            "Created": 1398108222,
            "CreatedBy": "/bin/sh -c #(nop) MAINTAINER Tianon Gravi <admwiggin@gmail.com> - mkimage-debootstrap.sh -i iproute,iputils-ping,ubuntu-minimal -t lucid.tar.xz lucid http://archive.ubuntu.com/ubuntu/",
            "Tags": null,
            "Size": 0,
            "Comment": ""
        },
        {
            "Id": "511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158",
            "Created": 1371157430,
            "CreatedBy": "",
            "Tags": [
                "scratch12:latest",
                "scratch:latest"
            ],
            "Size": 0,
            "Comment": "Imported from -"
        }
    ]

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such image
-   **500** ‚Äì server error

### Push an image on the registry

`POST /images/(name)/push`

Push the image `name` on the registry

**Example request**:

    POST /images/test/push HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {"status": "Pushing..."}
    {"status": "Pushing", "progress": "1/? (n/a)", "progressDetail": {"current": 1}}}
    {"error": "Invalid..."}
    ...

If you wish to push an image on to a private registry, that image must already have a tag
into a repository which references that registry `hostname` and `port`.  This repository name should
then be used in the URL. This duplicates the command line's flow.

The push is cancelled if the HTTP connection is closed.

**Example request**:

    POST /images/registry.acme.com:5000/test/push HTTP/1.1


**Query parameters**:

-   **tag** ‚Äì The tag to associate with the image on the registry. This is optional.

**Request Headers**:

-   **X-Registry-Auth** ‚Äì base64-encoded AuthConfig object, containing either login information, or a token
    - Credential based login:

        ```
    {
            "username": "jdoe",
            "password": "secret",
            "email": "jdoe@acme.com",
    }
        ```

    - Identity token based login:

        ```
    {
            "identitytoken": "9cbaf023786cd7..."
    }
        ```

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such image
-   **500** ‚Äì server error

### Tag an image into a repository

`POST /images/(name)/tag`

Tag the image `name` into a repository

**Example request**:

    POST /images/test/tag?repo=myrepo&tag=v42 HTTP/1.1

**Example response**:

    HTTP/1.1 201 Created

**Query parameters**:

-   **repo** ‚Äì The repository to tag in
-   **tag** - The new tag name

**Status codes**:

-   **201** ‚Äì no error
-   **400** ‚Äì bad parameter
-   **404** ‚Äì no such image
-   **409** ‚Äì conflict
-   **500** ‚Äì server error

### Remove an image

`DELETE /images/(name)`

Remove the image `name` from the filesystem

**Example request**:

    DELETE /images/test HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-type: application/json

    [
     {"Untagged": "3e2f21a89f"},
     {"Deleted": "3e2f21a89f"},
     {"Deleted": "53b4f83ac9"}
    ]

**Query parameters**:

-   **force** ‚Äì 1/True/true or 0/False/false, default false
-   **noprune** ‚Äì 1/True/true or 0/False/false, default false

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such image
-   **409** ‚Äì conflict
-   **500** ‚Äì server error

### Search images

`GET /images/search`

Search for an image on [Docker Hub](https://hub.docker.com).

> **Note**:
> The response keys have changed from API v1.6 to reflect the JSON
> sent by the registry server to the docker daemon's request.

**Example request**:

    GET /images/search?term=sshd HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    [
            {
                "description": "",
                "is_official": false,
                "is_automated": false,
                "name": "wma55/u1210sshd",
                "star_count": 0
            },
            {
                "description": "",
                "is_official": false,
                "is_automated": false,
                "name": "jdswinbank/sshd",
                "star_count": 0
            },
            {
                "description": "",
                "is_official": false,
                "is_automated": false,
                "name": "vgauthier/sshd",
                "star_count": 0
            }
    ...
    ]

**Query parameters**:

-   **term** ‚Äì term to search
-   **limit** ‚Äì maximum returned search results
-   **filters** ‚Äì a JSON encoded value of the filters (a map[string][]string) to process on the images list. Available filters:
  -   `stars=<number>`
  -   `is-automated=(true|false)`
  -   `is-official=(true|false)`

**Status codes**:

-   **200** ‚Äì no error
-   **500** ‚Äì server error

## 3.3 Misc

### Check auth configuration

`POST /auth`

Validate credentials for a registry and get identity token,
if available, for accessing the registry without password.

**Example request**:

    POST /auth HTTP/1.1
    Content-Type: application/json

    {
         "username": "hannibal",
         "password": "xxxx",
         "serveraddress": "https://index.docker.io/v1/"
    }

**Example response**:

    HTTP/1.1 200 OK

    {
         "Status": "Login Succeeded",
         "IdentityToken": "9cbaf023786cd7..."
    }

**Status codes**:

-   **200** ‚Äì no error
-   **204** ‚Äì no error
-   **500** ‚Äì server error

### Display system-wide information

`GET /info`

Display system-wide information

**Example request**:

    GET /info HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
        "Architecture": "x86_64",
        "ClusterStore": "etcd://localhost:2379",
        "CgroupDriver": "cgroupfs",
        "Containers": 11,
        "ContainersRunning": 7,
        "ContainersStopped": 3,
        "ContainersPaused": 1,
        "CpuCfsPeriod": true,
        "CpuCfsQuota": true,
        "Debug": false,
        "DockerRootDir": "/var/lib/docker",
        "Driver": "btrfs",
        "DriverStatus": [[""]],
        "ExperimentalBuild": false,
        "HttpProxy": "http://test:test@localhost:8080",
        "HttpsProxy": "https://test:test@localhost:8080",
        "ID": "7TRN:IPZB:QYBB:VPBQ:UMPP:KARE:6ZNR:XE6T:7EWV:PKF4:ZOJD:TPYS",
        "IPv4Forwarding": true,
        "Images": 16,
        "IndexServerAddress": "https://index.docker.io/v1/",
        "InitPath": "/usr/bin/docker",
        "InitSha1": "",
        "KernelMemory": true,
        "KernelVersion": "3.12.0-1-amd64",
        "Labels": [
            "storage=ssd"
        ],
        "MemTotal": 2099236864,
        "MemoryLimit": true,
        "NCPU": 1,
        "NEventsListener": 0,
        "NFd": 11,
        "NGoroutines": 21,
        "Name": "prod-server-42",
        "NoProxy": "9.81.1.160",
        "OomKillDisable": true,
        "OSType": "linux",
        "OperatingSystem": "Boot2Docker",
        "Plugins": {
            "Volume": [
                "local"
            ],
            "Network": [
                "null",
                "host",
                "bridge"
            ]
        },
        "RegistryConfig": {
            "IndexConfigs": {
                "docker.io": {
                    "Mirrors": null,
                    "Name": "docker.io",
                    "Official": true,
                    "Secure": true
                }
            },
            "InsecureRegistryCIDRs": [
                "127.0.0.0/8"
            ]
        },
        "SecurityOptions": [
            "apparmor",
            "seccomp",
            "selinux"
        ],
        "ServerVersion": "1.9.0",
        "SwapLimit": false,
        "SystemStatus": [["State", "Healthy"]],
        "SystemTime": "2015-03-10T11:11:23.730591467-07:00"
    }

**Status codes**:

-   **200** ‚Äì no error
-   **500** ‚Äì server error

### Show the docker version information

`GET /version`

Show the docker version information

**Example request**:

    GET /version HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
         "Version": "1.13.0",
         "Os": "linux",
         "KernelVersion": "3.19.0-23-generic",
         "GoVersion": "go1.6.3",
         "GitCommit": "deadbee",
         "Arch": "amd64",
         "ApiVersion": "1.25",
         "BuildTime": "2016-06-14T07:09:13.444803460+00:00",
         "Experimental": true
    }

**Status codes**:

-   **200** ‚Äì no error
-   **500** ‚Äì server error

### Ping the docker server

`GET /_ping`

Ping the docker server

**Example request**:

    GET /_ping HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: text/plain

    OK

**Status codes**:

-   **200** - no error
-   **500** - server error

### Create a new image from a container's changes

`POST /commit`

Create a new image from a container's changes

**Example request**:

    POST /commit?container=44c004db4b17&comment=message&repo=myrepo HTTP/1.1
    Content-Type: application/json

    {
         "Hostname": "",
         "Domainname": "",
         "User": "",
         "AttachStdin": false,
         "AttachStdout": true,
         "AttachStderr": true,
         "Tty": false,
         "OpenStdin": false,
         "StdinOnce": false,
         "Env": null,
         "Cmd": [
                 "date"
         ],
         "Mounts": [
           {
             "Source": "/data",
             "Destination": "/data",
             "Mode": "ro,Z",
             "RW": false
           }
         ],
         "Labels": {
                 "key1": "value1",
                 "key2": "value2"
          },
         "WorkingDir": "",
         "NetworkDisabled": false,
         "ExposedPorts": {
                 "22/tcp": {}
         }
    }

**Example response**:

    HTTP/1.1 201 Created
    Content-Type: application/json

    {"Id": "596069db4bf5"}

**JSON parameters**:

-  **config** - the container's configuration

**Query parameters**:

-   **container** ‚Äì source container
-   **repo** ‚Äì repository
-   **tag** ‚Äì tag
-   **comment** ‚Äì commit message
-   **author** ‚Äì author (e.g., "John Hannibal Smith
    <[hannibal@a-team.com](mailto:hannibal%40a-team.com)>")
-   **pause** ‚Äì 1/True/true or 0/False/false, whether to pause the container before committing
-   **changes** ‚Äì Dockerfile instructions to apply while committing

**Status codes**:

-   **201** ‚Äì no error
-   **404** ‚Äì no such container
-   **500** ‚Äì server error

### Monitor Docker's events

`GET /events`

Get container events from docker, in real time via streaming.

Docker containers report the following events:

    attach, commit, copy, create, destroy, detach, die, exec_create, exec_detach, exec_start, export, kill, oom, pause, rename, resize, restart, start, stop, top, unpause, update

Docker images report the following events:

    delete, import, load, pull, push, save, tag, untag

Docker volumes report the following events:

    create, mount, unmount, destroy

Docker networks report the following events:

    create, connect, disconnect, destroy

Docker daemon report the following event:

    reload

**Example request**:

    GET /events?since=1374067924

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json
    Server: Docker/1.11.0 (linux)
    Date: Fri, 29 Apr 2016 15:18:06 GMT
    Transfer-Encoding: chunked

    {
      "status": "pull",
      "id": "alpine:latest",
      "Type": "image",
      "Action": "pull",
      "Actor": {
        "ID": "alpine:latest",
        "Attributes": {
          "name": "alpine"
        }
      },
      "time": 1461943101,
      "timeNano": 1461943101301854122
    }
    {
      "status": "create",
      "id": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
      "from": "alpine",
      "Type": "container",
      "Action": "create",
      "Actor": {
        "ID": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
        "Attributes": {
          "com.example.some-label": "some-label-value",
          "image": "alpine",
          "name": "my-container"
        }
      },
      "time": 1461943101,
      "timeNano": 1461943101381709551
    }
    {
      "status": "attach",
      "id": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
      "from": "alpine",
      "Type": "container",
      "Action": "attach",
      "Actor": {
        "ID": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
        "Attributes": {
          "com.example.some-label": "some-label-value",
          "image": "alpine",
          "name": "my-container"
        }
      },
      "time": 1461943101,
      "timeNano": 1461943101383858412
    }
    {
      "Type": "network",
      "Action": "connect",
      "Actor": {
        "ID": "7dc8ac97d5d29ef6c31b6052f3938c1e8f2749abbd17d1bd1febf2608db1b474",
        "Attributes": {
          "container": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
          "name": "bridge",
          "type": "bridge"
        }
      },
      "time": 1461943101,
      "timeNano": 1461943101394865557
    }
    {
      "status": "start",
      "id": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
      "from": "alpine",
      "Type": "container",
      "Action": "start",
      "Actor": {
        "ID": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
        "Attributes": {
          "com.example.some-label": "some-label-value",
          "image": "alpine",
          "name": "my-container"
        }
      },
      "time": 1461943101,
      "timeNano": 1461943101607533796
    }
    {
      "status": "resize",
      "id": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
      "from": "alpine",
      "Type": "container",
      "Action": "resize",
      "Actor": {
        "ID": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
        "Attributes": {
          "com.example.some-label": "some-label-value",
          "height": "46",
          "image": "alpine",
          "name": "my-container",
          "width": "204"
        }
      },
      "time": 1461943101,
      "timeNano": 1461943101610269268
    }
    {
      "status": "die",
      "id": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
      "from": "alpine",
      "Type": "container",
      "Action": "die",
      "Actor": {
        "ID": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
        "Attributes": {
          "com.example.some-label": "some-label-value",
          "exitCode": "0",
          "image": "alpine",
          "name": "my-container"
        }
      },
      "time": 1461943105,
      "timeNano": 1461943105079144137
    }
    {
      "Type": "network",
      "Action": "disconnect",
      "Actor": {
        "ID": "7dc8ac97d5d29ef6c31b6052f3938c1e8f2749abbd17d1bd1febf2608db1b474",
        "Attributes": {
          "container": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
          "name": "bridge",
          "type": "bridge"
        }
      },
      "time": 1461943105,
      "timeNano": 1461943105230860245
    }
    {
      "status": "destroy",
      "id": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
      "from": "alpine",
      "Type": "container",
      "Action": "destroy",
      "Actor": {
        "ID": "ede54ee1afda366ab42f824e8a5ffd195155d853ceaec74a927f249ea270c743",
        "Attributes": {
          "com.example.some-label": "some-label-value",
          "image": "alpine",
          "name": "my-container"
        }
      },
      "time": 1461943105,
      "timeNano": 1461943105338056026
    }

**Query parameters**:

-   **since** ‚Äì Timestamp. Show all events created since timestamp and then stream
-   **until** ‚Äì Timestamp. Show events created until given timestamp and stop streaming
-   **filters** ‚Äì A json encoded value of the filters (a map[string][]string) to process on the event list. Available filters:
  -   `container=<string>`; -- container to filter
  -   `event=<string>`; -- event to filter
  -   `image=<string>`; -- image to filter
  -   `label=<string>`; -- image and container label to filter
  -   `type=<string>`; -- either `container` or `image` or `volume` or `network` or `daemon`
  -   `volume=<string>`; -- volume to filter
  -   `network=<string>`; -- network to filter
  -   `daemon=<string>`; -- daemon name or id to filter

**Status codes**:

-   **200** ‚Äì no error
-   **500** ‚Äì server error

### Get a tarball containing all images in a repository

`GET /images/(name)/get`

Get a tarball containing all images and metadata for the repository specified
by `name`.

If `name` is a specific name and tag (e.g. ubuntu:latest), then only that image
(and its parents) are returned. If `name` is an image ID, similarly only that
image (and its parents) are returned, but with the exclusion of the
'repositories' file in the tarball, as there were no image names referenced.

See the [image tarball format](docker_remote_api_v1.25.md#image-tarball-format) for more details.

**Example request**

    GET /images/ubuntu/get

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/x-tar

    Binary data stream

**Status codes**:

-   **200** ‚Äì no error
-   **500** ‚Äì server error

### Get a tarball containing all images

`GET /images/get`

Get a tarball containing all images and metadata for one or more repositories.

For each value of the `names` parameter: if it is a specific name and tag (e.g.
`ubuntu:latest`), then only that image (and its parents) are returned; if it is
an image ID, similarly only that image (and its parents) are returned and there
would be no names referenced in the 'repositories' file for this image ID.

See the [image tarball format](docker_remote_api_v1.25.md#image-tarball-format) for more details.

**Example request**

    GET /images/get?names=myname%2Fmyapp%3Alatest&names=busybox

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/x-tar

    Binary data stream

**Status codes**:

-   **200** ‚Äì no error
-   **500** ‚Äì server error

### Load a tarball with a set of images and tags into docker

`POST /images/load`

Load a set of images and tags into a Docker repository.
See the [image tarball format](docker_remote_api_v1.25.md#image-tarball-format) for more details.

**Example request**

    POST /images/load
    Content-Type: application/x-tar

    Tarball in body

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json
    Transfer-Encoding: chunked

    {"status":"Loading layer","progressDetail":{"current":32768,"total":1292800},"progress":"[=                                                 ] 32.77 kB/1.293 MB","id":"8ac8bfaff55a"}
    {"status":"Loading layer","progressDetail":{"current":65536,"total":1292800},"progress":"[==                                                ] 65.54 kB/1.293 MB","id":"8ac8bfaff55a"}
    {"status":"Loading layer","progressDetail":{"current":98304,"total":1292800},"progress":"[===                                               ]  98.3 kB/1.293 MB","id":"8ac8bfaff55a"}
    {"status":"Loading layer","progressDetail":{"current":131072,"total":1292800},"progress":"[=====                                             ] 131.1 kB/1.293 MB","id":"8ac8bfaff55a"}
    ...
    {"stream":"Loaded image: busybox:latest\n"}

**Example response**:

If the "quiet" query parameter is set to `true` / `1` (`?quiet=1`), progress
details are suppressed, and only a confirmation message is returned once the
action completes.

    HTTP/1.1 200 OK
    Content-Type: application/json
    Transfer-Encoding: chunked

    {"stream":"Loaded image: busybox:latest\n"}

**Query parameters**:

-   **quiet** ‚Äì Boolean value, suppress progress details during load. Defaults
      to `0` / `false` if omitted.

**Status codes**:

-   **200** ‚Äì no error
-   **500** ‚Äì server error

### Image tarball format

An image tarball contains one directory per image layer (named using its long ID),
each containing these files:

- `VERSION`: currently `1.0` - the file format version
- `json`: detailed layer information, similar to `docker inspect layer_id`
- `layer.tar`: A tarfile containing the filesystem changes in this layer

The `layer.tar` file contains `aufs` style `.wh..wh.aufs` files and directories
for storing attribute changes and deletions.

If the tarball defines a repository, the tarball should also include a `repositories` file at
the root that contains a list of repository and tag names mapped to layer IDs.

```
{"hello-world":
    {"latest": "565a9d68a73f6706862bfe8409a7f659776d4d60a8d096eb4a3cbce6999cc2a1"}
}
```

### Exec Create

`POST /containers/(id or name)/exec`

Sets up an exec instance in a running container `id`

**Example request**:

    POST /containers/e90e34656806/exec HTTP/1.1
    Content-Type: application/json

    {
      "AttachStdin": true,
      "AttachStdout": true,
      "AttachStderr": true,
      "Cmd": ["sh"],
      "DetachKeys": "ctrl-p,ctrl-q",
      "Privileged": true,
      "Tty": true,
      "User": "123:456"
    }

**Example response**:

    HTTP/1.1 201 Created
    Content-Type: application/json

    {
         "Id": "f90e34656806",
         "Warnings":[]
    }

**JSON parameters**:

-   **AttachStdin** - Boolean value, attaches to `stdin` of the `exec` command.
-   **AttachStdout** - Boolean value, attaches to `stdout` of the `exec` command.
-   **AttachStderr** - Boolean value, attaches to `stderr` of the `exec` command.
-   **DetachKeys** ‚Äì Override the key sequence for detaching a
        container. Format is a single character `[a-Z]` or `ctrl-<value>`
        where `<value>` is one of: `a-z`, `@`, `^`, `[`, `,` or `_`.
-   **Tty** - Boolean value to allocate a pseudo-TTY.
-   **Cmd** - Command to run specified as a string or an array of strings.
-   **Privileged** - Boolean value, runs the exec process with extended privileges.
-   **User** - A string value specifying the user, and optionally, group to run
        the exec process inside the container. Format is one of: `"user"`,
        `"user:group"`, `"uid"`, or `"uid:gid"`.

**Status codes**:

-   **201** ‚Äì no error
-   **404** ‚Äì no such container
-   **409** - container is paused
-   **500** - server error

### Exec Start

`POST /exec/(id)/start`

Starts a previously set up `exec` instance `id`. If `detach` is true, this API
returns after starting the `exec` command. Otherwise, this API sets up an
interactive session with the `exec` command.

**Example request**:

    POST /exec/e90e34656806/start HTTP/1.1
    Content-Type: application/json

    {
     "Detach": false,
     "Tty": false
    }

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/vnd.docker.raw-stream

    {% raw %}
    {{ STREAM }}
    {% endraw %}

**JSON parameters**:

-   **Detach** - Detach from the `exec` command.
-   **Tty** - Boolean value to allocate a pseudo-TTY.

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such exec instance
-   **409** - container is paused

**Stream details**:

Similar to the stream behavior of `POST /containers/(id or name)/attach` API

### Exec Resize

`POST /exec/(id)/resize`

Resizes the `tty` session used by the `exec` command `id`.  The unit is number of characters.
This API is valid only if `tty` was specified as part of creating and starting the `exec` command.

**Example request**:

    POST /exec/e90e34656806/resize?h=40&w=80 HTTP/1.1
    Content-Type: text/plain

**Example response**:

    HTTP/1.1 201 Created
    Content-Type: text/plain

**Query parameters**:

-   **h** ‚Äì height of `tty` session
-   **w** ‚Äì width

**Status codes**:

-   **201** ‚Äì no error
-   **404** ‚Äì no such exec instance

### Exec Inspect

`GET /exec/(id)/json`

Return low-level information about the `exec` command `id`.

**Example request**:

    GET /exec/11fb006128e8ceb3942e7c58d77750f24210e35f879dd204ac975c184b820b39/json HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
      "CanRemove": false,
      "ContainerID": "b53ee82b53a40c7dca428523e34f741f3abc51d9f297a14ff874bf761b995126",
      "DetachKeys": "",
      "ExitCode": 2,
      "ID": "f33bbfb39f5b142420f4759b2348913bd4a8d1a6d7fd56499cb41a1bb91d7b3b",
      "OpenStderr": true,
      "OpenStdin": true,
      "OpenStdout": true,
      "ProcessConfig": {
        "arguments": [
          "-c",
          "exit 2"
        ],
        "entrypoint": "sh",
        "privileged": false,
        "tty": true,
        "user": "1000"
      },
      "Running": false
    }

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such exec instance
-   **500** - server error

## 3.4 Volumes

### List volumes

`GET /volumes`

**Example request**:

    GET /volumes HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
      "Volumes": [
        {
          "Name": "tardis",
          "Driver": "local",
          "Mountpoint": "/var/lib/docker/volumes/tardis",
          "Labels":{
            "com.example.some-label": "some-value",
            "com.example.some-other-label": "some-other-value"
          },
          "Scope": "local"
        }
      ],
      "Warnings": []
    }

**Query parameters**:

- **filters** - JSON encoded value of the filters (a `map[string][]string`) to process on the volumes list. Available filters:
  -   `name=<volume-name>` Matches all or part of a volume name.
  -   `dangling=<boolean>` When set to `true` (or `1`), returns all volumes that are "dangling" (not in use by a container). When set to `false` (or `0`), only volumes that are in use by one or more containers are returned.
  -   `driver=<volume-driver-name>` Matches all or part of a volume driver name.

**Status codes**:

-   **200** - no error
-   **500** - server error

### Create a volume

`POST /volumes/create`

Create a volume

**Example request**:

    POST /volumes/create HTTP/1.1
    Content-Type: application/json

    {
      "Name": "tardis",
      "Labels": {
        "com.example.some-label": "some-value",
        "com.example.some-other-label": "some-other-value"
      },
      "Driver": "custom"
    }

**Example response**:

    HTTP/1.1 201 Created
    Content-Type: application/json

    {
      "Name": "tardis",
      "Driver": "custom",
      "Mountpoint": "/var/lib/docker/volumes/tardis",
      "Status": {
        "hello": "world"
      },
      "Labels": {
        "com.example.some-label": "some-value",
        "com.example.some-other-label": "some-other-value"
      },
      "Scope": "local"
    }

**Status codes**:

- **201** - no error
- **500**  - server error

**JSON parameters**:

- **Name** - The new volume's name. If not specified, Docker generates a name.
- **Driver** - Name of the volume driver to use. Defaults to `local` for the name.
- **DriverOpts** - A mapping of driver options and values. These options are
    passed directly to the driver and are driver specific.
- **Labels** - Labels to set on the volume, specified as a map: `{"key":"value","key2":"value2"}`

**JSON fields in response**:

Refer to the [inspect a volume](docker_remote_api_v1.25.md#inspect-a-volume) section or details about the
JSON fields returned in the response.

### Inspect a volume

`GET /volumes/(name)`

Return low-level information on the volume `name`

**Example request**:

    GET /volumes/tardis

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
      "Name": "tardis",
      "Driver": "custom",
      "Mountpoint": "/var/lib/docker/volumes/tardis/_data",
      "Status": {
        "hello": "world"
      },
      "Labels": {
          "com.example.some-label": "some-value",
          "com.example.some-other-label": "some-other-value"
      },
      "Scope": "local"
    }

**Status codes**:

-   **200** - no error
-   **404** - no such volume
-   **500** - server error

**JSON fields in response**:

The following fields can be returned in the API response. Empty fields, or
fields that are not supported by the volume's driver may be omitted in the
response.

- **Name** - Name of the volume.
- **Driver** - Name of the volume driver used by the volume.
- **Mountpoint** - Mount path of the volume on the host.
- **Status** - Low-level details about the volume, provided by the volume driver.
    Details are returned as a map with key/value pairs: `{"key":"value","key2":"value2"}`.
    The `Status` field is optional, and is omitted if the volume driver does not
    support this feature.
- **Labels** - Labels set on the volume, specified as a map: `{"key":"value","key2":"value2"}`.
- **Scope** - Scope describes the level at which the volume exists, can be one of
    `global` for cluster-wide or `local` for machine level. The default is `local`.

### Remove a volume

`DELETE /volumes/(name)`

Instruct the driver to remove the volume (`name`).

**Example request**:

    DELETE /volumes/tardis HTTP/1.1

**Example response**:

    HTTP/1.1 204 No Content

**Status codes**:

-   **204** - no error
-   **404** - no such volume or volume driver
-   **409** - volume is in use and cannot be removed
-   **500** - server error

## 3.5 Networks

### List networks

`GET /networks`

**Example request**:

    GET /networks?filters={"type":{"custom":true}} HTTP/1.1

**Example response**:

```
HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "Name": "bridge",
    "Id": "f2de39df4171b0dc801e8002d1d999b77256983dfc63041c0f34030aa3977566",
    "Scope": "local",
    "Driver": "bridge",
    "EnableIPv6": false,
    "Internal": false,
    "IPAM": {
      "Driver": "default",
      "Config": [
        {
          "Subnet": "172.17.0.0/16"
        }
      ]
    },
    "Containers": {
      "39b69226f9d79f5634485fb236a23b2fe4e96a0a94128390a7fbbcc167065867": {
        "EndpointID": "ed2419a97c1d9954d05b46e462e7002ea552f216e9b136b80a7db8d98b442eda",
        "MacAddress": "02:42:ac:11:00:02",
        "IPv4Address": "172.17.0.2/16",
        "IPv6Address": ""
      }
    },
    "Options": {
      "com.docker.network.bridge.default_bridge": "true",
      "com.docker.network.bridge.enable_icc": "true",
      "com.docker.network.bridge.enable_ip_masquerade": "true",
      "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
      "com.docker.network.bridge.name": "docker0",
      "com.docker.network.driver.mtu": "1500"
    }
  },
  {
    "Name": "none",
    "Id": "e086a3893b05ab69242d3c44e49483a3bbbd3a26b46baa8f61ab797c1088d794",
    "Scope": "local",
    "Driver": "null",
    "EnableIPv6": false,
    "Internal": false,
    "IPAM": {
      "Driver": "default",
      "Config": []
    },
    "Containers": {},
    "Options": {}
  },
  {
    "Name": "host",
    "Id": "13e871235c677f196c4e1ecebb9dc733b9b2d2ab589e30c539efeda84a24215e",
    "Scope": "local",
    "Driver": "host",
    "EnableIPv6": false,
    "Internal": false,
    "IPAM": {
      "Driver": "default",
      "Config": []
    },
    "Containers": {},
    "Options": {}
  }
]
```

**Query parameters**:

- **filters** - JSON encoded network list filter. The filter value is one of:
  -   `driver=<driver-name>` Matches a network's driver.
  -   `id=<network-id>` Matches all or part of a network id.
  -   `label=<key>` or `label=<key>=<value>` of a network label.
  -   `name=<network-name>` Matches all or part of a network name.
  -   `type=["custom"|"builtin"]` Filters networks by type. The `custom` keyword returns all user-defined networks.

**Status codes**:

-   **200** - no error
-   **500** - server error

### Inspect network

`GET /networks/<network-id>`

**Example request**:

    GET /networks/7d86d31b1478e7cca9ebed7e73aa0fdeec46c5ca29497431d3007d2d9e15ed99 HTTP/1.1

**Example response**:

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "Name": "net01",
  "Id": "7d86d31b1478e7cca9ebed7e73aa0fdeec46c5ca29497431d3007d2d9e15ed99",
  "Scope": "local",
  "Driver": "bridge",
  "EnableIPv6": false,
  "IPAM": {
    "Driver": "default",
    "Config": [
      {
        "Subnet": "172.19.0.0/16",
        "Gateway": "172.19.0.1"
      }
    ],
    "Options": {
        "foo": "bar"
    }
  },
  "Internal": false,
  "Containers": {
    "19a4d5d687db25203351ed79d478946f861258f018fe384f229f2efa4b23513c": {
      "Name": "test",
      "EndpointID": "628cadb8bcb92de107b2a1e516cbffe463e321f548feb37697cce00ad694f21a",
      "MacAddress": "02:42:ac:13:00:02",
      "IPv4Address": "172.19.0.2/16",
      "IPv6Address": ""
    }
  },
  "Options": {
    "com.docker.network.bridge.default_bridge": "true",
    "com.docker.network.bridge.enable_icc": "true",
    "com.docker.network.bridge.enable_ip_masquerade": "true",
    "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
    "com.docker.network.bridge.name": "docker0",
    "com.docker.network.driver.mtu": "1500"
  },
  "Labels": {
    "com.example.some-label": "some-value",
    "com.example.some-other-label": "some-other-value"
  }
}
```

**Status codes**:

-   **200** - no error
-   **404** - network not found

### Create a network

`POST /networks/create`

Create a network

**Example request**:

```
POST /networks/create HTTP/1.1
Content-Type: application/json

{
  "Name":"isolated_nw",
  "CheckDuplicate":true,
  "Driver":"bridge",
  "EnableIPv6": true,
  "IPAM":{
    "Driver": "default",
    "Config":[
      {
        "Subnet":"172.20.0.0/16",
        "IPRange":"172.20.10.0/24",
        "Gateway":"172.20.10.11"
      },
      {
        "Subnet":"2001:db8:abcd::/64",
        "Gateway":"2001:db8:abcd::1011"
      }
    ],
    "Options": {
      "foo": "bar"
    }
  },
  "Internal":true,
  "Options": {
    "com.docker.network.bridge.default_bridge": "true",
    "com.docker.network.bridge.enable_icc": "true",
    "com.docker.network.bridge.enable_ip_masquerade": "true",
    "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
    "com.docker.network.bridge.name": "docker0",
    "com.docker.network.driver.mtu": "1500"
  },
  "Labels": {
    "com.example.some-label": "some-value",
    "com.example.some-other-label": "some-other-value"
  }
}
```

**Example response**:

```
HTTP/1.1 201 Created
Content-Type: application/json

{
  "Id": "22be93d5babb089c5aab8dbc369042fad48ff791584ca2da2100db837a1c7c30",
  "Warning": ""
}
```

**Status codes**:

- **201** - no error
- **404** - plugin not found
- **500** - server error

**JSON parameters**:

- **Name** - The new network's name. this is a mandatory field
- **CheckDuplicate** - Requests daemon to check for networks with same name. Defaults to `false`
- **Driver** - Name of the network driver plugin to use. Defaults to `bridge` driver
- **Internal** - Restrict external access to the network
- **IPAM** - Optional custom IP scheme for the network
  - **Driver** - Name of the IPAM driver to use. Defaults to `default` driver
  - **Config** - List of IPAM configuration options, specified as a map:
      `{"Subnet": <CIDR>, "IPRange": <CIDR>, "Gateway": <IP address>, "AuxAddress": <device_name:IP address>}`
  - **Options** - Driver-specific options, specified as a map: `{"option":"value" [,"option2":"value2"]}`
- **EnableIPv6** - Enable IPv6 on the network
- **Options** - Network specific options to be used by the drivers
- **Labels** - Labels to set on the network, specified as a map: `{"key":"value" [,"key2":"value2"]}`

### Connect a container to a network

`POST /networks/(id)/connect`

Connect a container to a network

**Example request**:

```
POST /networks/22be93d5babb089c5aab8dbc369042fad48ff791584ca2da2100db837a1c7c30/connect HTTP/1.1
Content-Type: application/json

{
  "Container":"3613f73ba0e4",
  "EndpointConfig": {
    "IPAMConfig": {
        "IPv4Address":"172.24.56.89",
        "IPv6Address":"2001:db8::5689"
    }
  }
}
```

**Example response**:

    HTTP/1.1 200 OK

**Status codes**:

- **200** - no error
- **403** - operation not supported for swarm scoped networks
- **404** - network or container is not found
- **500** - Internal Server Error

**JSON parameters**:

- **container** - container-id/name to be connected to the network

### Disconnect a container from a network

`POST /networks/(id)/disconnect`

Disconnect a container from a network

**Example request**:

```
POST /networks/22be93d5babb089c5aab8dbc369042fad48ff791584ca2da2100db837a1c7c30/disconnect HTTP/1.1
Content-Type: application/json

{
  "Container":"3613f73ba0e4",
  "Force":false
}
```

**Example response**:

    HTTP/1.1 200 OK

**Status codes**:

- **200** - no error
- **403** - operation not supported for swarm scoped networks
- **404** - network or container not found
- **500** - Internal Server Error

**JSON parameters**:

- **Container** - container-id/name to be disconnected from a network
- **Force** - Force the container to disconnect from a network

### Remove a network

`DELETE /networks/(id)`

Instruct the driver to remove the network (`id`).

**Example request**:

    DELETE /networks/22be93d5babb089c5aab8dbc369042fad48ff791584ca2da2100db837a1c7c30 HTTP/1.1

**Example response**:

    HTTP/1.1 204 No Content

**Status codes**:

-   **204** - no error
-   **404** - no such network
-   **500** - server error

## 3.6 Plugins

### List plugins

`GET /plugins`

Returns information about installed plugins.

**Example request**:

    GET /plugins HTTP/1.1

**Example response**:

```
HTTP/1.1 200 OK
Content-Type: application/json

[
  {
    "Id": "5724e2c8652da337ab2eedd19fc6fc0ec908e4bd907c7421bf6a8dfc70c4c078",
    "Name": "tiborvass/no-remove",
    "Tag": "latest",
    "Active": true,
    "Config": {
      "Mounts": [
        {
          "Name": "",
          "Description": "",
          "Settable": null,
          "Source": "/data",
          "Destination": "/data",
          "Type": "bind",
          "Options": [
            "shared",
            "rbind"
          ]
        },
        {
          "Name": "",
          "Description": "",
          "Settable": null,
          "Source": null,
          "Destination": "/foobar",
          "Type": "tmpfs",
          "Options": null
        }
      ],
      "Env": [
        "DEBUG=1"
      ],
      "Args": null,
      "Devices": null
    },
    "Manifest": {
      "ManifestVersion": "v0",
      "Description": "A test plugin for Docker",
      "Documentation": "https://docs.docker.com/engine/extend/plugins/",
      "Interface": {
        "Types": [
          "docker.volumedriver/1.0"
        ],
        "Socket": "plugins.sock"
      },
      "Entrypoint": [
        "plugin-no-remove",
        "/data"
      ],
      "Workdir": "",
      "User": {
      },
      "Network": {
        "Type": "host"
      },
      "Capabilities": null,
      "Mounts": [
        {
          "Name": "",
          "Description": "",
          "Settable": null,
          "Source": "/data",
          "Destination": "/data",
          "Type": "bind",
          "Options": [
            "shared",
            "rbind"
          ]
        },
        {
          "Name": "",
          "Description": "",
          "Settable": null,
          "Source": null,
          "Destination": "/foobar",
          "Type": "tmpfs",
          "Options": null
        }
      ],
      "Devices": [
        {
          "Name": "device",
          "Description": "a host device to mount",
          "Settable": null,
          "Path": "/dev/cpu_dma_latency"
        }
      ],
      "Env": [
        {
          "Name": "DEBUG",
          "Description": "If set, prints debug messages",
          "Settable": null,
          "Value": "1"
        }
      ],
      "Args": {
        "Name": "args",
        "Description": "command line arguments",
        "Settable": null,
        "Value": [

        ]
      }
    }
  }
]
```

**Status codes**:

-   **200** - no error
-   **500** - server error

### Install a plugin

`POST /plugins/pull?name=<plugin name>`

Pulls and installs a plugin. After the plugin is installed, it can be enabled
using the [`POST /plugins/(plugin name)/enable` endpoint](docker_remote_api_v1.25.md#enable-a-plugin).

**Example request**:

```
POST /plugins/pull?name=tiborvass/no-remove:latest HTTP/1.1
```

The `:latest` tag is optional, and is used as default if omitted. When using
this endpoint to pull a plugin from the registry, the `X-Registry-Auth` header
can be used to include a base64-encoded AuthConfig object. Refer to the [create
an image](docker_remote_api_v1.25.md#create-an-image) section for more details.

**Example response**:

```
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 175

[
  {
    "Name": "network",
    "Description": "",
    "Value": [
      "host"
    ]
  },
  {
    "Name": "mount",
    "Description": "",
    "Value": [
      "/data"
    ]
  },
  {
    "Name": "device",
    "Description": "",
    "Value": [
      "/dev/cpu_dma_latency"
    ]
  }
]
```

**Query parameters**:

- **name** -  Name of the plugin to pull. The name may include a tag or digest.
    This parameter is required.

**Status codes**:

-   **200** - no error
-   **500** - error parsing reference / not a valid repository/tag: repository
      name must have at least one component
-   **500** - plugin already exists

### Inspect a plugin

`GET /plugins/(plugin name)`

Returns detailed information about an installed plugin.

**Example request**:

```
GET /plugins/tiborvass/no-remove:latest HTTP/1.1
```

The `:latest` tag is optional, and is used as default if omitted.


**Example response**:

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "Id": "5724e2c8652da337ab2eedd19fc6fc0ec908e4bd907c7421bf6a8dfc70c4c078",
  "Name": "tiborvass/no-remove",
  "Tag": "latest",
  "Active": false,
  "Config": {
    "Mounts": [
      {
        "Name": "",
        "Description": "",
        "Settable": null,
        "Source": "/data",
        "Destination": "/data",
        "Type": "bind",
        "Options": [
          "shared",
          "rbind"
        ]
      },
      {
        "Name": "",
        "Description": "",
        "Settable": null,
        "Source": null,
        "Destination": "/foobar",
        "Type": "tmpfs",
        "Options": null
      }
    ],
    "Env": [
      "DEBUG=1"
    ],
    "Args": null,
    "Devices": null
  },
  "Manifest": {
    "ManifestVersion": "v0",
    "Description": "A test plugin for Docker",
    "Documentation": "https://docs.docker.com/engine/extend/plugins/",
    "Interface": {
      "Types": [
        "docker.volumedriver/1.0"
      ],
      "Socket": "plugins.sock"
    },
    "Entrypoint": [
      "plugin-no-remove",
      "/data"
    ],
    "Workdir": "",
    "User": {
    },
    "Network": {
      "Type": "host"
    },
    "Capabilities": null,
    "Mounts": [
      {
        "Name": "",
        "Description": "",
        "Settable": null,
        "Source": "/data",
        "Destination": "/data",
        "Type": "bind",
        "Options": [
          "shared",
          "rbind"
        ]
      },
      {
        "Name": "",
        "Description": "",
        "Settable": null,
        "Source": null,
        "Destination": "/foobar",
        "Type": "tmpfs",
        "Options": null
      }
    ],
    "Devices": [
      {
        "Name": "device",
        "Description": "a host device to mount",
        "Settable": null,
        "Path": "/dev/cpu_dma_latency"
      }
    ],
    "Env": [
      {
        "Name": "DEBUG",
        "Description": "If set, prints debug messages",
        "Settable": null,
        "Value": "1"
      }
    ],
    "Args": {
      "Name": "args",
      "Description": "command line arguments",
      "Settable": null,
      "Value": [

      ]
    }
  }
}
```

**Status codes**:

-   **200** - no error
-   **404** - plugin not installed

<!-- TODO Document "docker plugin set" endpoint once implemented
### Configure a plugin

`POST /plugins/(plugin name)/set`

**Status codes**:

-   **500** - not implemented

-->

### Enable a plugin

`POST /plugins/(plugin name)/enable`

Enables a plugin

**Example request**:

```
POST /plugins/tiborvass/no-remove:latest/enable HTTP/1.1
```

The `:latest` tag is optional, and is used as default if omitted.


**Example response**:

```
HTTP/1.1 200 OK
Content-Length: 0
Content-Type: text/plain; charset=utf-8
```

**Status codes**:

-   **200** - no error
-   **500** - plugin is already enabled

### Disable a plugin

`POST /plugins/(plugin name)/disable`

Disables a plugin

**Example request**:

```
POST /plugins/tiborvass/no-remove:latest/disable HTTP/1.1
```

The `:latest` tag is optional, and is used as default if omitted.


**Example response**:

```
HTTP/1.1 200 OK
Content-Length: 0
Content-Type: text/plain; charset=utf-8
```

**Status codes**:

-   **200** - no error
-   **500** - plugin is already disabled

### Remove a plugin

`DELETE /plugins/(plugin name)`

Removes a plugin

**Example request**:

```
DELETE /plugins/tiborvass/no-remove:latest HTTP/1.1
```

The `:latest` tag is optional, and is used as default if omitted.

**Example response**:

```
HTTP/1.1 200 OK
Content-Length: 0
Content-Type: text/plain; charset=utf-8
```

**Query parameters**:

- **force** - Boolean value, set to `1` / `True` / `true` to force removing the
    plugin. Forcing removal disables the plugin before removing, but may result
    in issues if the plugin is in use by a container.

**Status codes**:

-   **200** - no error
-   **404** - plugin not installed
-   **500** - plugin is active

<!-- TODO Document "docker plugin push" endpoint once we have "plugin build"

### Push a plugin

`POST /plugins/tiborvass/(plugin name)/push HTTP/1.1`

Pushes a plugin to the registry.

**Example request**:

```
POST /plugins/tiborvass/no-remove:latest HTTP/1.1
```

The `:latest` tag is optional, and is used as default if omitted. When using
this endpoint to push a plugin to the registry, the `X-Registry-Auth` header
can be used to include a base64-encoded AuthConfig object. Refer to the [create
an image](docker_remote_api_v1.25.md#create-an-image) section for more details.

**Example response**:

**Status codes**:

-   **200** - no error
-   **404** - plugin not installed

-->

## 3.7 Nodes

**Note**: Node operations require the engine to be part of a swarm.

### List nodes


`GET /nodes`

List nodes

**Example request**:

    GET /nodes HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    [
      {
        "ID": "24ifsmvkjbyhk",
        "Version": {
          "Index": 8
        },
        "CreatedAt": "2016-06-07T20:31:11.853781916Z",
        "UpdatedAt": "2016-06-07T20:31:11.999868824Z",
        "Spec": {
          "Name": "my-node",
          "Role": "manager",
          "Availability": "active"
          "Labels": {
              "foo": "bar"
          }
        },
        "Description": {
          "Hostname": "bf3067039e47",
          "Platform": {
            "Architecture": "x86_64",
            "OS": "linux"
          },
          "Resources": {
            "NanoCPUs": 4000000000,
            "MemoryBytes": 8272408576
          },
          "Engine": {
            "EngineVersion": "1.12.0-dev",
            "Labels": {
                "foo": "bar",
            }
            "Plugins": [
              {
                "Type": "Volume",
                "Name": "local"
              },
              {
                "Type": "Network",
                "Name": "bridge"
              }
              {
                "Type": "Network",
                "Name": "null"
              }
              {
                "Type": "Network",
                "Name": "overlay"
              }
            ]
          }
        },
        "Status": {
          "State": "ready"
        },
        "ManagerStatus": {
          "Leader": true,
          "Reachability": "reachable",
          "Addr": "172.17.0.2:2377""
        }
      }
    ]

**Query parameters**:

- **filters** ‚Äì a JSON encoded value of the filters (a `map[string][]string`) to process on the
  nodes list. Available filters:
  - `id=<node id>`
  - `name=<node name>`
  - `membership=`(`pending`|`accepted`|`rejected`)`
  - `role=`(`worker`|`manager`)`

**Status codes**:

- **200** ‚Äì no error
- **500** ‚Äì server error

### Inspect a node


`GET /nodes/<id>`

Return low-level information on the node `id`

**Example request**:

      GET /nodes/24ifsmvkjbyhk HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
      "ID": "24ifsmvkjbyhk",
      "Version": {
        "Index": 8
      },
      "CreatedAt": "2016-06-07T20:31:11.853781916Z",
      "UpdatedAt": "2016-06-07T20:31:11.999868824Z",
      "Spec": {
        "Name": "my-node",
        "Role": "manager",
        "Availability": "active"
        "Labels": {
            "foo": "bar"
        }
      },
      "Description": {
        "Hostname": "bf3067039e47",
        "Platform": {
          "Architecture": "x86_64",
          "OS": "linux"
        },
        "Resources": {
          "NanoCPUs": 4000000000,
          "MemoryBytes": 8272408576
        },
        "Engine": {
          "EngineVersion": "1.12.0-dev",
          "Labels": {
              "foo": "bar",
          }
          "Plugins": [
            {
              "Type": "Volume",
              "Name": "local"
            },
            {
              "Type": "Network",
              "Name": "bridge"
            }
            {
              "Type": "Network",
              "Name": "null"
            }
            {
              "Type": "Network",
              "Name": "overlay"
            }
          ]
        }
      },
      "Status": {
        "State": "ready"
      },
      "ManagerStatus": {
        "Leader": true,
        "Reachability": "reachable",
        "Addr": "172.17.0.2:2377""
      }
    }

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such node
-   **500** ‚Äì server error

### Remove a node


`DELETE /nodes/(id)`

Remove a node [`id`] from the swarm.

**Example request**:

    DELETE /nodes/24ifsmvkjbyhk HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Length: 0
    Content-Type: text/plain; charset=utf-8

**Query parameters**:

-   **force** - 1/True/true or 0/False/false, Force remove an active node.
        Default `false`.

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such node
-   **500** ‚Äì server error

### Update a node


`POST /nodes/(id)/update`

Update the node `id`.

The payload of the `POST` request is the new `NodeSpec` and
overrides the current `NodeSpec` for the specified node.

If `Availability` or `Role` are omitted, this returns an
error. Any other field omitted resets the current value to either
an empty value or the default cluster-wide value.

**Example Request**

    POST /nodes/24ifsmvkjbyhk/update?version=8 HTTP/1.1
    Content-Type: application/json

    {
      "Availability": "active",
      "Name": "node-name",
      "Role": "manager",
      "Labels": {
        "foo": "bar"
      }
    }

**Example response**:

    HTTP/1.1 200 OK
    Content-Length: 0
    Content-Type: text/plain; charset=utf-8

**Query parameters**:

- **version** ‚Äì The version number of the node object being updated. This is
  required to avoid conflicting writes.

JSON Parameters:

- **Annotations** ‚Äì Optional medata to associate with the service.
    - **Name** ‚Äì User-defined name for the service.
    - **Labels** ‚Äì A map of labels to associate with the service (e.g.,
      `{"key":"value", "key2":"value2"}`).
- **Role** - Role of the node (worker/manager).
- **Availability** - Availability of the node (active/pause/drain).


**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such node
-   **500** ‚Äì server error

## 3.8 Swarm

### Inspect swarm


`GET /swarm`

Inspect swarm

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
      "CreatedAt" : "2016-08-15T16:00:20.349727406Z",
      "Spec" : {
        "Dispatcher" : {
          "HeartbeatPeriod" : 5000000000
        },
        "Orchestration" : {
         "TaskHistoryRetentionLimit" : 10
        },
        "CAConfig" : {
          "NodeCertExpiry" : 7776000000000000
        },
        "Raft" : {
          "LogEntriesForSlowFollowers" : 500,
          "HeartbeatTick" : 1,
          "SnapshotInterval" : 10000,
          "ElectionTick" : 3
        },
        "TaskDefaults" : {},
        "Name" : "default"
      },
     "JoinTokens" : {
        "Worker" : "SWMTKN-1-1h8aps2yszaiqmz2l3oc5392pgk8e49qhx2aj3nyv0ui0hez2a-6qmn92w6bu3jdvnglku58u11a",
        "Manager" : "SWMTKN-1-1h8aps2yszaiqmz2l3oc5392pgk8e49qhx2aj3nyv0ui0hez2a-8llk83c4wm9lwioey2s316r9l"
     },
     "ID" : "70ilmkj2f6sp2137c753w2nmt",
     "UpdatedAt" : "2016-08-15T16:32:09.623207604Z",
     "Version" : {
       "Index" : 51
    }
  }

**Status codes**:

- **200** - no error

### Initialize a new swarm


`POST /swarm/init`

Initialize a new swarm. The body of the HTTP response includes the node ID.

**Example request**:

    POST /swarm/init HTTP/1.1
    Content-Type: application/json

    {
      "ListenAddr": "0.0.0.0:2377",
      "AdvertiseAddr": "192.168.1.1:2377",
      "ForceNewCluster": false,
      "Spec": {
        "Orchestration": {},
        "Raft": {},
        "Dispatcher": {},
        "CAConfig": {}
      }
    }

**Example response**:

    HTTP/1.1 200 OK
    Content-Length: 28
    Content-Type: application/json
    Date: Thu, 01 Sep 2016 21:49:13 GMT
    Server: Docker/1.12.0 (linux)

    "7v2t30z9blmxuhnyo6s4cpenp"

**Status codes**:

- **200** ‚Äì no error
- **400** ‚Äì bad parameter
- **406** ‚Äì node is already part of a swarm

JSON Parameters:

- **ListenAddr** ‚Äì Listen address used for inter-manager communication, as well as determining
  the networking interface used for the VXLAN Tunnel Endpoint (VTEP). This can either be an
  address/port combination in the form `192.168.1.1:4567`, or an interface followed by a port
  number, like `eth0:4567`. If the port number is omitted, the default swarm listening port is
  used.
- **AdvertiseAddr** ‚Äì Externally reachable address advertised to other nodes. This can either be
  an address/port combination in the form `192.168.1.1:4567`, or an interface followed by a port
  number, like `eth0:4567`. If the port number is omitted, the port number from the listen
  address is used. If `AdvertiseAddr` is not specified, it will be automatically detected when
  possible.
- **ForceNewCluster** ‚Äì Force creation of a new swarm.
- **Spec** ‚Äì Configuration settings for the new swarm.
    - **Orchestration** ‚Äì Configuration settings for the orchestration aspects of the swarm.
        - **TaskHistoryRetentionLimit** ‚Äì Maximum number of tasks history stored.
    - **Raft** ‚Äì Raft related configuration.
        - **SnapshotInterval** ‚Äì Number of logs entries between snapshot.
        - **KeepOldSnapshots** ‚Äì Number of snapshots to keep beyond the current snapshot.
        - **LogEntriesForSlowFollowers** ‚Äì Number of log entries to keep around to sync up slow
          followers after a snapshot is created.
        - **HeartbeatTick** ‚Äì Amount of ticks (in seconds) between each heartbeat.
        - **ElectionTick** ‚Äì Amount of ticks (in seconds) needed without a leader to trigger a new
          election.
    - **Dispatcher** ‚Äì Configuration settings for the task dispatcher.
        - **HeartbeatPeriod** ‚Äì The delay for an agent to send a heartbeat to the dispatcher.
    - **CAConfig** ‚Äì Certificate authority configuration.
        - **NodeCertExpiry** ‚Äì Automatic expiry for nodes certificates.
        - **ExternalCA** - Configuration for forwarding signing requests to an external
          certificate authority.
            - **Protocol** - Protocol for communication with the external CA
              (currently only "cfssl" is supported).
            - **URL** - URL where certificate signing requests should be sent.
            - **Options** - An object with key/value pairs that are interpreted
              as protocol-specific options for the external CA driver.

### Join an existing swarm

`POST /swarm/join`

Join an existing swarm

**Example request**:

    POST /swarm/join HTTP/1.1
    Content-Type: application/json

    {
      "ListenAddr": "0.0.0.0:2377",
      "AdvertiseAddr": "192.168.1.1:2377",
      "RemoteAddrs": ["node1:2377"],
      "JoinToken": "SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-7p73s1dx5in4tatdymyhg9hu2"
    }

**Example response**:

    HTTP/1.1 200 OK
    Content-Length: 0
    Content-Type: text/plain; charset=utf-8

**Status codes**:

- **200** ‚Äì no error
- **400** ‚Äì bad parameter
- **406** ‚Äì node is already part of a swarm

JSON Parameters:

- **ListenAddr** ‚Äì Listen address used for inter-manager communication if the node gets promoted to
  manager, as well as determining the networking interface used for the VXLAN Tunnel Endpoint (VTEP).
- **AdvertiseAddr** ‚Äì Externally reachable address advertised to other nodes. This can either be
  an address/port combination in the form `192.168.1.1:4567`, or an interface followed by a port
  number, like `eth0:4567`. If the port number is omitted, the port number from the listen
  address is used. If `AdvertiseAddr` is not specified, it will be automatically detected when
  possible.
- **RemoteAddr** ‚Äì Address of any manager node already participating in the swarm.
- **JoinToken** ‚Äì Secret token for joining this swarm.

### Leave a swarm


`POST /swarm/leave`

Leave a swarm

**Example request**:

    POST /swarm/leave HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Length: 0
    Content-Type: text/plain; charset=utf-8

**Query parameters**:

- **force** - Boolean (0/1, false/true). Force leave swarm, even if this is the last manager or that it will break the cluster.

**Status codes**:

- **200** ‚Äì no error
- **406** ‚Äì node is not part of a swarm

### Update a swarm


`POST /swarm/update`

Update a swarm

**Example request**:

    POST /swarm/update HTTP/1.1

    {
      "Name": "default",
      "Orchestration": {
        "TaskHistoryRetentionLimit": 10
      },
      "Raft": {
        "SnapshotInterval": 10000,
        "LogEntriesForSlowFollowers": 500,
        "HeartbeatTick": 1,
        "ElectionTick": 3
      },
      "Dispatcher": {
        "HeartbeatPeriod": 5000000000
      },
      "CAConfig": {
        "NodeCertExpiry": 7776000000000000
      },
      "JoinTokens": {
        "Worker": "SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-1awxwuwd3z9j1z3puu7rcgdbx",
        "Manager": "SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-7p73s1dx5in4tatdymyhg9hu2"
      }
    }


**Example response**:

    HTTP/1.1 200 OK
    Content-Length: 0
    Content-Type: text/plain; charset=utf-8

**Query parameters**:

- **version** ‚Äì The version number of the swarm object being updated. This is
  required to avoid conflicting writes.
- **rotateWorkerToken** - Set to `true` (or `1`) to rotate the worker join token.
- **rotateManagerToken** - Set to `true` (or `1`) to rotate the manager join token.

**Status codes**:

- **200** ‚Äì no error
- **400** ‚Äì bad parameter
- **406** ‚Äì node is not part of a swarm

JSON Parameters:

- **Orchestration** ‚Äì Configuration settings for the orchestration aspects of the swarm.
    - **TaskHistoryRetentionLimit** ‚Äì Maximum number of tasks history stored.
- **Raft** ‚Äì Raft related configuration.
    - **SnapshotInterval** ‚Äì Number of logs entries between snapshot.
    - **KeepOldSnapshots** ‚Äì Number of snapshots to keep beyond the current snapshot.
    - **LogEntriesForSlowFollowers** ‚Äì Number of log entries to keep around to sync up slow
      followers after a snapshot is created.
    - **HeartbeatTick** ‚Äì Amount of ticks (in seconds) between each heartbeat.
    - **ElectionTick** ‚Äì Amount of ticks (in seconds) needed without a leader to trigger a new
      election.
- **Dispatcher** ‚Äì Configuration settings for the task dispatcher.
    - **HeartbeatPeriod** ‚Äì The delay for an agent to send a heartbeat to the dispatcher.
- **CAConfig** ‚Äì CA configuration.
    - **NodeCertExpiry** ‚Äì Automatic expiry for nodes certificates.
    - **ExternalCA** - Configuration for forwarding signing requests to an external
      certificate authority.
        - **Protocol** - Protocol for communication with the external CA
          (currently only "cfssl" is supported).
        - **URL** - URL where certificate signing requests should be sent.
        - **Options** - An object with key/value pairs that are interpreted
          as protocol-specific options for the external CA driver.
- **JoinTokens** - Tokens that can be used by other nodes to join the swarm.
    - **Worker** - Token to use for joining as a worker.
    - **Manager** - Token to use for joining as a manager.

## 3.9 Services

**Note**: Service operations require to first be part of a swarm.

### List services


`GET /services`

List services

**Example request**:

    GET /services HTTP/1.1

**Example response**:

    HTTP/1.1 200 OK
    Content-Type: application/json

    [
      {
        "ID": "9mnpnzenvg8p8tdbtq4wvbkcz",
        "Version": {
          "Index": 19
        },
        "CreatedAt": "2016-06-07T21:05:51.880065305Z",
        "UpdatedAt": "2016-06-07T21:07:29.962229872Z",
        "Spec": {
          "Name": "hopeful_cori",
          "TaskTemplate": {
            "ContainerSpec": {
              "Image": "redis"
            },
            "Resources": {
              "Limits": {},
              "Reservations": {}
            },
            "RestartPolicy": {
              "Condition": "any",
              "MaxAttempts": 0
            },
            "Placement": {}
          },
          "Mode": {
            "Replicated": {
              "Replicas": 1
            }
          },
          "UpdateConfig": {
            "Parallelism": 1,
            "FailureAction": "pause"
          },
          "EndpointSpec": {
            "Mode": "vip",
            "Ports": [
              {
                "Protocol": "tcp",
                "TargetPort": 6379,
                "PublishedPort": 30001
              }
            ]
          }
        },
        "Endpoint": {
          "Spec": {
            "Mode": "vip",
            "Ports": [
              {
                "Protocol": "tcp",
                "TargetPort": 6379,
                "PublishedPort": 30001
              }
            ]
          },
          "Ports": [
            {
              "Protocol": "tcp",
              "TargetPort": 6379,
              "PublishedPort": 30001
            }
          ],
          "VirtualIPs": [
            {
              "NetworkID": "4qvuz4ko70xaltuqbt8956gd1",
              "Addr": "10.255.0.2/16"
            },
            {
              "NetworkID": "4qvuz4ko70xaltuqbt8956gd1",
              "Addr": "10.255.0.3/16"
            }
          ]
        }
      }
    ]

**Query parameters**:

- **filters** ‚Äì a JSON encoded value of the filters (a `map[string][]string`) to process on the
  services list. Available filters:
  - `id=<node id>`
  - `name=<node name>`

**Status codes**:

- **200** ‚Äì no error
- **500** ‚Äì server error

### Create a service

`POST /services/create`

Create a service. When using this endpoint to create a service using a private
repository from the registry, the `X-Registry-Auth` header must be used to
include a base64-encoded AuthConfig object. Refer to the [create an
image](docker_remote_api_v1.25.md#create-an-image) section for more details.

**Example request**:

    POST /services/create HTTP/1.1
    Content-Type: application/json

    {
      "Name": "web",
      "TaskTemplate": {
        "ContainerSpec": {
          "Image": "nginx:alpine",
          "Mounts": [
            {
              "ReadOnly": true,
              "Source": "web-data",
              "Target": "/usr/share/nginx/html",
              "Type": "volume",
              "VolumeOptions": {
                "DriverConfig": {
                },
                "Labels": {
                  "com.example.something": "something-value"
                }
              }
            }
          ],
          "User": "33"
        },
        "LogDriver": {
          "Name": "json-file",
          "Options": {
            "max-file": "3",
            "max-size": "10M"
          }
        },
        "Placement": {},
        "Resources": {
          "Limits": {
            "MemoryBytes": 104857600.0
          },
          "Reservations": {
          }
        },
        "RestartPolicy": {
          "Condition": "on-failure",
          "Delay": 10000000000.0,
          "MaxAttempts": 10
        }
      },
      "Mode": {
        "Replicated": {
          "Replicas": 4
        }
      },
      "UpdateConfig": {
        "Delay": 30000000000.0,
        "Parallelism": 2,
        "FailureAction": "pause"
      },
      "EndpointSpec": {
        "Ports": [
          {
            "Protocol": "tcp",
            "PublishedPort": 8080,
            "TargetPort": 80
          }
        ]
      },
      "Labels": {
        "foo": "bar"
      }
    }

**Example response**:

    HTTP/1.1 201 Created
    Content-Type: application/json

    {
      "ID":"ak7w3gjqoa3kuz8xcpnyy0pvl"
    }

**Status codes**:

- **201** ‚Äì no error
- **406** ‚Äì server error or node is not part of a swarm
- **409** ‚Äì name conflicts with an existing object

**JSON Parameters**:

- **Name** ‚Äì User-defined name for the service.
- **Labels** ‚Äì A map of labels to associate with the service (e.g., `{"key":"value", "key2":"value2"}`).
- **TaskTemplate** ‚Äì Specification of the tasks to start as part of the new service.
    - **ContainerSpec** - Container settings for containers started as part of this task.
        - **Image** ‚Äì A string specifying the image name to use for the container.
        - **Command** ‚Äì The command to be run in the image.
        - **Args** ‚Äì Arguments to the command.
        - **Env** ‚Äì A list of environment variables in the form of `["VAR=value"[,"VAR2=value2"]]`.
        - **Dir** ‚Äì A string specifying the working directory for commands to run in.
        - **User** ‚Äì A string value specifying the user inside the container.
        - **Labels** ‚Äì A map of labels to associate with the service (e.g.,
          `{"key":"value", "key2":"value2"}`).
        - **Mounts** ‚Äì Specification for mounts to be added to containers
          created as part of the service.
            - **Target** ‚Äì Container path.
            - **Source** ‚Äì Mount source (e.g. a volume name, a host path).
            - **Type** ‚Äì The mount type (`bind`, or `volume`).
            - **ReadOnly** ‚Äì A boolean indicating whether the mount should be read-only.
            - **BindOptions** - Optional configuration for the `bind` type.
              - **Propagation** ‚Äì A propagation mode with the value `[r]private`, `[r]shared`, or `[r]slave`.
            - **VolumeOptions** ‚Äì Optional configuration for the `volume` type.
                - **NoCopy** ‚Äì A boolean indicating if volume should be
                  populated with the data from the target. (Default false)
                - **Labels** ‚Äì User-defined name and labels for the volume.
                - **DriverConfig** ‚Äì Map of driver-specific options.
                  - **Name** - Name of the driver to use to create the volume.
                  - **Options** - key/value map of driver specific options.
        - **StopGracePeriod** ‚Äì Amount of time to wait for the container to terminate before
          forcefully killing it.
    - **LogDriver** - Log configuration for containers created as part of the
      service.
        - **Name** - Name of the logging driver to use (`json-file`, `syslog`,
          `journald`, `gelf`, `fluentd`, `awslogs`, `splunk`, `etwlogs`, `none`).
        - **Options** - Driver-specific options.
    - **Resources** ‚Äì Resource requirements which apply to each individual container created as part
      of the service.
        - **Limits** ‚Äì Define resources limits.
            - **NanoCPUs** ‚Äì CPU limit in units of 10<sup>-9</sup> CPU shares.
            - **MemoryBytes** ‚Äì Memory limit in Bytes.
        - **Reservation** ‚Äì Define resources reservation.
            - **NanoCPUs** ‚Äì CPU reservation in units of 10<sup>-9</sup> CPU shares.
            - **MemoryBytes** ‚Äì Memory reservation in Bytes.
    - **RestartPolicy** ‚Äì Specification for the restart policy which applies to containers created
      as part of this service.
        - **Condition** ‚Äì Condition for restart (`none`, `on-failure`, or `any`).
        - **Delay** ‚Äì Delay between restart attempts.
        - **Attempts** ‚Äì Maximum attempts to restart a given container before giving up (default value
          is 0, which is ignored).
        - **Window** ‚Äì Windows is the time window used to evaluate the restart policy (default value is
          0, which is unbounded).
    - **Placement** ‚Äì An array of constraints.
- **Mode** ‚Äì Scheduling mode for the service (`replicated` or `global`, defaults to `replicated`).
- **UpdateConfig** ‚Äì Specification for the update strategy of the service.
    - **Parallelism** ‚Äì Maximum number of tasks to be updated in one iteration (0 means unlimited
      parallelism).
    - **Delay** ‚Äì Amount of time between updates.
    - **FailureAction** - Action to take if an updated task fails to run, or stops running during the
      update. Values are `continue` and `pause`.
- **Networks** ‚Äì Array of network names or IDs to attach the service to.
- **EndpointSpec** ‚Äì Properties that can be configured to access and load balance a service.
    - **Mode** ‚Äì The mode of resolution to use for internal load balancing
      between tasks (`vip` or `dnsrr`). Defaults to `vip` if not provided.
    - **Ports** ‚Äì List of exposed ports that this service is accessible on from
      the outside, in the form of:
      `{"Protocol": <"tcp"|"udp">, "PublishedPort": <port>, "TargetPort": <port>}`.
      Ports can only be provided if `vip` resolution mode is used.

**Request Headers**:

- **Content-type** ‚Äì Set to `"application/json"`.
- **X-Registry-Auth** ‚Äì base64-encoded AuthConfig object, containing either
  login information, or a token. Refer to the [create an image](docker_remote_api_v1.25.md#create-an-image)
  section for more details.


### Remove a service


`DELETE /services/(id or name)`

Stop and remove the service `id`

**Example request**:

    DELETE /services/16253994b7c4 HTTP/1.1

**Example response**:

    HTTP/1.1 200 No Content

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such service
-   **500** ‚Äì server error

### Inspect one or more services


`GET /services/(id or name)`

Return information on the service `id`.

**Example request**:

    GET /services/1cb4dnqcyx6m66g2t538x3rxha HTTP/1.1

**Example response**:

    {
      "ID": "ak7w3gjqoa3kuz8xcpnyy0pvl",
      "Version": {
        "Index": 95
      },
      "CreatedAt": "2016-06-07T21:10:20.269723157Z",
      "UpdatedAt": "2016-06-07T21:10:20.276301259Z",
      "Spec": {
        "Name": "redis",
        "TaskTemplate": {
          "ContainerSpec": {
            "Image": "redis"
          },
          "Resources": {
            "Limits": {},
            "Reservations": {}
          },
          "RestartPolicy": {
            "Condition": "any",
            "MaxAttempts": 0
          },
          "Placement": {}
        },
        "Mode": {
          "Replicated": {
            "Replicas": 1
          }
        },
        "UpdateConfig": {
          "Parallelism": 1,
          "FailureAction": "pause"
        },
        "EndpointSpec": {
          "Mode": "vip",
          "Ports": [
            {
              "Protocol": "tcp",
              "TargetPort": 6379,
              "PublishedPort": 30001
            }
          ]
        }
      },
      "Endpoint": {
        "Spec": {
          "Mode": "vip",
          "Ports": [
            {
              "Protocol": "tcp",
              "TargetPort": 6379,
              "PublishedPort": 30001
            }
          ]
        },
        "Ports": [
          {
            "Protocol": "tcp",
            "TargetPort": 6379,
            "PublishedPort": 30001
          }
        ],
        "VirtualIPs": [
          {
            "NetworkID": "4qvuz4ko70xaltuqbt8956gd1",
            "Addr": "10.255.0.4/16"
          }
        ]
      }
    }

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such service
-   **500** ‚Äì server error

### Update a service

`POST /services/(id or name)/update`

Update a service. When using this endpoint to create a service using a
private repository from the registry, the `X-Registry-Auth` header can be used
to update the authentication information for that is stored for the service.
The header contains a base64-encoded AuthConfig object. Refer to the [create an
image](docker_remote_api_v1.25.md#create-an-image) section for more details.

**Example request**:

    POST /services/1cb4dnqcyx6m66g2t538x3rxha/update?version=23 HTTP/1.1
    Content-Type: application/json

    {
      "Name": "top",
      "TaskTemplate": {
        "ContainerSpec": {
          "Image": "busybox",
          "Args": [
            "top"
          ]
        },
        "Resources": {
          "Limits": {},
          "Reservations": {}
        },
        "RestartPolicy": {
          "Condition": "any",
          "MaxAttempts": 0
        },
        "Placement": {}
      },
      "Mode": {
        "Replicated": {
          "Replicas": 1
        }
      },
      "UpdateConfig": {
        "Parallelism": 1
      },
      "EndpointSpec": {
        "Mode": "vip"
      }
    }

**Example response**:

    HTTP/1.1 200 OK
    Content-Length: 0
    Content-Type: text/plain; charset=utf-8

**JSON Parameters**:

- **Name** ‚Äì User-defined name for the service.
- **Labels** ‚Äì A map of labels to associate with the service (e.g., `{"key":"value", "key2":"value2"}`).
- **TaskTemplate** ‚Äì Specification of the tasks to start as part of the new service.
    - **ContainerSpec** - Container settings for containers started as part of this task.
        - **Image** ‚Äì A string specifying the image name to use for the container.
        - **Command** ‚Äì The command to be run in the image.
        - **Args** ‚Äì Arguments to the command.
        - **Env** ‚Äì A list of environment variables in the form of `["VAR=value"[,"VAR2=value2"]]`.
        - **Dir** ‚Äì A string specifying the working directory for commands to run in.
        - **User** ‚Äì A string value specifying the user inside the container.
        - **Labels** ‚Äì A map of labels to associate with the service (e.g.,
          `{"key":"value", "key2":"value2"}`).
        - **Mounts** ‚Äì Specification for mounts to be added to containers created as part of the new
          service.
            - **Target** ‚Äì Container path.
            - **Source** ‚Äì Mount source (e.g. a volume name, a host path).
            - **Type** ‚Äì The mount type (`bind`, or `volume`).
            - **ReadOnly** ‚Äì A boolean indicating whether the mount should be read-only.
            - **BindOptions** - Optional configuration for the `bind` type
              - **Propagation** ‚Äì A propagation mode with the value `[r]private`, `[r]shared`, or `[r]slave`.
            - **VolumeOptions** ‚Äì Optional configuration for the `volume` type.
                - **NoCopy** ‚Äì A boolean indicating if volume should be
                  populated with the data from the target. (Default false)
                - **Labels** ‚Äì User-defined name and labels for the volume.
                - **DriverConfig** ‚Äì Map of driver-specific options.
                  - **Name** - Name of the driver to use to create the volume
                  - **Options** - key/value map of driver specific options
        - **StopGracePeriod** ‚Äì Amount of time to wait for the container to terminate before
          forcefully killing it.
    - **Resources** ‚Äì Resource requirements which apply to each individual container created as part
      of the service.
        - **Limits** ‚Äì Define resources limits.
            - **CPU** ‚Äì CPU limit
            - **Memory** ‚Äì Memory limit
        - **Reservation** ‚Äì Define resources reservation.
            - **CPU** ‚Äì CPU reservation
            - **Memory** ‚Äì Memory reservation
    - **RestartPolicy** ‚Äì Specification for the restart policy which applies to containers created
      as part of this service.
        - **Condition** ‚Äì Condition for restart (`none`, `on-failure`, or `any`).
        - **Delay** ‚Äì Delay between restart attempts.
        - **MaxAttempts** ‚Äì Maximum attempts to restart a given container before giving up (default value
          is 0, which is ignored).
        - **Window** ‚Äì Windows is the time window used to evaluate the restart policy (default value is
          0, which is unbounded).
    - **Placement** ‚Äì An array of constraints.
- **Mode** ‚Äì Scheduling mode for the service (`replicated` or `global`, defaults to `replicated`).
- **UpdateConfig** ‚Äì Specification for the update strategy of the service.
    - **Parallelism** ‚Äì Maximum number of tasks to be updated in one iteration (0 means unlimited
      parallelism).
    - **Delay** ‚Äì Amount of time between updates.
- **Networks** ‚Äì Array of network names or IDs to attach the service to.
- **EndpointSpec** ‚Äì Properties that can be configured to access and load balance a service.
    - **Mode** ‚Äì The mode of resolution to use for internal load balancing
      between tasks (`vip` or `dnsrr`). Defaults to `vip` if not provided.
    - **Ports** ‚Äì List of exposed ports that this service is accessible on from
      the outside, in the form of:
      `{"Protocol": <"tcp"|"udp">, "PublishedPort": <port>, "TargetPort": <port>}`.
      Ports can only be provided if `vip` resolution mode is used.

**Query parameters**:

- **version** ‚Äì The version number of the service object being updated. This is
  required to avoid conflicting writes.

**Request Headers**:

- **Content-type** ‚Äì Set to `"application/json"`.
- **X-Registry-Auth** ‚Äì base64-encoded AuthConfig object, containing either
  login information, or a token. Refer to the [create an image](docker_remote_api_v1.25.md#create-an-image)
  section for more details.

**Status codes**:

-   **200** ‚Äì no error
-   **404** ‚Äì no such service
-   **500** ‚Äì server error

## 3.10 Tasks

**Note**: Task operations require the engine to be part of a swarm.

### List tasks


`GET /tasks`

List tasks

**Example request**:

    GET /tasks HTTP/1.1

**Example response**:

    [
      {
        "ID": "0kzzo1i0y4jz6027t0k7aezc7",
        "Version": {
          "Index": 71
        },
        "CreatedAt": "2016-06-07T21:07:31.171892745Z",
        "UpdatedAt": "2016-06-07T21:07:31.376370513Z",
        "Spec": {
          "ContainerSpec": {
            "Image": "redis"
          },
          "Resources": {
            "Limits": {},
            "Reservations": {}
          },
          "RestartPolicy": {
            "Condition": "any",
            "MaxAttempts": 0
          },
          "Placement": {}
        },
        "ServiceID": "9mnpnzenvg8p8tdbtq4wvbkcz",
        "Slot": 1,
        "NodeID": "60gvrl6tm78dmak4yl7srz94v",
        "Status": {
          "Timestamp": "2016-06-07T21:07:31.290032978Z",
          "State": "running",
          "Message": "started",
          "ContainerStatus": {
            "ContainerID": "e5d62702a1b48d01c3e02ca1e0212a250801fa8d67caca0b6f35919ebc12f035",
            "PID": 677
          }
        },
        "DesiredState": "running",
        "NetworksAttachments": [
          {
            "Network": {
              "ID": "4qvuz4ko70xaltuqbt8956gd1",
              "Version": {
                "Index": 18
              },
              "CreatedAt": "2016-06-07T20:31:11.912919752Z",
              "UpdatedAt": "2016-06-07T21:07:29.955277358Z",
              "Spec": {
                "Name": "ingress",
                "Labels": {
                  "com.docker.swarm.internal": "true"
                },
                "DriverConfiguration": {},
                "IPAMOptions": {
                  "Driver": {},
                  "Configs": [
                    {
                      "Subnet": "10.255.0.0/16",
                      "Gateway": "10.255.0.1"
                    }
                  ]
                }
              },
              "DriverState": {
                "Name": "overlay",
                "Options": {
                  "com.docker.network.driver.overlay.vxlanid_list": "256"
                }
              },
              "IPAMOptions": {
                "Driver": {
                  "Name": "default"
                },
                "Configs": [
                  {
                    "Subnet": "10.255.0.0/16",
                    "Gateway": "10.255.0.1"
                  }
                ]
              }
            },
            "Addresses": [
              "10.255.0.10/16"
            ]
          }
        ],
      },
      {
        "ID": "1yljwbmlr8er2waf8orvqpwms",
        "Version": {
          "Index": 30
        },
        "CreatedAt": "2016-06-07T21:07:30.019104782Z",
        "UpdatedAt": "2016-06-07T21:07:30.231958098Z",
        "Name": "hopeful_cori",
        "Spec": {
          "ContainerSpec": {
            "Image": "redis"
          },
          "Resources": {
            "Limits": {},
            "Reservations": {}
          },
          "RestartPolicy": {
            "Condition": "any",
            "MaxAttempts": 0
          },
          "Placement": {}
        },
        "ServiceID": "9mnpnzenvg8p8tdbtq4wvbkcz",
        "Slot": 1,
        "NodeID": "60gvrl6tm78dmak4yl7srz94v",
        "Status": {
          "Timestamp": "2016-06-07T21:07:30.202183143Z",
          "State": "shutdown",
          "Message": "shutdown",
          "ContainerStatus": {
            "ContainerID": "1cf8d63d18e79668b0004a4be4c6ee58cddfad2dae29506d8781581d0688a213"
          }
        },
        "DesiredState": "shutdown",
        "NetworksAttachments": [
          {
            "Network": {
              "ID": "4qvuz4ko70xaltuqbt8956gd1",
              "Version": {
                "Index": 18
              },
              "CreatedAt": "2016-06-07T20:31:11.912919752Z",
              "UpdatedAt": "2016-06-07T21:07:29.955277358Z",
              "Spec": {
                "Name": "ingress",
                "Labels": {
                  "com.docker.swarm.internal": "true"
                },
                "DriverConfiguration": {},
                "IPAMOptions": {
                  "Driver": {},
                  "Configs": [
                    {
                      "Subnet": "10.255.0.0/16",
                      "Gateway": "10.255.0.1"
                    }
                  ]
                }
              },
              "DriverState": {
                "Name": "overlay",
                "Options": {
                  "com.docker.network.driver.overlay.vxlanid_list": "256"
                }
              },
              "IPAMOptions": {
                "Driver": {
                  "Name": "default"
                },
                "Configs": [
                  {
                    "Subnet": "10.255.0.0/16",
                    "Gateway": "10.255.0.1"
                  }
                ]
              }
            },
            "Addresses": [
              "10.255.0.5/16"
            ]
          }
        ]
      }
    ]

**Query parameters**:

- **filters** ‚Äì a JSON encoded value of the filters (a `map[string][]string`) to process on the
  services list. Available filters:
  - `id=<task id>`
  - `name=<task name>`
  - `service=<service name>`
  - `node=<node id or name>`
  - `label=key` or `label="key=value"`
  - `desired-state=(running | shutdown | accepted)`

**Status codes**:

- **200** ‚Äì no error
- **500** ‚Äì server error

### Inspect a task


`GET /tasks/(task id)`

Get details on a task

**Example request**:

    GET /tasks/0kzzo1i0y4jz6027t0k7aezc7 HTTP/1.1

**Example response**:

    {
      "ID": "0kzzo1i0y4jz6027t0k7aezc7",
      "Version": {
        "Index": 71
      },
      "CreatedAt": "2016-06-07T21:07:31.171892745Z",
      "UpdatedAt": "2016-06-07T21:07:31.376370513Z",
      "Spec": {
        "ContainerSpec": {
          "Image": "redis"
        },
        "Resources": {
          "Limits": {},
          "Reservations": {}
        },
        "RestartPolicy": {
          "Condition": "any",
          "MaxAttempts": 0
        },
        "Placement": {}
      },
      "ServiceID": "9mnpnzenvg8p8tdbtq4wvbkcz",
      "Slot": 1,
      "NodeID": "60gvrl6tm78dmak4yl7srz94v",
      "Status": {
        "Timestamp": "2016-06-07T21:07:31.290032978Z",
        "State": "running",
        "Message": "started",
        "ContainerStatus": {
          "ContainerID": "e5d62702a1b48d01c3e02ca1e0212a250801fa8d67caca0b6f35919ebc12f035",
          "PID": 677
        }
      },
      "DesiredState": "running",
      "NetworksAttachments": [
        {
          "Network": {
            "ID": "4qvuz4ko70xaltuqbt8956gd1",
            "Version": {
              "Index": 18
            },
            "CreatedAt": "2016-06-07T20:31:11.912919752Z",
            "UpdatedAt": "2016-06-07T21:07:29.955277358Z",
            "Spec": {
              "Name": "ingress",
              "Labels": {
                "com.docker.swarm.internal": "true"
              },
              "DriverConfiguration": {},
              "IPAMOptions": {
                "Driver": {},
                "Configs": [
                  {
                    "Subnet": "10.255.0.0/16",
                    "Gateway": "10.255.0.1"
                  }
                ]
              }
            },
            "DriverState": {
              "Name": "overlay",
              "Options": {
                "com.docker.network.driver.overlay.vxlanid_list": "256"
              }
            },
            "IPAMOptions": {
              "Driver": {
                "Name": "default"
              },
              "Configs": [
                {
                  "Subnet": "10.255.0.0/16",
                  "Gateway": "10.255.0.1"
                }
              ]
            }
          },
          "Addresses": [
            "10.255.0.10/16"
          ]
        }
      ]
    }

**Status codes**:

- **200** ‚Äì no error
- **404** ‚Äì unknown task
- **500** ‚Äì server error

# 4. Going further

## 4.1 Inside `docker run`

As an example, the `docker run` command line makes the following API calls:

- Create the container

- If the status code is 404, it means the image doesn't exist:
    - Try to pull it.
    - Then, retry to create the container.

- Start the container.

- If you are not in detached mode:
- Attach to the container, using `logs=1` (to have `stdout` and
      `stderr` from the container's start) and `stream=1`

- If in detached mode or only `stdin` is attached, display the container's id.

## 4.2 Hijacking

In this version of the API, `/attach`, uses hijacking to transport `stdin`,
`stdout`, and `stderr` on the same socket.

To hint potential proxies about connection hijacking, Docker client sends
connection upgrade headers similarly to websocket.

    Upgrade: tcp
    Connection: Upgrade

When Docker daemon detects the `Upgrade` header, it switches its status code
from **200 OK** to **101 UPGRADED** and resends the same headers.


## 4.3 CORS Requests

To set cross origin requests to the remote api please give values to
`--api-cors-header` when running Docker in daemon mode. Set * (asterisk) allows all,
default or blank means CORS disabled

    $ dockerd -H="192.168.1.9:2375" --api-cors-header="http://foo.bar"
                                                                                                                                                                  go/src/github.com/docker/docker/docs/reference/api/hub_registry_spec.md                             0100644 0000000 0000000 00000001105 13101060260 024701  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/api/hub_registry_spec/
description: Documentation for docker Registry and Registry API
published: false
keywords:
- docker, registry, api,  hub
title: Docker Hub and Registry v1
---

This API is deprecated as of 1.7. To view the old version, see the [go
here](/v1.7/docker/reference/api/hub_registry_spec/) in
the 1.7 documentation. If you want an overview of the current features in
Docker Hub or other image management features see the [image management
overview](../../userguide/eng-image/image_management.md) in the current documentation set.
                                                                                                                                                                                                                                                                                                                                                                                                                                                           go/src/github.com/docker/docker/docs/reference/api/images/                                          0040755 0000000 0000000 00000000000 13101060260 022112  5                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        go/src/github.com/docker/docker/docs/reference/api/images/event_state.gliffy                        0100644 0000000 0000000 00000211500 13101060260 025631  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        {"contentType":"application/gliffy+json","version":"1.3","stage":{"background":"#FFFFFF","width":1193,"height":556,"nodeIndex":370,"autoFit":true,"exportBorder":false,"gridOn":true,"snapToGrid":true,"drawingGuidesOn":true,"pageBreaksOn":false,"printGridOn":false,"printPaper":"LETTER","printShrinkToFit":false,"printPortrait":true,"maxWidth":5000,"maxHeight":5000,"themeData":null,"viewportType":"default","fitBB":{"min":{"x":26.46762966848334,"y":100},"max":{"x":1192.861928406027,"y":555.2340187157677}},"printModel":{"pageSize":"Letter","portrait":true,"fitToOnePage":false,"displayPageBreaks":false},"objects":[{"x":373.99998474121094,"y":389.93402099609375,"rotation":0.0,"id":355,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":0,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":191,"py":0.7071067811865475,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":-0.663724900050094,"endArrowRotation":-0.6637248993502937,"interpolationType":"quadratic","cornerRadius":null,"controlPath":[[22.0,-17.0],[94.00000762939453,-17.0],[94.00000762939453,-61.64974974863185],[166.00001525878906,-61.64974974863185]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":359,"width":75.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.5,"linePerpValue":0.0,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\">docker start</span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":275.99998474121094,"y":323.93402099609375,"rotation":0.0,"id":344,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":127,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":335,"py":1.0,"px":0.5}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":193,"py":0.0,"px":0.7071067811865476}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":105.08369488824782,"endArrowRotation":91.96866662391399,"interpolationType":"quadratic","cornerRadius":null,"controlPath":[[22.531977827253513,30.06597900390625],[22.531977827253513,51.06597900390625],[-52.96697615221987,51.06597900390625],[-52.96697615221987,106.06597900390625]],"lockSegments":{"1":true},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":347,"width":64.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\">docker rm</span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":279.99998474121094,"y":249.93402099609375,"rotation":0.0,"id":342,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":126,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":188,"py":0.5,"px":1.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":191,"py":0.0,"px":0.5}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[-74.99998474121094,0.06597900390625],[297.50001525878906,0.06597900390625],[297.50001525878906,50.06597900390625]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":313.99998474121094,"y":290.93402099609375,"rotation":0.0,"id":341,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":123,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":335,"py":0.5,"px":1.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":191,"py":0.5,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[19.531977827253513,28.06597900390625],[88.35546419381131,28.06597900390625],[157.17895056036912,28.06597900390625],[226.00243692692698,28.06597900390625]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":353,"width":75.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\">docker start</span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":214.99998474121094,"y":322.93402099609375,"rotation":0.0,"id":340,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":122,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":228,"py":0.5733505249023437,"px":1.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":335,"py":0.5,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[-7.637919363960094,-3.93402099609375],[11.085379699777775,-3.93402099609375],[29.808678763515644,-3.93402099609375],[48.53197782725351,-3.93402099609375]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":83.0,"y":251.0,"rotation":0.0,"id":328,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":116,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":188,"py":0.5,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[-52.03237033151666,-0.9999999999999716],[47.0,-1.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":332,"width":67.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.5233416311379174,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\"><span style=\"\">docker run</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":74.0,"y":318.0,"rotation":0.0,"id":327,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":113,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":228,"py":0.5,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[-42.0,1.0],[58.5,2.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":333,"width":85.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.5689443767164591,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\"><span style=\"\">docker create</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":191.0,"y":409.0,"rotation":0.0,"id":325,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":112,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":193,"py":0.5,"px":0.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":215,"py":0.5,"px":1.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[-21.0,41.0],[-61.0,41.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":331.0,"y":346.0,"rotation":0.0,"id":320,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":109,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":209,"py":0.5,"px":0.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":193,"py":0.5,"px":1.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[2.5319625684644507,49.0],[-41.734018715767775,49.0],[-41.734018715767775,104.0],[-86.0,104.0]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":324,"width":64.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\">docker rm</span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":872.0,"y":503.0,"rotation":0.0,"id":310,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":108,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":205,"py":0.0,"px":0.2928932188134524}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[-60.03300858899104,-53.0],[-148.0,-151.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":735.0,"y":341.0,"rotation":0.0,"id":307,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":105,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":203,"py":0.2928932188134525,"px":1.1102230246251563E-16}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[0.0,0.0],[137.5,60.7157287525381]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":309,"width":83.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.37922003257116654,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\"><span style=\"\">docker pause</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":1023.0,"y":446.0,"rotation":0.0,"id":298,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":102,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":213,"py":1.0,"px":0.5}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":205,"py":0.5,"px":1.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[39.5,-1.0],[39.5,24.0],[-158.0,24.0]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":313,"width":100.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.37286693198126664,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:left;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\"><span style=\"\">&nbsp;docker unpause</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":904.0,"y":434.0,"rotation":0.0,"id":295,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":101,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":203,"py":0.5,"px":1.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":213,"py":0.5,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[43.5,-24.0],[123.5,-24.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":411.0,"y":419.0,"rotation":0.0,"id":291,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":98,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":217,"py":0.5,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[7.2659812842321685,51.0],[-14.0,51.0],[-14.0,-3.0]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":292,"width":21.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.5714437496124175,"linePerpValue":0.0,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-style:italic;font-family:Arial;\"><span style=\"\">No</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":415.0,"y":419.0,"rotation":0.0,"id":289,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":95,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":217,"py":0.0,"px":0.5}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":191,"py":1.0,"px":0.5}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[53.26598128423217,1.0],[53.26598128423217,-32.5],[162.5,-32.5],[162.5,-79.0]],"lockSegments":{"1":true},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":290,"width":26.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.46753493572435184,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-style:italic;font-family:Arial;\"><span style=\"\">Yes</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":521.0,"y":209.0,"rotation":0.0,"id":287,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":94,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":195,"py":0.5,"px":0.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":209,"py":0.5,"px":1.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[-11.0,-19.0],[-97.23401871576777,-19.0],[-97.23401871576777,186.0],[-117.46803743153555,186.0]],"lockSegments":{"1":true},"ortho":true}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":988.0,"y":232.0,"rotation":0.0,"id":282,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":93,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":201,"py":0.5,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[39.5,18.0],[-150.0,18.0],[-150.0,68.0],[-250.0,68.0]],"lockSegments":{"1":true},"ortho":true}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":664.0,"y":493.0,"rotation":0.0,"id":276,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":92,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":207,"py":0.5,"px":0.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":236,"py":0.7071067811865475,"px":0.9999999999999998}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[8.5,42.23401871576766],[-20.25,42.23401871576766],[-20.25,-44.7157287525381],[-49.0,-44.7157287525381]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":678.0,"y":344.0,"rotation":0.0,"id":273,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":89,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":236,"py":0.29289321881345237,"px":1.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":91.17113025781374,"endArrowRotation":176.63803454243802,"interpolationType":"quadratic","cornerRadius":null,"controlPath":[[2.0,-4.0],[2.0,87.7157287525381],[-63.0,87.7157287525381]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":275,"width":59.0,"height":42.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.5,"linePerpValue":0.0,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-family:Arial;\"><span style=\"\">container&nbsp;</span></span></p><p style=\"text-align:center;\"><span style=\"font-size:12px;font-family:Arial;\"><span style=\"\">process</span></span></p><p style=\"text-align:center;\"><span style=\"font-size:12px;font-family:Arial;\"><span style=\"\">exited</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":566.0,"y":431.0,"rotation":0.0,"id":272,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":88,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":236,"py":0.5,"px":0.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":217,"py":0.5,"px":1.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[-26.0,9.0],[-36.867009357883944,9.0],[-36.867009357883944,39.0],[-47.73401871576789,39.0]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":785.0,"y":119.0,"rotation":0.0,"id":270,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":87,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":199,"py":0.5,"px":0.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":209,"py":0.0,"px":0.5}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":10.0,"controlPath":[[5.0,1.0],[-416.46803743153555,1.0],[-416.46803743153555,241.0]],"lockSegments":{},"ortho":true}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":829.0,"y":172.0,"rotation":0.0,"id":269,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":86,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":248,"py":0.0,"px":0.5}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":199,"py":1.0,"px":0.5}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[-1.5,-2.0],[-1.5,-32.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":661.0,"y":189.0,"rotation":0.0,"id":267,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":85,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":195,"py":0.5,"px":1.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[7.0,2.284271247461902],[-76.0,1.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":946.0,"y":319.0,"rotation":0.0,"id":263,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":83,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":197,"py":0.5,"px":1.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":233,"py":0.5,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[1.5,1.0],[81.5,1.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":708.0,"y":286.0,"rotation":0.0,"id":256,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":80,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":211,"py":0.0,"px":0.5}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":254,"py":1.0,"px":0.5}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[-0.5,-2.0],[-0.5,-76.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":258,"width":64.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.3108108108108108,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\"><span style=\"\">docker kill</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":710.0,"y":359.0,"rotation":0.0,"id":245,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":68,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":211,"py":1.0,"px":0.5}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":207,"py":0.0,"px":0.5}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[-2.5,-5.0],[0.0,156.23401871576766]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":247,"width":84.0,"height":28.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-family:Arial;\"><span style=\"font-style:italic;\">&nbsp;killed&nbsp;</span></span><span style=\"\">by</span></p><p style=\"text-align:center;\"><span style=\"font-size:12px;font-family:Arial;\"><span style=\"font-style:italic;\">out-of-memory</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":761.0,"y":318.0,"rotation":0.0,"id":238,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":65,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":211,"py":0.5,"px":1.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":197,"py":0.5,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[-18.5,1.0],[111.5,2.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":240,"width":87.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.4363456059259962,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\"><span style=\"\">docker restart</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":608.0,"y":319.0,"rotation":0.0,"id":232,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":58,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":191,"py":0.5,"px":1.0}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":211,"py":0.5,"px":0.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[7.0,1.0],[64.5,0.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":333.53196256846445,"y":360.0,"rotation":0.0,"id":209,"width":70.0,"height":70.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.connector","order":33,"lockAspectRatio":true,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.ellipse.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#e6b8af","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5555555555555554,"y":0.0,"rotation":0.0,"id":210,"width":66.88888888888889,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">stopped</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":540.0,"y":300.0,"rotation":0.0,"id":191,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":6,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":192,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">start</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":510.0,"y":170.0,"rotation":0.0,"id":195,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":12,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":196,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">kill</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":872.5,"y":300.0,"rotation":0.0,"id":197,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":15,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":198,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">die</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":790.0,"y":100.0,"rotation":0.0,"id":199,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":18,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":200,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">stop</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":790.0,"y":450.0,"rotation":0.0,"id":205,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":27,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":206,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">unpause</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":672.5,"y":515.2340187157677,"rotation":0.0,"id":207,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":30,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":208,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">OOM</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":672.5,"y":284.0,"rotation":0.0,"id":211,"width":70.0,"height":70.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.connector","order":36,"lockAspectRatio":true,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.ellipse.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#b6d7a8","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5555555555555556,"y":0.0,"rotation":0.0,"id":212,"width":66.88888888888889,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">running</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":403.5319625684644,"y":420.0,"rotation":0.0,"id":227,"width":130.46803743153555,"height":116.23401871576777,"uid":"com.gliffy.shape.basic.basic_v1.default.group","order":54,"lockAspectRatio":false,"lockShape":false,"children":[{"x":-6.765981284232225,"y":76.0,"rotation":45.0,"id":223,"width":80.0,"height":14.0,"uid":"com.gliffy.shape.basic.basic_v1.default.text","order":53,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\"><span style=\"\">Restart&nbsp;</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":57.234018715767775,"y":75.0,"rotation":315.0,"id":219,"width":80.0,"height":14.0,"uid":"com.gliffy.shape.basic.basic_v1.default.text","order":51,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\"><span style=\"\">Policy</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":14.734018715767775,"y":0.0,"rotation":0.0,"id":217,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.decision","order":46,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.diamond.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":2.0,"y":0.0,"rotation":0.0,"id":218,"width":96.0,"height":28.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">Should restart?</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":1027.5,"y":375.0,"rotation":0.0,"id":213,"width":70.0,"height":70.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.connector","order":39,"lockAspectRatio":true,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.ellipse.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#fce5cd","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5555555555555556,"y":0.0,"rotation":0.0,"id":214,"width":66.88888888888889,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">paused</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":872.5,"y":390.0,"rotation":0.0,"id":203,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":24,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":204,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">pause</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":540.0,"y":420.0,"rotation":0.0,"id":236,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":62,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":237,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">die</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":790.0,"y":170.0,"rotation":0.0,"id":248,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":71,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":249,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">die</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":670.0,"y":170.0,"rotation":0.0,"id":254,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":77,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":255,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">die</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":740.0,"y":323.0,"rotation":0.0,"id":250,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":74,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":248,"py":1.0,"px":0.5}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[-10.0,-33.0],[87.5,-113.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":253,"width":73.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\"><span style=\"\">docker stop</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":1027.5,"y":300.0,"rotation":0.0,"id":233,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":59,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":234,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">start</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":1027.5,"y":230.0,"rotation":0.0,"id":201,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":21,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":202,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">restart</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":1066.5,"y":298.0,"rotation":0.0,"id":264,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":84,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":233,"py":0.0,"px":0.5}},"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":201,"py":1.0,"px":0.5}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":"auto","endArrowRotation":"auto","interpolationType":"linear","cornerRadius":null,"controlPath":[[-1.5,2.0],[-1.5,-28.0]],"lockSegments":{},"ortho":false}},"linkMap":[],"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":132.5,"y":300.0,"rotation":0.0,"id":228,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":55,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":229,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">create</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":130.0,"y":230.0,"rotation":0.0,"id":188,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":3,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":190,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">create</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":263.53196256846445,"y":284.0,"rotation":0.0,"id":335,"width":70.0,"height":70.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.connector","order":119,"lockAspectRatio":true,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.ellipse.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#a4c2f4","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5555555555555554,"y":0.0,"rotation":0.0,"id":336,"width":66.88888888888889,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">created</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":60.0,"y":415.0,"rotation":0.0,"id":215,"width":70.0,"height":70.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.connector","order":42,"lockAspectRatio":true,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.ellipse.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#b7b7b7","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5555555555555556,"y":0.0,"rotation":0.0,"id":216,"width":66.88888888888889,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">deleted</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":170.0,"y":430.0,"rotation":0.0,"id":193,"width":75.0,"height":40.0,"uid":"com.gliffy.shape.flowchart.flowchart_v1.default.process","order":9,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Shape","Shape":{"tid":"com.gliffy.stencil.rectangle.basic_v1","strokeWidth":2.0,"strokeColor":"#333333","fillColor":"#FFFFFF","gradient":false,"dashStyle":null,"dropShadow":false,"state":0,"opacity":1.0,"shadowX":0.0,"shadowY":0.0}},"linkMap":[],"children":[{"x":1.5,"y":0.0,"rotation":0.0,"id":194,"width":72.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"none","paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":null,"linePerpValue":null,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"text-decoration:none;font-size:12px;font-family:Arial;\"><span style=\"text-decoration:none;\">destroy</span></span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":1133.0,"y":570.0,"rotation":0.0,"id":362,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":130,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":213,"py":0.5,"px":1.0}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":0.9595103354441726,"endArrowRotation":177.33110321368451,"interpolationType":"quadratic","cornerRadius":null,"controlPath":[[-55.0,-192.0],[-3.5,-192.0],[-3.5,-160.0],[-35.5,-160.0]],"lockSegments":{"1":true},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":363,"width":87.0,"height":14.0,"uid":null,"order":"auto","lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.5835366104291947,"linePerpValue":-20.0,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\">docker update</span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":281.0,"y":596.0,"rotation":0.0,"id":364,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":133,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"endConstraint":{"type":"EndPositionConstraint","EndPositionConstraint":{"nodeId":335,"py":0.0,"px":0.5}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":-88.08561222234982,"endArrowRotation":85.23919045962671,"interpolationType":"quadratic","cornerRadius":null,"controlPath":[[-7.0,-301.0],[-7.0,-334.0],[17.53196256846445,-334.0],[17.53196256846445,-312.0]],"lockSegments":{"1":true},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":365,"width":87.0,"height":14.0,"uid":null,"order":135,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.524371533874117,"linePerpValue":0.0,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\">docker update</span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":305.0,"y":604.0,"rotation":0.0,"id":366,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":136,"lockAspectRatio":false,"lockShape":false,"constraints":{"constraints":[],"startConstraint":{"type":"StartPositionConstraint","StartPositionConstraint":{"nodeId":209,"py":1.0,"px":0.5}}},"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":92.55340974719384,"endArrowRotation":-91.2277874986563,"interpolationType":"quadratic","cornerRadius":null,"controlPath":[[63.53196256846445,-174.0],[63.53196256846445,-144.0],[37.0,-144.0],[37.0,-186.0]],"lockSegments":{"1":true},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":367,"width":87.0,"height":14.0,"uid":null,"order":138,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.5749848592663713,"linePerpValue":-20.0,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\">docker update</span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"},{"x":516.0,"y":570.0,"rotation":0.0,"id":368,"width":100.0,"height":100.0,"uid":"com.gliffy.shape.basic.basic_v1.default.line","order":139,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Line","Line":{"strokeWidth":2.0,"strokeColor":"#000000","fillColor":"none","dashStyle":null,"startArrow":0,"endArrow":1,"startArrowRotation":183.34296440226473,"endArrowRotation":-0.7310374013608921,"interpolationType":"quadratic","cornerRadius":null,"controlPath":[[158.0,-263.0],[134.0,-263.0],[134.0,-284.0],[182.0,-284.0]],"lockSegments":{"1":true},"ortho":true}},"linkMap":[],"children":[{"x":0.0,"y":0.0,"rotation":0.0,"id":369,"width":87.0,"height":14.0,"uid":null,"order":141,"lockAspectRatio":false,"lockShape":false,"graphic":{"type":"Text","Text":{"overflow":"both","paddingTop":2,"paddingRight":2,"paddingBottom":2,"paddingLeft":2,"outerPaddingTop":6,"outerPaddingRight":6,"outerPaddingBottom":2,"outerPaddingLeft":6,"type":"fixed","lineTValue":0.4230219192816351,"linePerpValue":-20.0,"cardinalityType":null,"html":"<p style=\"text-align:center;\"><span style=\"font-size:12px;font-weight:bold;font-family:Arial;\">docker update</span></p>","tid":null,"valign":"middle","vposition":"none","hposition":"none"}},"children":[],"hidden":false,"layerId":"gmMmie3VnJbh"}],"hidden":false,"layerId":"gmMmie3VnJbh"}],"layers":[{"guid":"gmMmie3VnJbh","order":0,"name":"Layer 0","active":true,"locked":false,"visible":true,"nodeIndex":142}],"shapeStyles":{"com.gliffy.shape.uml.uml_v2.state_machine":{"fill":"#e2e2e2","stroke":"#000000","strokeWidth":2},"com.gliffy.shape.flowchart.flowchart_v1.default":{"fill":"#a4c2f4","stroke":"#333333","strokeWidth":2}},"lineStyles":{"global":{"endArrow":1,"orthoMode":2}},"textStyles":{"global":{"color":"#000000"}}},"metadata":{"title":"untitled","revision":0,"exportBorder":false,"loadPosition":"default","libraries":["com.gliffy.libraries.flowchart.flowchart_v1.default"],"autosaveDisabled":false,"lastSerialized":1451304727693,"analyticsProduct":"Online"},"embeddedResources":{"index":0,"resources":[]}}                                                                                                                                                                                                go/src/github.com/docker/docker/docs/reference/api/images/event_state.png                           0100644 0000000 0000000 00000231022 13101060260 025136  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        âPNG

   IHDR  i  ?   ƒÑ{    IDATx^Ï›	¸Us˛«ÒèeY≥Ub≤5!JŸCŸ3∂TÑà≤D%îD°¶±ómd-[Ÿì•¬§≤’¯QŸ ¢Ï%La¶ˇ„˝ù9˝o?ø_øsÔ=˜‹Ô9Áuèﬂ£ÂwñÔy~ø˜,Ô˚=ﬂ≥““•Kó Ä  Ä  Ä  Ä@YV"§)´?G @ @ @ ú !@ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä  Ä  Ä !m @ @ @ @Äê∆ÉJ† Ä  Ä $Y`ßùvJrÒÀRˆäää≤lóç"ÄÄﬂÑ4~◊•C @ @¿{Bö¸´àê&3ñ@ Ñ4Y®eˆ@ @ Å
!¡CÕ»X’lƒdYÄê&Àµœæ#Ä  Ä  Å ¡CxD¨¬[1'Y §…b≠≥œ Ä  Ä D(@´VÃâ@i≤XÎÏ3 Ä  Ä 
<Ñ«ƒ*ºs"êEBö,÷:˚å  Ä  Ä@Ñ·1±
o≈údQÄê&ãµŒ>#Ä  Ä  ° ¡CxL¨¬[1'Y §…b≠≥œ Ä  Ä D(@´VÃâ@i≤XÎÏ3 Ä  Ä 
<Ñ«ƒ*ºs"êEBö,÷:˚å  Ä  Ä@Ñ·1±
o≈údQÄê&ãµŒ>#Ä  Ä  ° ¡CxL¨¬[1'Y §…b≠≥œ Ä  Ä D(@´VÃâ@i≤XÎÏ3 Ä  Ä 
<Ñ«ƒ*ºs"êEBö,÷:˚å  Ä  Ä@Ñ·1±
o≈údQÄê&ãµŒ>#Ä  Ä  ° ¡CxL¨¬[1'Y §…b≠≥œ Ä  Ä D(@´VÃâ@i≤XÎÏ3 Ä  Ä 
¯<º˛˙Î∂∆kXì&M"‹ªhWÂãU¥{≈⁄@ *Bö®$Y Ä  Ä %x8Ù–Cm¿Ä∂ÛŒ;{[æXyD¡»∏ !M∆ ªè ÈX≤dâ-X∞¿æ¸ÚK˚ÓªÔ“∑ÉÏ ÄÄwgûy¶’™UÀ¶OüKŸ&Lò`'ûx¢}ı’WvŒ9Áÿ‡¡ÉÌπÁû≥#è<“m∆åˆß?˝…ÆºÚJ⁄¨µ÷Zv˜›w[ªvÌlÒ‚≈÷•K€~˚ÌÌ¬/¥ç6⁄»}ÙQk’™U,e'§âÖôç êXBöƒVG ˛_‡∑ﬂ~≥O?˝‘***lˆÏŸ6oﬁ<“|ˇ˝˜0!Ä  PrÅwﬁy«÷_}”ü•ûÊœüoıÎ◊∑)S¶ÿ¶õnjGqÑuÍ‘…:wÓÏBö”N;Õé:Í(ªË¢ãÏ©ßû≤±c«⁄‹πs≠m€∂6~¸xk›∫µµlŸ“Ö5œ<ÛåΩ˙Í´÷µkW{˜›w›zK=“îZòı#êlBöd◊•G l·¬ÖÓBuÃò16uÍT÷Ë€ÃÜ⁄zÎ≠á Ä %à3§˘‡ÉlÎ≠∑∂{Óπ«:Ë ∑o´Øæ∫≠πÊö÷±cGª‡Ç\/ıîQ@≥›v€πyÓ∫Î.◊õF¡ç~˜»#èXÛÊÕmÈ“•v¡ª†F·N©'BöR≥~í-@HìÏ˙£Ù êquÛ÷ËÌ∑ﬂn∫h’Ö®.˛5jDHìÒ∂¡Ó#Ä q
ƒ˝∏”Ë—£] £Iè+=˘‰ìnöˆÌ€€yÁùÁBòfÕöπ^2kØΩ∂õÔ°á≤n∏¡ı¶Ÿq«›¡ó
hÏÙÓ›ª‰lÑ4%'f$ZÄê&—’G·@ À?˝ÙìÎ=s’UWπ«ö?¸p◊Õ[ûÙ†…rÀ`ﬂ@ Å¯‚-Zdü˛πUﬁˇ}ªÈ¶õ‹X8œ?ˇºw‹qnúı¥Ÿaál‹∏q÷∏q„e!ÕÕ7ﬂº¨'MÓÔÓË⁄°Cáí„≈iUÚùa π !M‰§¨àG@ﬂ j†D]òÍ¢Rﬂbn±≈Òlú≠ Ä  ê#gÊõo∫ Êç7ﬁp=f“<¿6i“$◊ªfˇ˝˜w=jé=ˆX÷Ë\˘Õ7ﬂÿ`Éraå∆§9‰êCl‡¿Å6m⁄4€wﬂ}Ì£è>≤Õ7ﬂº‰ıßU…wÜ Ä@‰Ñ4ëì≤B@†ÙÍE£o’ãfØΩˆ≤K.πƒuÎfB @†qCÊökÆ±Ûœ?ﬂÌ™w“õùÿ‹yÁùÓÕMW_}µ{˚ìÇ=Ú§Ioy∫¯‚ãÌ◊_u!M”¶MÌ¡tø”€ùÇ7Cï⁄/N´RÔÎG ÅËi¢7eç Ä@…fÕöeó_~πΩÙ“K÷ßO7ÿ·™´ÆZÚÌ≤@ ™(G∞d…”€Î‘©≥\ëÙˇ@?ò~¯·[mµ’¨vÌ⁄ÓøÙVß`ºö?¸·¶ü8œ°Â∞¢’"Ä@riíSWîX&†7S®˜å∆ûπÙ“K≠U´VË Ä  P6Å$Íç™7A}˚Ì∑V∑n›ÿÕíd;D #§° Ä 	–kD/∫Ë"˜‹ΩûØﬂl≥Õ∏@ -IfŒúi€nª≠ÎE˜î4´∏}ÿY §…z`ˇ@ ëCáµ~˝˙Y∑n›l»ê!À∫p'rg(4 Ä@‚¬W!V·≠òÅ,
“d±÷ŸgHº¿ﬂ˛ˆ7˜ä—æ}˚∫êÜ	@ År
<Ñ◊«*ºs"êEBö,÷:˚å â §I|≤ Ä@™¬W'V·≠òÅ,
“d±÷ŸgHº !M‚´ê@ R%@æ:±
o≈údQÄê&ãµŒ>#Ä@‚i_ÖÏ  ê*Çá’âUx+ÊD ãÑ4Y¨uˆ/@Hì¯*d@ ÅT	<ÑØN¨¬[1'Y §…b≠≥œ êxBöƒW!;Ä §JÄ‡!|ubﬁä9»¢ !Mkù}F Åƒ“$æ
Ÿ@ U·´´VÃâ@i≤XÎÏ3$^Äê&ÒU» Ä © x_ùXÖ∑bN≤(@Hì≈Zgü@ ÒÑ4âØBv Hï ¡C¯Íƒ*ºs"êEBö,÷:˚å â §I|≤ Ä@™¬W'V·≠òÅ,
“d±÷ŸgHº !M‚´ê@ R%©⁄©ÔLEEEâ∑¿Í@ âÑ4I¨5 å ô §…|  J¿«êÊó_~±%KñX≠Zµlµ’VÛ KÖ!§ÒÆJ(^“xQ»OÄê&?/ÊF »û¿à#l‰»ëv“I'YÁŒù≥¿#Ä@"iYm≤.@Hìı¿˛#Ä ¨H`Œú9vÈ•óöÇ4∞FçÅÜ x/@H„}Q@@‡˜Ñ4¥
@ ™P8£êFaç¬Ö4Ù¶°≈ Ä@iíPKî®$@HCì@ @†jÅ‹^4¡Ù¶°µ Ä@RiíRSî» §°9 Ä  Pµ@n/ö`z”–Z@ )Ñ4I©) â “–@ X°@–ãfÙË—næ≈ã[Ì⁄µ›ﬂ;tË¿ÿ4¥^Äê∆˚*¢Ä Ä¿ÔËIC´@ @‡˜A/ö`ê‡Iì&Yõ6m‹å
põÜVÉ æ“¯^Cî®BÄêÜfÅ  Ä¿ÚπΩh˙ÙÈcKñ,1ù/˚ˆÌkµj’≤+Æ∏Çﬁ44^Äê∆˚*¢Ä Ä¿Ôih Ä ,/†GúÙFßzıÍπ3ì'O∂Å∫ü÷≠[ªﬂÕü?ﬂ˝Nè>1!Ä >
“¯X+î	®AÄêÜ&Ç  Ä¿ÚFè7i“#NÍ9Ñ4ÍYì˚ª`ú@ ﬂi|´ É Ñ §	Åƒ, Ä ôPœô §QÔ&@ 	Ñ4I®% à T §°I Ä  ∞bBZ$QÄê&âµFô@ ÛÑ4ôo  Ä ‘ @HCA Å$
“$±÷(3d^Äê&ÛM  @ B⁄ §PÄê&Öï .!Ä@˙i“_«Ï! Ä@qÙ§)Œè•@†<Ñ4Âqg´ Ä@QÑ4EÒ±0 Ä@i2P…Ï") §Ia•≤K ê~BöÙ◊1{à  Pú !Mq~,ç Â §)è;[E ä §)äèÖ@ 2 @HìÅJfH° !M
+ï]B ÅÙ“§øéŸC@ Å‚iäÛci(è !My‹Ÿ* Pî !MQ|,å  êBöT2ªà@
iRX©Ï§_Äê&˝uÃ"Ä '@HSúK#Ä@yi „ŒV@ Å¢iä‚ca@ Å“d†íŸER(@Hì¬Jeó@ ˝Ñ4ÈØcˆ@†8Bö‚¸X #@HSw∂ä %@HS#Ä d@Äê&ïÃ."êBBöV*ªÑ È §I≥á Ä ≈	“Á«“ PBöÚ∏≥U@†(Bö¢¯X@ Ñ4®dvÅ
“§∞RŸ%Hø !M˙Îò=D (NÄê¶8?ñF ÅÚ“î«ù≠"Ä E	“≈«¬ Ä  §…@%≥ã§PÄê&Öï .!Ä@˙i“_«•ÿ√ùv⁄©´Mı:+**RΩqÓÌ/Ì$µ?Îwﬁºyˆ≈_XÉ¨~˝˙˘W@âóHR˝ñòÇ’#Ä@é !ÕH† !M+ÕÉ"˚xÂÀ
ã¿MTt5D˚Àﬂ2IÌè˙Mw˝Êøw,Å Ö
“*«r Ä@i àü‡M7QI∫Ò+7V—Àcﬁ4âVI,s¯âvN¨¢ıdm§MÄê&m5 ˛ Ä@&i2QÕëÔ$7·I±
ovNL√Jô%—*âe_#—ŒâU¥û¨Å¥	“§≠FŸ»Ñ !M&™9Úù‰∆ <)V·≠¬ŒâiX)BöR…úìœB2ÎçR#ó !M\“làPÄê&BÃ≠äÉïçUx´∞sbVäê&ºT2Á‰≥êÃz£‘ƒ%@Hó4€A " §â3C´‚∆ |ecﬁ*ÏúòÜï"§	/ïÃ9˘,$≥ﬁ(5q	“ƒ%Õv@ Åi"ƒÃ–™∏1_ŸXÖ∑
;'¶a•i¬K%sN>…¨7Jç@\Ñ4qI≥@ BBö13¥*n¬W6V·≠¬ŒâiX)BöR…úìœB2ÎçR#ó !M\“làPÄê&BÃ≠äÉïçUx´∞sbVäê&ºT2Á‰≥êÃz£‘ƒ%@Hó4€A " §â3C´‚∆ |ecﬁ*ÏúòÜï"§	/ïÃ9˘,$≥ﬁ(5q	“ƒ%Õv@ Åi"ƒÃ–™∏1_ŸXÖ∑
;'¶a•i¬K%sN>…¨7Jç@\Ñ4qI≥@ BBö13¥*n¬W6V·≠¬ŒâiX)BöR…úìœB2ÎçR#ó !M\“làPÄê&BÃ≠äÉïçUx´∞sbVäê&ºT2Á‰≥êÃz£‘ƒ%@Hó4€A " §â3C´‚∆ |ecﬁ*ÏúòÜï"§	/ïÃ9˘,$≥ﬁ(5q	“ƒ%Õv@ Åi"ƒÃ–™∏1_ŸXÖ∑
;'¶a•i¬K%sN>…¨7Jç@\Ñ4qI≥@ BBö13¥*n¬Wv´9sÊÿ•ó^jw›uW¯gxŒ0¶ÊYn◊ìhïƒ2ó´ΩaU.y∂ã@2iíQOîXNÄêÜQà@πo∫tÈbßü~∫ÌºÛŒÀˇ–Cµ~˝˙Yã-l◊]wµIì&Ÿ¯Ò„m˛¸˘÷´WØBvµËeVdÑ3#Fåp€QH”πsÁ¢∑ôˆîª˝Â˙mq˚Ì∑∑≠∑ﬁ⁄ﬁx„[oΩıº©ü¨¬¢¯TfÍ7l≠1¯(@H„c≠P&@†BöH!ÂæâjﬂæΩùwﬁyøi¶Oünõl≤â≠Ωˆ⁄÷¨Y3õ:u™=˝Ù”.§È›ªw!ªZÙ2UYÕò1√ÜfA8£çút“I6p‡@k‘®Q—€L˚
 ›˛r};vÏhÁû{ÆÌ∏„éÆΩÌ≤À.∂⁄j´yS>YÖEÒ©Ã‘oÿZc>QÄê∆«Z°L Ä !Mïø˝ˆõ-\∏–›º/X∞¿~˝ıW⁄Jgûy¶’™UÀäîc iû|ÚI;„å3ÏïW^±Gyƒ8‡ €bã-ºi‘≥Gè5Èœ`"ú…øïÛ&~—¢E÷øª˛˙ÎÌîSN1µøßûz ö6mÍzk]yÂï∂÷ZkŸO<aá~∏€πÎÆªŒŒ>˚l[eïUÚﬂŸ"ó(ßU°E/gô©ﬂBkçÂ@¿GBkÖ2!Ä Ñ4À	|ı’WVQQaoΩıñÕù;◊Ö4ﬂˇΩ)¥a
/Œ;Ôÿ˙ÎØo˙≥ìBöã/æÿæ˝ˆ[k”¶çΩ¬∂Áû{ZﬁË—üz“Ë∆ØAÉÀÖ3πn⁄áb¶ÊÕõ€∫ÎÆ[*‘{ßò<Î¨≥é©qMÂ∫â_∫t©uÔﬁ›>˛¯cª·Ü‹£t˙˜´ØæÍBö†ÕÈë'’Èƒâ]Ω{Ï±v¬	'∏ﬁ_qOÂ≤*f?ÀUfÍ∑òZcYQÄê∆«Z°L Ä !ç¯ÈßüÏı◊_wﬂz´√¨Y≥lÂïW∂Ü∫õ€?¸·¥ï< “húı‰˘˚ﬂˇnœ=˜úÌ∑ﬂ~ÆÙ>á4ıÎ◊∑…ì'Á°ú≠Y√Uœ?ˇºïÎ&^«ëvÿ¡∆ék€m∑ùÈ¶~ﬂ}˜uΩgrÉAÖ1uÍ‘±+Æ∏¬˛Ûüˇ∏cŒ9Áú„¬·’W_=÷ä-óU1;YÆ2Sø≈‘À"ÄÄèÑ4>÷
eB i\@ÛÏ≥œ⁄-∑‹bØΩˆö˚f{∑›v≥&Mö∏êFÉ|Æ∫Í™¥ï< ˝∏ìnx’ìA”®Q£¨Cá^á4*úzpç3∆zˆÏiü|Úâ+ØzØhı¿–cwÖNÄX?ÖN≈.Ø≤œú9≥–ÕÁµúÇër›ƒ/^ºÿ’ïzŒh‹#M¡ò%π!ÕÄñµœ`Á6⁄h#õ={vÏÉ
óÀ*ØJ≠4sπ L˝Sk,ã >
“¯X+î	»xH£«òÙ-∂H÷“ﬁ{ÔmÌ⁄µ≥Ωˆ⁄À‘≥Å©0År›D•’çÒâ'ûËz%h‹è∑ﬂ~€6›tSo{“!MP~¨p&kÙ®ê∆-	€õ§∞ZÛ{©‹qzVTRï´˝˝¸ÛœÆ«Ã∏q„¨q„∆Æòz£òBô‹êF!¶ø;ÄYJﬂ    IDATÎ¨≥‹<z§RΩ˜Ù6≤∏{ÌïÀ™ò÷VÆ2Sø≈‘À"ÄÄèÑ4>÷
eB 2“|Ù—Gvı’W€C=dárà{À∂€nKœô"?Â∫â
ä<÷§rsÃ1Ó∆˜æ˚ÓsΩÙ®âoc“Ti™kxw∏ÜYÆˆß^<jo
xı(ìŒVSyL$¨∑âÈÒ∂Õ6€Ã⁄hı6äª◊^π¨¬’d’sï´Ã‘o1µ∆≤ ‡£ !çèµBô@ Ååá4>¯†`∂n›∫Ó€Ó∂m€“&"(◊MTPtçIs˙Èßªû	ü}ˆôª÷ Æ™o˝nH£ˇˇ‚ã/ºzwÂ*:t®ÈGØÊ.f ‡™6´(g˚˚˙ÎØmˇ˝˜7LïCΩ›i»ê!v…%ó∏YÙ∂±¸„EŒ\h≈î”*âe¶~≠5ñC i|¨ Ñ d8§—+∂5†ÁM7›d]ªvµ/º0ˆÒ “⁄ ìx„WÆ∫¿*zyL¯·[cç5Vÿ3Fèœ®wÜ.◊‰ÉUæ˚ÓCô©ﬂ|kç˘@¿GBkÖ2!Ä iﬁ|ÛMªÏ≤À‹#ÍM£W‡2E#‡√MT4{R˙µ`Ω1¶·Mìhïƒ2áØëhÁƒ*ZO÷Ü@⁄i“V£ÏdB@Í™áIﬂæ}]˜¸4M&Lpè8≠πÊövÈ•óZ´V≠“¥{e›n¬Ûcﬁ*ÏúòÜï≤≤≤æÑøüì˙ØáUx+ÊD ãÑ4Y¨uˆ/êÊê&èFoŒπ¸ÚÀóΩç%ÒïÊ¡pcæ∞
ovNL√J“ÑóJÊú|íYoîÅ∏i‚íf; Ä@ÑiiÓøˇ~ÎﬂøøÌæ˚Ó.§—‡ùL—pcﬁ´VaÁƒ4¨!Mx©dŒ…g!ôıF©àKÄê&.i∂É D(@H!fÜV≈çA¯ ∆*ºUÿ91+EH^*ôsÚYHfΩQj‚ §âKöÌ Ä 
“Dàô°Uqcæ≤±
ovNL√J“ÑóJÊú|íYoîÅ∏i‚íf; Ä@ÑÑ4bfhU‹ÑØl¨¬[Öù”∞RÑ4·•í9'üÖd÷•F .Bö∏§Ÿ ° !MÑòZ7·+´VaÁƒ4¨!Mx©dŒ…g!ôıF©àKÄê&.i∂É D(@H!fÜV≈çA¯ ∆*ºUÿ91+EH^*ôsÚYHfΩQj‚ §âKöÌ Ä 
“Dàô°Uqcæ≤±
ovNL√J“ÑóJÊú|íYoîÅ∏i‚íf; Ä@ÑÑ4bfhU‹ÑØl¨¬[Öù”∞RÑ4·•í9'üÖd÷•F .Bö∏§Ÿ ° !MÑòZ7·+´VaÁƒ4¨!Mx©dŒ…g!ôıF©àKÄê&.i∂É D(@H!fÜV≈çA¯ ∆*ºUÿ91+EH^*ôsÚYHfΩQj‚ §âKöÌ Ä 
“Dàô°U7⁄Â¢wµ¢¢¢Ëu∞Çˇ
–˛Úo	Ij‘o∫Î7ˇΩc	(TÄê¶P9ñC  (@HSF¸oöõ®¸+/I7…˘Ô]ºK¯ÿ˛~˘Â[≤dâ’™UÀV[mµxABl-IÌœó˙Uù.\∏–~˙È'˚ı◊_≠n›∫∂˛˙Îá–éñ$’o¸:lÅÏ
“d∑ÓŸsH∞ !MÇ+è¢#ÄÄ7#Få∞ë#G⁄I'ùdù;wˆ¶\$ú¿‚≈ãmˆÏŸ6yÚdõ:u™˚ô3gŒ≤Ö€µkg∞ÊÕõá[!s!Ä “xP	»WÄê&_1ÊG ñ–Õ¸•ó^j
j–ËfæQ£F0%@`∆å6lÿ03få-X∞† ◊Æ]€’iﬂæ}∞G¯BZ ê@BöVEF ØŒ(§QX£pF7ÙÙ¶Ò™ä™-åB’ùB’]´V≠l—¢Eˆ‚ã/.m<@WßªÌ∂[2väR"Ä ˇ §°) Ä 	 §I`•QdF ∑MP(z”xS=5Dè9Õü?ﬂ‘[Fìz’‹rÀ-ˆÛœ?ªØºÚ ÷ßO◊ã&òß∆ï2 ‡â !ç'A1@ Å|iÚ—b^@`yÅ‹^4¡oËMìºV¢5W\qÖÎQ≥Ó∫ÎZ”¶MÌÀ/ø¥:uÍ∏^4m€∂MﬁNQb»º !MÊõ   êDBö$÷eF Ç^4£Gèv≈QØå†∑Eáõ∆áJ
QÜIì&πGûÙßÓ—£áÕú9”Üj={ˆtı®‡Ü	Hö !M“jåÚ"Ä fFHC3@ 
z—ÉÎ&øMõ6ne
põ¶0◊∏ñR®ˆ¯„èªÛ†z“®∑åÍLˇØ–F	Îﬂz≥ êDBö$÷eF ÅÃ“dæ	 Ä ‰ˆ¢—ò%Kñ,q7˚ª§V≠ZÓ—z” ”"
`ÜÓzÀËÔzu∫ÍÆ^ΩzÆÓTó‘_Lï¡f@†dÑ4%£e≈ Ä@ÈiJgÀö@ ΩzƒIΩ-tSØﬁì'O∂Å∫ü÷≠[ªﬂi@Z˝N7˚L˛®^ƒhÄ`=∆‘≠[7;˝Ù”]]™çzDilıä¢Ó¸©7JÇ ˘“‰o∆ Ä@Ÿi ^ (‹Ã´Ë∫ô◊M“®gçnÙÉﬂÒV *8˜ï€Mö4qonRC˘SGî¢ §âŒí5!Ä ±	“ƒFÕÜ@ ≈Í9Ñ4Í=√‰üÄz«®û‘Ï∂€nºµ…ø*¢D ± !Mƒ†¨àCÄê&e∂Å i §Ò∑Ü’Îi‰»ënúç%§ÅÄ§ÈMNL Ä@öi“\ªÏ§VÄê&µUÀé!Ä@åÑ41bÁ±)ç?3lÿ07˛å¬ç?ú«jòH§ !M"´çB#Ä@÷i≤ﬁÿàBÄê&
≈h◊1{ˆl7Vêy÷ ¡F3˛L¥Œ¨¸ §Ò∑n( P≠ !ç(^Äê¶x√(◊0m⁄47F–¯Ò„›cM
hÙòMî ¨| §ÒΩÜ( PÖ !Õ(^Äê¶x√(÷†Gö¸q7˛ån€∂≠F3!Ä Y §…Zç≥ø ê
BöTT#;Å e §)sòπ1g4ˆåqZ∞`Åµoﬂﬁç?£Wm3!Ä Y §…b≠≥œ êxBöƒW!;Ä “î∑4@∞¬Ö4Fk¸ôzıÍï∑`l(£ !MÒ}ŸÙN;Ì‰KQSéäääƒîïÇ¶SÄê&ùı ^!Ä@ºÑ4ÒzÁnMè5…Ãò1÷®Q#7˛LÁŒù¶|U¬ñ3&pÎ≠∑ö~ò¬tÌ⁄’ÙSÍâê¶‘¬	X?!M˛ïDHìøKD+@H≠'kC Ål
“îßﬁ'Lò‡û:u™ X„œhÄ`&àOÄê&kBö¸ÕX¢@Å §!x®´öçò#BöxúŸ
§[Äê&ﬁ˙’¯3#Gétœô3«3
h‘0!Ä@ºAHWÔﬁEªµ∏≠ËIm˝%rm·´´VÃYZBö“˙≤v»Ü !M|ı¨ÒgÜÓ∆ü— ¡F3˛L|u¿ñ»à;xH≤~‹VÑ4In-ïù‡!<$V·≠ò≥¥Ñ4•ıeÌ êBöxÍYΩf4@à#‹ ¡=zÙpÎÔL PÅ∏ÉáÚÏe4[ç€äê&özKÙZ¬WV·≠ò≥¥Ñ4•ıeÌ êBö“◊Û¥i”‹¯3„«èwè5iÄ`=ÊTªvÌ“oú- Ä@µqIÆä∏≠ií‹Z"*;¡CxH¨¬[1giiJÎÀ⁄@ Ñ4•≠gΩπI∆zìSõ6m‹¯3˙ì	 /wP˛=.ºq[“^W©Yí‡!|Ubﬁä9K+@HSZ_÷é Ÿ §)M=kÄ`ç=£Gú4˛L˚ˆÌ›¯3Mö4)ÕY+‰-wêw=Z n+Bè*ø\E!x/èUx+Ê,≠ !Mi}Y;dCÄê&˙z÷ ¡
g“Ëë&‹≥gOéûö5"Pî@‹¡CQÖ-Û¬q[“îπ¬}ÿ<¡C¯Z¿*ºsñVÄê¶¥æ¨≤!@Hm=Î±&4zÃIÉk¸Ã¯3—:≥6¢à;xà¢ÃÂZG‹VÑ4Â™iè∂Kæ2∞
o≈ú• §)≠/kG Ål“DWœ&LpOù:’¨Òg4@0¯)w‡ßB∏R≈mEHÆ^R=¡C¯Í≈*ºsñVÄê¶¥æ¨≤!@HS|=ˇˆ€oˆ÷[oŸã/æhﬂ|ÛçwFÉ◊´WØ¯ï≥(ô@‹¡C…v$Ü«mEHC•˙æ	Çá5ÑUx+Ê,≠ !Mi}Y;dCÄê&ıÃ^"Ä¿Ô‚í\q[“$πµDTvÇáêXÖ∑bŒ“
“î÷óµ#Ä@6i≤QœÏ%“”iä—cŸÇ¬≥aﬁä9K+@HSZ_÷é Ÿ §…F=≥ó @HSL §)Fèe xœÜUx+Ê,≠ !Mi}Y;dCÄê&ıÃ^"Ä !M1mÄê¶=ñ]N‡ùwﬁ±…ì'€÷[om{Ìµó’™U´J!Çá´VÃYZBö“˙≤v»Ü !M6ÍôΩD Böb⁄ !M1zU,˚¡∏ê¢¢¢¬Z∂lY–⁄Éu‹~˚Ì÷•KóÇ÷QéÖÆ∏‚
2dà˝ÚÀ/∂ﬂ~˚Yè=™kí<º˛˙Î∂∆k∏∑ƒ5%’*.∂ü !M|÷l	“+ê§ê&©◊¥sÁŒ5}qx‡Å¶∑!±g$P Ó‡!¢≈ã€cè=fÌ€∑∑ïW^9Ù¢Ö.W”‚∂J˝¿¡sÊÃ±Õ7ﬂ‹^}ıUn∞k™Ñ øNä7›tìùyÊô˘.^∂˘?˙Ë#ªÛŒ;Ìû{Ó±O?˝‘V_}ı*√ö§áz®0¿vﬁyÁÿåìjäMÄê&6j6Ñ )HRHìƒk⁄_˝’ö7oÓÆüœ:Î¨∑$vÅ‰	ƒ<‰#§˚Ôø¸Â/6c∆[i•ïB/ZËr5m n´TÜ4
%Œ;Ô<k÷¨ô~¯·vˆŸg/iîÊ´á…É>h6¥À/ø‹˛¸Á?ªzY∫t©›q«v—EŸø˛ı/∑éﬁΩ{€ºyÛ\oú€nªÕN9ÂÎ’´óΩˆ⁄kv˝ı◊[ã-Ï—Gµ3Œ8√-£uwÌ⁄’VYe:t®}¸Ò«∂Ò∆õn®^|ÒE€aáñµÅ øˇ«?˛·∂±¡ÿ†AÉ\òsŒ9gŸøˇ˛˜øªuÏ≥œ>n;m¥ë+ˇ˛˚Ôø¬vUSX”™U+∑ºzE=ç=⁄ı‡˘Í´ØúG˜Ó›m‚ƒâ¶ˇˇ˙ÎØÌªÔæ≥gü}÷û{Ó9WWöÆªÓ:Wg2¸˛˚Ô]s√7∏ﬂ8–.ºB{˙ÈßÌ»#ètˇßÔv€mÁ÷˛˘Á€Zk≠Â÷‘kî˚¥„é;⁄í%KÏÊõoérµ¨ÅºÓøˇ~wº8Ó∏„Ï¥”NÀ{yü–±P«‚m∑›÷ı^¨_øæœ≈•l¨ªÓ∫VØ^=”üµk◊ˆ∏§≠\æá4Iπ¶UOô˛˝˚ªoæu≠´køŒù;ªÎ’~˝˙πˇ”óÊ˘‚ã/™Ω◊µ‹¸˘Û›uùÆ√∑ÿb”Õ—ˆ€o_Æ&‚∂ª`¡˜£†å	Å¥<˘‰ìˆÃ3œ∏˚3›øF5Ès“≥gOk–†Å=Ú»#6uÍT[¥hëuÏÿ—ı™”˝ÙUW]euÎ÷µ~¯¡}÷uM´{€˚Óªœˆ‹sO€{ÔΩ›˝ªÊ’Ô∆çÁ˛Æ{J}AÀ-∑∏˚p›G˜ïﬂ|Ûçª÷}z∞\>ΩpV¥ˇô	itSÆ£Bábß]vŸ≈¶MõÊV£ıp¿Æí;uÍd◊^{≠˚Ur„∆çm˜›wwç„ÿcèµIì&πä~¯·á›âC°ãN*˚ÓªØm≤…&Æän˙’h“‹x„çˆÂó_∫`‰Í´Øvé¬ÇC9ƒmS=vTÅ◊\sçù{ÓπÓÉ‡f^¡¡€oømõn∫È≤›≠¸{Ö$
∂‹rKwíS†F¸[Åç÷ßuÈ∆E'2M⁄˝üˇ…ÁëÆ†gÕªÔæÎñWÉér
ÍB°å>Ñ˙&e‘®Q.|ëøúTO⁄OöOf˝ÓÑNpæ|∞≠≥Œ:vÂïW∫ì˙{Ïaˇ¸Á?≠Q£FŒJ7ßGuî≥1bÑ=ı‘S.¸—{ î)ÓÒÆ('›4~˚Ì∑ÓÊë	År
®wúÿÕ6€Ã]ƒ¶i“qV∑>˚˙¨ÎX≈Ñ@!AH£†Fè∆Í©6µÍ™´≤:ñI°Äœ!MRÆiˇÛüˇ∏ÎÆ˜ﬂﬂ]€=ˇ¸ÛÆ'∑Æëu}.cM∫é’ﬂıÂ`u◊‚¡µ±ÆK;tË∞Ï∆Ì≠∑ﬁ≤7‹0÷®«&ts©/?˘‰BöXıŸX∫∑R®°/¿£iÇßP‘âAÁ›6m⁄ÿV[mÂ>œ∫∑<x∞È3≠{?Õ°„ÅÓ√uÃ”óè˙_«›áÎ8¢2*Ëù0aÇpu?¸¬/∏y‘Y"˜æR◊å\pÅ[ÓO˙SdåÑ4PÊÜ4:∏+\Q‡†`E7Ó'ü|≤i>ˇ¸sk◊Æùk ßûz™)mSE´UëªÓ∫´˝ˆ€oˆÊõo∫gﬂ‘hÙxãïû`R@¢u®ÎU∞Ωô3g∫o{’´E!ÅË}˙Ùq=@¥mı¿P8ë;Èdï˚{u	U (ETÉÃ˝∑IÌO∞o*á–Ÿ≥g€zÎ≠ówH£o5VÕ{ÔΩWíêFi©Bıä—§µ/÷I\˚≠êLŒ⁄è:uÍ∏oUt¢◊ˇÀFÜ
∂t∫˛˙ÎªpDÅåz⁄(º“˙ı!‹fõm‹@·Y€∂m]Ω®ÁíæÒ6lX-™˙Ei"ÂdeE“Å«¢ô–y@=hu≥•/v€m7;‚à#‹£&|iírM´œóÆ√>˚Ï3wÛ§œöÆKuç≠Îj˝NΩ–uÌ˝¯„èW{-Æ6}…©kD]WÎ¶LaèÆ_~˘e˜Ek\ìzå9“]ìÍzT˚®∞W!/i(eH£06∏G}Ë°á¨oﬂæÓûX˜√˙2N˜ﬂ~¯°ltèÆ˚@›s/\∏–}iü˚ÿí~ØÎ^›W˛¸ÛœÓã¯ø˛ıØÓÛ©û:π˜ï<Ó‰iÎ‘Õ˝<`≥fÕrΩ7Ço!‘(t¿=ÊòcÏïW^qjzºIˇVßì¡AdMõ6u!On◊® vY	‡ÿ±c›ÚÍÚ“K/-ß°Ù_€“£9Í£†aÌµ◊˛ùò ö˚{ù j
i¥o
9¥æ`_É@uU¢o€Ô∫Î.ª˚Óª]¬Ö>ÍiR™«ù¢úx‚â.1Õù‘õFﬂLJVÂŒ£6⁄/ùÉÆq¡ÔÉÒÖ4êî∫«©¨‹ﬁx„çÂ∂£o`ÓΩ˜ﬁﬂÖc≈4]w*Fèe£‡qß(5YWZÇêFÁd}¡°oÓtì•õ>}i£õ.¶lË"_?
ÓÙ„”î§kZ]cût“IÀ¯t7~¸¯e_§c“®˜zu◊‚∫Ó”#Óπ◊∫˙‚Taçn¬ÙHFìB]£Í
#‘.tCIHá>€àS†Tè;È^U_úÎX˜ù¡ÁæÚæÈûN°ÆÓıÿí&›?+–—=Î—Gm”ßOw_‚√ZÎ8Ï∞√lÃò1Óxë{_©mÀEı®ì∂ôôû4•jÄAÔí†[§í;uÅR#P˜y˝]ã*ˆßü~2ı¬Q⁄Øû4JËıwù¨ïÚ©ë(…Sê°otRQwiıÿ–:4p≠N
u‘8‘SÅ
i¥^=Æ£ÜS]àR9dQ2<ﬁ§Fß«ù‘ìG''ı¨Q®íªæöBöö¬ô‡ï‹•W·äB¨†˚úæ—Ö≤¬-=o,MöOœ iÖl
_Ùàîæ}—£k˙÷S¡å∫æ©Ã˙ª∫Á©óìÊïM∞/™Î¸1ÚgòKeU™œÎMØ ß∑nŸ≥Ë÷Ë∆KÁV}ìøÊök∫sê.‰Ùw&|H 5Ìøˇ˝o◊cM◊^ÍÕ¨Gœ5ﬁÑ}R8£û4AH\óWu-ÆÎoı§QØq}^’ì:∏π+≈#ÏU’πÆOu›©ÄF·åÇ'˝I?!î©XÅR
Jt¸
ûö–}¨ﬁí¨Œöt/®{s›WÎ…†Íuß˚iç)™{Fç—™{Hı∞”q@«ø
Lµ˛n›∫πıÎÀˇ‹˚J˝.X.üák≤,ïUu€M›¿¡¡¡\ΩbtÛØAÀ4©!®hLÖ(∫¡Q•]§∂(µSW+=û£¡~5∏ôûãSX£ @è8)È”„5ötQ∑N-ßÆZÍ¢•‡@°N–e3üêF)°?RÉSCVœ=üß!j‹*óˆ/}j‰˛ªr%Ø‡Vÿ£ı=gÇp&òøT¡É |…%ó8ô+QUWW=⁄î˚aRo],Oû<ŸçØ°πÍKP%wç§Å≠TØ™3=ˆ$k=^¶?ÉÅS5∏≤ˆWˇØ˙WF9ï * 2≤Æl“d£ûŸÀhÙEÅ‘˘I=gı¢ }I¿ÑÄèIπ¶’c˛¡É*≥æh”PÀQÍHç•k5Ω$‚è¸cµ◊‚AÔj4_|±˚bTÎØ<Æc©ÍK◊Œ∫Ó◊Õ£Ø˜≠wU©ˆõıfS†T¡CÂﬁ,Aè8ç)£/¨( ’cO∫∑÷˘Xè/ih}AØ>∫w‘òØ
vt_®cÅû|—ãz4v©é3Íî°1irÔ+uü,ß˚˜®ÇöRYe&§Q2ßÆí™HUÆzŒË-!¡#2z4IçAΩL4ÈFGèÃ®Áåz≤(»P(†IÅÄûG’h‘ﬂFï£Lp“‘ÔËML˙—§ëﬁ•ƒ]„•®*lQù SUøW@£∆´IÉ-©*\“•¬ m3iÙo=∆T]O¬§‡CeWpT9ú)uH£DÙ≤À.su°IÅôNÿ˙ˆDœ@=i4ü∆ˇQ†£I'fΩ›EÜzÌy–ΩUÉ;Î"@?:Åœ)kgç‡}¸Ò«ªëø5+G˝)!M6Ob>Ó5!çèµBôí †ã:ù≥uû—˘_/‡ÕOI®πÏï1I◊¥∫~’5±^»°I◊e
<4¶†æT‘óh∫’|v†∫kÒ §—ós˙íOìnÿÙíéRO∫—SØz˝©Îk}I Ñ@öJ<TÓI#CÖ)∫ó”§{t›*ç
ÓÕuØÄVÉÎ˜˙BCìË˙`ù√u|Qx´óÂﬁW*‘ñ”ÄﬂU›ÉRß•≤™Æ,©ÎIÏ®=áV›ÖóuR0S’Ôµ¨¶5÷X#tjùL’K§ÿI+∏»g˚≈l≥‘¡CXœÍW¥ºzÕ‰ÜO™W%¶•≤+µU1ı»≤Ÿ §…V}≥∑—	Ë¸™«)‘V„”ÈÇPﬂö3!‡´@íÆi´ª”>¨∂⁄jÀΩY≠™kÒ`ºF}—®ﬁ7∫¶ã+D’#NÍÖ›∫uk˜XE\€ıµ›QÆÙƒ<ËW=a4∂jÂ.z∑éï?w:god‘<∫«ÛÜ∆‹Â¢®…∏≠R“DQYY¡C¯ö∆*ºsñVÄê¶¥æ¨=›zÓ]oı—≥
i4∆î_@Ωq‘+: o¿√Óïz|´«∫sRœz&“.wêdœ∏≠ií‹Z"*;¡CxH¨¬[1giiJÎÀ⁄”-†±i“Ë—Ö4¡¯uÈﬁÎdÓ]ÜÕää
7 m!SˆÃ™ﬁ‡Y»˙Çe™{¨=ÿû∆^—`’˝˙ısè≠ÎÒwu€◊k‡ãŸüb Ï˚≤z¥AØ‡›v€mó{”jÂ÷<5ﬁdÿ8∂…6(ß@‹¡C9˜µÿm«mEHSlç•`yÇáïàUx+Ê,≠ !Mi}Y{∫Ùˆ?Ö4DXcúc§•{Øìπw
‘6ﬂ|Ûec≤
MlπÂñˆÿcèπ«›£ò™{ÅÉ∫Ÿ_{ÌµÆ[æ^Üê˚‚çÖ§∑Öc%FQé∞ÎPπ4é°∆p–∏+z·Ö∆n–+pôÃç]°7¡È-£z£(ià;xH≤g‹VÑ4In-ïù‡!<$V·≠ò≥¥Ñ4•ıeÌÈPH£ÄF?ÍM√‰è¿=˜‹„un÷¨ô{êBé ‘–ÿ&7‹pÉ{IÉú‘À	ñhåç®óEË≠]˜@ÎP ßPf◊]wuo—∫5àÌO<·^8†∑Ñh@KΩ¨AÀh0JΩæUÀ:‘ΩVZo¸‘1W·∆;Ï∞J„ßË-ûöG=cÆºÚJ˜≤Õ´'ËF_€◊£3¡€>À“(®R(©˝S°«äÙ
∆c˙ˇvåë°vƒÑ@‚íl∑!Mí[KDe'xâUx+Ê,≠ !Mi}Y{˙i¸¨cΩnUØO’õ;uÍ‰z§hRH£ﬁ0ßûz™{ª£ﬁ˛£óË≠ù
qÜÊ¬Ω≠Kø€dìM\ s˛˘Áª¿D!Mã-¨m€∂Ó≠=|∞ÎU£–Do“6’cG‚◊\sçù{Óπ.¸π˘Êõ›ˆı6í ØÅπ’õÄÇ2øˆ⁄kV∑n]˜∂œ†ÁNØ^Ω “®◊å¬Ö4
é∫uÎfßü~∫{{(!m ªqIñé€äê&…≠%¢≤<Ñáƒ*ºsñVÄê¶¥æ¨ì    IDAT=˝Ñ4~÷±ÇÖ+
;‘+Eo‚:˘‰ì]H£◊9o±≈ÓıŒ∫`VœΩñUcàh˛É:»ΩÛÕ7ﬂt„ô2ƒtﬁ÷#=zìó∆Ñ—§uhÏ/¡ˆfŒúiıÎ◊∑˝˜ﬂﬂÙ
W˝æOü>.¯—∂5^IÂ«§Ç◊EízΩ˚v€mg¡ò4WEc—î≥'çˆCm]c„4j‘»Ìì∆`‚ÕEøoˇÙ§ÒÛò@©J'wP∫=)˝ö„∂"§)}ùzøÇáUÑUx+Ê,≠ !Mi}Y{˙i¸¨„‡¢Y≥fπ)Aœ%l∞ÅÎÌr„ç7∫pEìzáËQ%≠e´8MÇêFΩt^h}˚Ï≥èÎçì;)º—X8zNΩm‘ÉFØå≠<Ui¶Lôb{Ìµó7!ÕÑ	‹>ËmfÕõ7wèıµk◊Œœä˜†TÑ4TEàU Ó‡!÷ùãxcq[“D\ÅI\¡C¯Z√*ºsñVÄê¶¥æ¨=˝Ñ4~÷qó.]Ï…'ü4ıJŸp√Ì°á≤cè=÷ıfYsÕ5mõm∂1ΩUIèÔh“¸ög˙ÙÈn¸˛™¿FΩ^P4h–¿=ﬁ¥˜ﬁ{€wﬂ}Á“#Q˙SÎËﬁΩªÎπ£ C€SèÖ4ªÏ≤ãO&KFÎ≠*§QO=N•7G·ènˆıxUπz“(î“´§uûPÿ§`FçÇ¶ÍihYà;xH≤o‹VÑ4In-ïù‡!<$V·≠ò≥¥Ñ4•ıeÌÈ §Ò≥é~¯a˜ˆ#=∫‘±c«eØGWH£êAè.©ÁÀ%ó\‚
÷¿¡ávòÎÒ¢Éºhåˆ€ø;Ó∏„Ïˆ€owè=i˘{ÔΩ◊=>•CAê!†;x`˜∂#®´ﬁ0'Nt„“¨(§Qoû±c«ö^>zÙhW÷Q£FπPD„Áhêa=ÓÁ€ù4˛Ã·√]#¨Òg¥å?Ss{'§©Ÿà9“%wêdΩ∏≠ií‹Z"*;¡CxH¨¬[1giiJÎÀ⁄”/@H„g+xQØÖ/Í—¢^4zcSvßπsÁ∫«ö h“¯4ËW‚ÍÕOˇÂ∂€nsøS–£0fùu÷YÆgÀ{ÔΩÁz‰®éùR@3h– ∑å¸’õ£4~ãzÏ(t—cRUı§	~Ø«°‘ãf˜›w7Ωﬁ]Ωr4±VH”Ø_?”‡¬z˝ı/º`GqDI^¡≠^3
©‘ªGÍ1§Çyùt∏∂NHŒâπ“#wêdπ∏≠ií‹Z"*;¡CxH¨¬[1giiJÎÀ⁄”/@H„w+p—‡ø’p´ﬂ+–©SßŒÔvDø”¥∆kÑﬁ…≠/ÙJ 8„¥i”‹„]„«èw=Ü4@∞zÙ0@p¯J!§	o≈úÈà;xH≤Z‹VÑ4In-ïù‡!<$V·≠ò≥¥Ñ4•ıeÌÈ §IgeıÊ&µgçá£«¡‘I2Â'@Hìüs'_ Ó‡!…bq[“$πµDTvÇáêXÖ∑bŒ“
“î÷óµß_Äê&˝uúˆ=‘ ¡{Fè8i¸çß£Ògö4iíˆ]/…˛“îÑïïz,w‡1EçEã€äê¶∆*IˇAê˛=çn+**¢[kB† Bö–XÅBöÉÙ&(˝®ÁIízühÄ`Ö3
iÙHì÷x<\xª&§)‹é%ì)…,}yJ›µkW”O©'BöR'`˝Ñ4˘W!M˛f,≠ !M¥û¨-{Ñ4Ÿ´Û™ˆ8âÌ@è5)†—cNX„œhÄ`∆ü)ÆM“Á«“…5§Y¥hë√‘‡ÒæMÑ4æ’ÂA < §Ò®2(J"íxsûHhœù¥v0a¬7@∞ﬁ •Ç5˛åf*^Äê¶xC÷Ä@Í’®œ„Ûœ?≈Íπz“$≤⁄(4d]Äê&Î-Ä˝/V i7Á≈Ó/ÀW-êîv†ÒgFèÌz–ËUﬁ
f–(®aäFÄê&G÷Ç@1z¸tü}ˆq´PHì§«PãŸÔ À“D©…∫@ ÅòibÇf3©H Õyj+¿ìKB;–†¿√á∑°Cá∫ÇO:È$7@p£Fç<QLG1i“QèÏE≤ Lû<ŸÌÑ˛û’ﬁ4Ñ4…n«î2*@Hì—äg∑#H¬Õyd;Àä™ΩÃô3«ıû1bÑ¶Gèn¸˝ù)ZBöh=Y˘
‰ˆ¢	ñÕjoBö|[Û#Ä “xP	!—æﬂú'7AÖ˜πhÄ`ïOÎµ⁄ ∏Cá\¢ˆEHS"XVã@HÅ‹^4¡"YÌMCH≤—0 ‡ì !çOµAYí(‡ÛÕy=ìZf_€ÅÇïMAçnR4˛LV«fà´m“ƒ%Õv¯Ω@–ãfùu÷±Ö∫Çøg±7!ü@ ÅÑ4	¨4äÏïÄØ7Á^!e†0æµ|À-∑∏Gú4˛ÃG·∆üaÄ‡“7FBö“≥™z—(ê÷qYS˜,ˆ¶!§·≥Ç $PÄê&ÅïFëΩÌÊ‹+ú∆ßv0˛|6lòi÷tÎ÷Õ4ıÍ’ÀPçîoW	i gœñ≥-ê€ãF„p≠∑ﬁz‰˚Ôøw§´gM÷z”“d˚3¡ﬁ#Ä@BiZq€ünŒΩA…`A|iz¨IΩgÙòì÷¯3 ∏vÌ⁄¨ïÚÏ2!My‹Ÿ*Ì⁄µ≥«‹ıú8p†Â~ıoß’´P««¨LÑ4Y©iˆR%@Hì™Ídg  ‡ÀÕyvùMÊ¯–Ù-≤ °?ıXìnTt”¬Ø !MºﬁlÅ@@èv:‘zˆÏÈBÍ‹œbÂﬂeEçê&+5Õ~"Ä@™iRUùÏL|∏9/√n≥…JÂlz§IﬂÎxÆû4m€∂uÕnªÌF=ïAÄê¶ËlÅ*¯,ö“—@ (@Hì¿J£»^	îÛÊ‹+àå¶\Ì@ﬂ>‹}{¨øüt“In¸çø¿TnÀ„ŒV®,¿gëêÜOx ∞h—"{ˇ˝˜≠¢¢¬~¸ÒG{˜›w]©^{ÌµﬂïÆeÀñÓˇ4h`ıÎ◊∑ùv⁄…∂ﬁzk[k≠µ<ÿì¯ä@Hü5[Jß@πnŒ”©È˜^ÂûcÊÕõg_|Ò≈≤sLÔ‡ú«9Fk¸¨Æ˝ X„œ0@py€7ÜÂıgÎ|	i¯4 Ä@ô¿Lû<Ÿ3ÔΩ˜^—•h‹∏±ltÅ›∫uÎ¢◊Á˚
i|Ø! Áª !çÔ5T\˘Jué—˘%r
)°kR€” òMö4qwË–ÅÇ¡åxn#eu(¿gëê¶¿¶√b PàÄæΩ=z¥1¯&3XO√-õŸ¶[∑∞’j◊±ç6Ÿ⁄˝w√≠öˇn3s?ò·˛Ô´œﬂ∑_ˇdüΩˇ∫}˝˘∂dÒOÀÊ’7¢m⁄¥qæ˙{'Bö4÷*˚ß !Mú⁄Òl´∫sLÌ5jYΩÕ6≤-∂›Ãj≠±ö’ˇ„∆Æ@õo≥ÈÔ
ˆÒ¨œ‹ˇÕ˚‰K[ÚÛ/ˆ—;ü⁄¸Oø≤≈?/)˙£`FÌNAç∆ù—¯3áÜ…n˝®JÅ üEB> ÉÄ.úoªÌ6{‚â'ñmmÌ∫ılª]∂Ü[6Ø2å…∑X
j>|ÎE˚‡Õ\hL
k:vÏX‘7ü˘ñ%é˘	i‚Pfi §IOÌ™◊ÃìO>π‹9f›÷∂{ooç∂Ÿ¥ 0&ﬂΩWx3g÷gˆ˙î7m¡7?,[¸∞√sÁıÊ¨n“ ¡#Gétœô3«ΩπIçﬁ‰ƒ‰è 7Ü˛‘%…∂ üEBölÿ{J,†pF7B¡ÿ2µj◊±mw9ÿÖ3n≤U…∂ÆêÊÌé≥w˛9nYuO◊EqZz÷“î¨˘∞‚å“$ø¢+üc‘cf«ΩõZãΩõ∫û3•ö‘≥Êı)oŸÙ)o-ÎaS›9F„œ6Ãç?£∞F„œhÄ`∆ü)UÌæ^n∑cI¢‡≥HHe{b] ?“8j‘(ªı÷[›ˇ(úi—ÊX€qÔ£≠÷Ík∆Ê¥‰_?⁄Ù)€Îì\÷tÌ⁄’}ÎôÙÅÜ	ibkFl(Eø˝ˆõ€õUW]’»t?
psó¢]NÂÆT>«(úŸ£ÌN∂{€V{ç⁄±ÌÛ‚ü€+„_∑ó«W,krœ1≥gœvÎ1_¨Òg4@pÌ⁄Òï16ålà√T"ªê
>ãÑ4©h»Ï>	h‡ÛŒ;oŸò3
fvo{r¨·LeÖ5ØåøÀ6ö‘õÊÍ´Ø^a˜tüL´*!çÔ5D˘|ò;wÆkÕ5◊tcV©wC“ÙË—√˝Noó”Ô6lË[Ò)œˇ*ücvo€“ˆ=jèX√ô ï°∞f‚£/€+„ˇ˚F¬‡3q‚D™◊å=ÊD@„oSÊ∆–ﬂ∫°dŸ‡≥HHì≠œﬁ"PbıûπÊök‹VÙ8”A/,ÈcM˘ÓéÉöÙÿı6˜√ôn—ﬁΩ{ª^5IúiíXkîπú/æ¯¢<ÿıòπË¢ã‹€ÂÇêFoÏ—Ô‘√Fø€sœ=ÀYT∂]ç@Ó9¶˛7≤£∫\“«öÚ≠=ıËq6ÔìØ‹¢]∫t±˙ıÎªêF3˘-¿ç°ﬂıCÈ≤#¿gëê&;≠ù=E†ƒ˙∂0XΩg⁄yvâ∑X¯ÍßN·z÷h“†èÁû{n‚"§)º˛Y2õ|Å4»ûzÍ)ÎﬁΩª-X∞¿Üj={ˆ¥u÷Y«n∫È&;‰êC¨ˇ˛∂’V•3+õ˙≈ÔuÓ9FΩg˛‹iﬂ‚WZ¢5<}ÔƒeΩjté—„tL~hÏ† Põ7oûﬂÖ•t§\ÄêÜê&ÂMú›C†Ù@è7ip`ç=s–q⁄ñ€ÔU˙πΩ {Ï˝‹X5z+«·√‘“Ÿ X<sÍAsÔΩ˜∫3¡„LzƒIè7i“„PÍE”©S'◊£Ü…ùc4ÿÆs“ÿ3Í=≥MÀ≠˝(‹
J1Îµ˜]ØΩ∫;âÁÔÅ#.†é˚Ï≥è©Wù˛ŒÑ Â §!§)_ÎcÀ§@ ˜‚YÕ1›Ø˜ÍÒ¶öàı¯”ÿ;/≤æõü∏ãhBööjóﬂ#{Å‹ﬁ4
m‘õF∫*î°ç-¶r@”•Øo™ILè?›1h4AMMP¸^ΩÍzıÍÂAΩâã	 '@HCHSæ÷«ñH∏@Ó≈≥∆ü9ÏîA∂N›˙â€+*¸–M=LÅMíæÌ$§I\S£¿‰ˆ¶Q`Lzºâ^4TPNrœ1Êîã⁄óup‡Buæˇz°ç:∆çSSË9Fè‚ ÓBk†ÊÂÙjÙÉ>ÿı†yÏ±«‹ œL P>BBöÚµ>∂å@¬ÇÒ‘É¶À%ñıÌM≈RÊ5-[∂tè>˘>“¯^CîœWÅ†7Õ}˜›ÁV/ö„è?û±h<´0ıh–c¥IhRΩ˝È¶~#m¡7?∏«ÎÙv¡0”ú9s\p0m⁄4˜v®FçÖYåyÚx‡Å¨sÁŒ.õ>}∫Î]«Ñ Â §!§)_ÎcÀ$X@op“[6í¯àSuÏøõg˜]’≈çQìÑÅ	i¸¢Ëe®‹õÜ^4e≠é*7úc4M“q™N3˜—'ΩUPo¨n
¬ΩÅL!çz“ËúKèË€™|ıò”ÏŸ≥› œ}˚ˆç~#¨Ú §!§…´¡03òª`‘@¡ö:ùwG¢∆†©©˛Ù»”C7û„Ç]¨)¨Òu"§Òµf(WÇﬁ4˙Ω}˚ˆÙ¢Ò®“ÇsLööÄWAçz‘hRoö`–Í‡˜UÖ3zu∑≥U@”ºysèj*ŸE	¨GéÈÆkt–∏4<VñÏz•ÙÈ §!§IGKf/àI‡ã/æpèh¨Ä÷Ì∫[ã÷«ƒ¥Â¯6Ûˆ?«Ÿ3£˛ÊﬁÙ§«!4hﬂ∆Ûÿ!MXÃä@%Å†7ÕË—£≠Cáº—…ìí{é9≤Î¡÷bÔ¶ûî,∫bº<æ¬∆›˚¸rÁc∆å±ô3g∫¿@o”»‘Àkœ=˜45µj’äÆ]”í%KLØ◊˛ÚÀ/]œô†óíé=zÙ Àhª`∑˝ §!§ÒØUñ±D∑ﬁz´Èá)º@◊Æ]M?Yô‘ÉF5[6›”Ô28µª=·˛!ˆŒ´„ÕÁÒiiR€¸Rπc;Ì¥ìw˚•6˝ËÊ◊«‡ää
ÔÃJ]†`ö˜jÍ^µù÷ÈæÎ≥ŸØ}‡Œ1zÙIΩ9“Ëmcö4NíB˝:¯ËZÅ÷£c˙©]ª∂øv›uW7çO„˝p=ûùgÌz<°™óµ≠i<2M:F˙6≈’÷VZ∫tÈRﬂvûÚîG¿◊jy4¬m5Æj∏“îvÆ†z
ÆIJ	ﬂqŸ±^?ˆDHSS-Ú{ü|it˘£}c|kÁìY÷Bö‹«úzÌö»79Öm?H¯öû∑∫WswÍ‘…ı†!§	´W¯|
fÙ8ì~6ﬁxc“Ë2˝øO◊„˘◊FñÆ«Û◊©~	⁄Z˛öqµ5Bö¸Î&µK‘∏_í!≥f•«õÙòì∫¢ßı1ß ÌÒ√7_∞±wˆw]“«éÎ˛Ùi"§Ò©6(KMAHìµ‡°&ó™~üE´‹sLZs™\◊ØOyÀªuú{§v»ê!ˆÏ≥œV˚∏ìz{¯$“∂ÀΩLnH„≥g÷Æ1ãiX£gÓ	
˝pÔW≥c‹VÑ45◊IfÊàªÒ%6kVO<ÒÑÈï€∑lf«tø>…UóWŸ5à‹gzyÚ"§…´*ôπÃY
%œ¢UpNm‘dS˜6ß¨Lwmsf∂ÏS›¿¡`¯à#é`Ãîå4å¨]cS≠X£GHìè^‹mçê&ü⁄I˘ºq7æ$sfÕÍ√wΩhé9kò5‹*;oóò˚¡{Ë¶^ˆ¶!§IÚ${eœbPh-g—jü}ˆq“ürQ€|õM•K‹rœ˙ÃÓ<⁄ı¶QèÕ`‚‹â´ HúµkÃb∞*Fèê&Ω∏€!M>µìÚy„n|IÊÃíUV{—Ì3ËMsÓπÁ⁄q«ÁM≥%§Ò¶*(HÅ,!X™ú%kV¡9&kΩhÇ z”0¿;Ï∞Â⁄D÷Lõ6Õ˙ÙÈ„’‡∂Ö∂oñ´Y K◊ò5k¨x¨äƒ/º_‹VÑ4·Î&ıs∆›¯íö%+ÔΩ˜û~  €r˚Ωí\mï=ËMS˘õŒÇV·BÑ4b≤™íd-x(4kVAOÕ¨ı¢	⁄HuΩir€êﬁF§¡nô≤!ê•kÃbk´‚ÒÔ∑!M¯∫I˝úq7æ$Éf≈J·åBöµÎ÷≥.?ê‰*+™Ïw\ﬁﬁ~¯næ›ˇ˝÷∏q„¢÷’¬Ñ4QI≤û8≤<cö%´‡≥Ók[Ô°›äaKÙ≤◊Ùnæ˘¡´sL¢A^¯¨\cFQMXßà_xø∏≠i¬◊MÍÁåªÒ%4+V◊\sçç5 v‹˚hks‰ŸIÆ≤¢ >u¬{e¸]vË°á⁄¿ÅãZWT“D%…z‚»RP¨gñ¨ÇsÃÓm[⁄ü;Ì[,]bó˙ﬁâˆ ¯◊¨c«é÷ªwÔƒÓèF +◊òQhaUú"~·˝‚∂"§	_7©ü3Ó∆ód–¨X›–;ùwám∏…VIÆ≤¢ æªyvÁÂ‹ ¬œ?ˇ|QÎäjaBö®$YOY
äıÃíU0`π◊uµı6\ßX∫ƒ.ˇ˝◊Ì⁄^∑zuéI,f

ûïkÃ(™
´‚ÒÔ∑!M¯∫I˝úq7æ$Éf¡JosRHìıGùÇvzÔ’]ÏÎœ?¶;zöCö7ﬂ|”&Núh6¥}˜›◊÷[oΩ$.(ªôe)x(∂¬≥b≈£NÀ∑y*ˆììûÂ≥pçUmaUú$~·˝‚∂"§	_7©ü3Ó∆ód–,Xi¸ïkØΩ÷∂›π≠t‹ÖIÆÆH >È±l˙îáÕó∑<•9§â§¬XâWY	¢@œäUpé…˙£NAõyt¯8õ˛¬[ﬁúc¢hÀ¨£0Å,\c&Û˚•∞*Nø~q[“ÑØõ‘œw„K2h¨Ù\¸‰…ìÌ¿é}mª]NruERˆﬂ|¡∆ﬁŸﬂZ∑nmG°‹!MπkÄÌÁ#êï‡!ìÍÊÕäUpé9ÆW;€¶Â÷Q–%zØOyÀªuú7ÁòDc&ºY∏∆å™ä∞*Nø~q[“ÑØõ‘œw„K2h¨ÇWog}<ö†ù.˘◊èvsøCº3Äê&…GêÏï=+¡C5õ´`Ã≥¨èG¥ô`\öÿÿ±c£hJ¨#°Y∏∆å™j∞*Nø~q[“ÑØõ‘œw„K2h¨ÇÖ^◊MNrUEZˆÎzµvÎ´®®àtΩÖ¨åê¶5ñ)ó@VÇá(|≥bÏÁÂ˜û[*÷qqß´º9«§4°;ëÖkÃ®™´‚$ÒÔ∑!M¯∫I˝úq7æ$É&’Í_ˇ˙ó=˜‹sÓE[E≥V5:ÍçNÍI√Ù_Åán<«Ê~8”Ün-[∂,+!MY˘Ÿ¯ˇ,X`]ªvµn›∫ôﬁ‘≥Ú +Wiìï‡!äÜëd´≈ã€¯Ò„m…í%v–AŸ∫ÎÆ[%…kØΩÊ⁄L˝?ndg>)
∂T¨„ÊãF⁄ºOæÚfÄ˙T†&p'ízçYj¨äS«/º_‹V©iŒ9Á˚˙ÎØÌæ˚Ó´ˆ¬±¶™π‡Çl‘®Qˆ∆o$Í#Kó.µ«{ÃΩ•∫ã§ ˚w„´…ﬁÁﬂ'’Jol:Ú»#Ìüˇ¸ß{lÁ‘SO≠2¨	.†nŸÃéÈ~ΩwUÒÎ/ã≠b ∂€æ±ï™π)¨™–Ø<˜ê-¯ÓK;¯ÿÓÌ!Mx∂á~ÿŒ:Î,õ={v¡«Œ1c∆∏ˆ:c∆k÷¨Y¯ç1Á¥i”lÕ5◊¥Ì∂€.ÔµÃù;◊ﬁyÁ;¿Û^6©4».ΩÙR˚Ì∑ﬂlÔΩ˜∂ã/æÿùw*á5I‚Æõ$[È≥™ˆ†œnÛÊÕ≠Gè÷Æ]ªﬂ]áÁòFM6µ.˝;ƒMj{Oø¬⁄w;“∂Ÿ±q®˘£òÈéA£mŒÏœJÚE@Æâã9ˇ¸Ûœˆ¯„è€±«k´¨≤J’YÂ:hü|Úâ0¿5jTÂ<IΩ∆,⁄
VåUı8CáµÖ∫„pu˜Ç¯Öoµq[•>§ô3géªX®Ó€Ωö™F7∫Ÿ(ÊF£¶mî‚˜è<ÚàùyÊôˆ—GYù:uBm"Ó∆™P!f“7w
§⁄∑o_p=áÿÃr≥$’J7RzΩ±n¨}ÙQ∑OUÖ5æá4_~˛ëÎúæÛ[i•ïBWﬂ?'ç±oæ¸‘˛‹˛ú–À‰Œ8u¬{e¸]ÆÁÄ~ 9˘ﬁìFª2*Êÿ©cÔ1«cØæ˙Í≤W8ó“\ÁãÕ7ﬂ‹¶OüÓn0Ûô~˝ıW∑åéª:odeROöoº—t1¯Ì∑ﬂ∫›Æ*¨Ò!x(Ù\QËrÖ∂¨
-ª⁄ÉÆπÜÊ¬UMUÖ5O<ÒÑsv‹´©’ÕœÅÈ?ú5«÷ﬂ®Æ≠ª˛⁄Ör‰Ω\Üß´Øæ⁄⁄¥iì˜Ú+Z@!MöØâã=Î|ı˛˚Ô€ƒâÛ∫Æ»∑ít≥¨gMù;wÆ2¨ÒÈS&]∫t±Iì&Ÿ›wﬂmü˛π]t—E˘Óv…Ê˜…™d;Y¿äu,÷ıå˛TõÎŸ≥gïaç/~Øø˛∫≠±∆÷§Iìºˆ∂–ÂÚ⁄»ˇfé€*U!Õ¸˘ÛM'°áz»Ü‚∆ç¯Âó_ñÖ4£GèvSßNµ^ΩzπÉÃ˙ÎØÔËı¯Gø~˝‹Ôt0“∑Å¸„›˙x‡˚¯„è›˙ÆºÚJ€zÎ≠M'Pı“—:ÓºÛN;¯‡É›Îä’∏û}ˆY˜{Ï±áª÷6;tX˛õ¢Í∂ß]mk„ç76›ÑΩ¯‚ã∂—FUπu'æ˛˙Î]YÙÀaáÊ ß’~˚ÌÁö›v€ÕÓ∏„€rÀ-Ì™´Ær˚µ√;∏∑”Ïøˇ˛Àµ—∏_!ê™ñ˘‡ÉÏ/˘ãª ÃÁÜΩòÌ'’*ÿÁö¬ö)S¶∏ˆº{€ìm∑É:D•ﬁ.Oﬁù=rÁ`[{Ω≠ÎÖ∑XÛ›≤'Óª∆~Z¥¿òÏyPG;¸ÑÛm¬√7€®õ/≤⁄k¨i›étÛi˙‚ìwÌÆk{⁄¨È/∏ﬂù÷Áfk—Íœvy˜ÉÏ£ŸØYÎCN¥Sœø—~\ÙΩçæÂbõ¸‘›∂Eìñn[7ﬂ∆‘£Ïπ1∑Ÿ»ÎŒµm[¥∂•Kˇcª¥9“8≤∞ÄÖê¶˙¶†YÙÌ‡ŸgüÌ.
ÙXX“®á ‡¡ÉM7g˙¶R«¢¶Mõ∫Í3¨^ã
[ıàƒ%ó\‚éüAHÛ÷[oŸl‡è¯œ˛cw›uóÎÌR’1M7!'ü|≤qƒÓ[QÔÆªÓ∫eÆ⁄˛-∑‹bó_~π}ı’WÓÿ¨øÎ—ø£è>⁄ûzÍ)k—¢ÖıÌ€◊4∞iU«ÿM6ŸƒÖπ«jmSÛj{:ıÔﬂ?∂–∏†hƒ’÷Ï≤À.nãÂœ©–sE°ÀJú‰ê&ÿÁ™¬]È¶T_®<ÛÃ3¶ÛËæGµ≤}é⁄£ ™o{‹~\¯ìΩ¯ÃT€ÔàΩÕñöÌq¿.∂˘ü6sÎªÔ¶ámè˝w±M’∑Î˙˝›Z¥⁄¡ÆªË∫ú}Èi∂˚~;[≈î6{Ê˚∂h·èˆƒ}¨Ì1˚YóÛè≥:k’±«Ôg;∂⁄ﬁÍ5‹∏⁄Âuéyj‘≥vÛÂw⁄ıÍ⁄	Á¥∑œÁÃ≥ìz∂/Ëz‰˘G_∂âèæ…æ\◊tLÆÍ˜∫˛’Ú◊D    IDATujU◊¨j;ó]vôΩÙ“KÓ|q·Ö∫7bÈ∫_◊Òπ«`›ËX≠k˚‹sKÂ„∑Œ%ßü~∫˚“J◊“:GËÔ•ò¥øÍM3r‰»e´◊ÁBÁ©†∑ÉO◊ò*ØŒß˙Ú‚”O?u˜€l≥M)h
ZßOVÌ@	R∞¶∂¶7µj™*¨Ò≈Ô–Cu◊è;Ôºs^"Ö.ó◊F˛7s‹Vei‘xÙMä˛;©k`n˜@‰6€l3L¥j’ }„⁄Ω{wóÑ´€π.¿ı∏ìö„è?ﬁ
'Óøˇ~€bã-lÊÃônæ]w›’˝No¥—¡ªq„∆¶Ω"R7∫)8‡Ä‹<Íe†-£«†ts1bƒ∑ZF˚£õê`“ÛŸ:9ì5©n{J:oæ˘f7´NJu¡_’vt£omup◊Ü!ù–t≥†}÷°†G˚{≈W8õ†å/ø¸≤Ìæ˚ÓnæyÛÊπõ'5¿RÙPT›¥®æÙîßÇ#bõn∫©+õ∂ØP©Oü>.‰
Ê;–Õ”)ßú‚n¨Ù;ùD∑›v[˜≠≠Í]øªÌ∂€‹˛uÏÿ—’´˛O'ﬂ∫uÎÜmb°ÊS—Å í∂IÌNÌÛÀ/ø¥÷áw+8§3Úo6e‹}vÓêÏ´/ÊÿµkW›;›&<r≥=˜ÿm÷µÔﬂmÉzõŸ{oæ‚Ê;Ô Gl—ÇoÏÚÓ⁄≈7>cç7≥^Ìõ⁄a«ùkªÔåjÓπ·∑éw¶Oq°Œ˘W>jm≤π>ß≠m∂’ˆvÿÒΩÌÌ◊&Ÿ›√Œ≥kGøe≥¶O±ëC{[Ô!⁄í≈?€_{bù{]g˚yZA’¶êÊ—ª˛j∫¯UXêıI=(Ç^#:ñÎb@«IÖÃ˜ﬁ{Ø;^*§—Á_ŒöÙô‘Á[ì∆>ZoΩı‹£E˙,)◊±ZWwp+’ìÊ…'ütü7]îÎÿÆ±O¢TuL€p√]êL
|T∂`“òL*„˘ÁüÔéÛßùvö˚S«u=¶£câ&}c¯„è?Vyå’Çˆ;˜X≠Guë≠I˚C:?}ˆŸgôn*:FÎ≥ˆ⁄k«“¸√vﬁyÁπÛÅ⁄†Æˆ‹sœﬂù+ﬁ}˜]Wø:gÎ∏w˚Ì∑ªs∑æhQ;‘1ﬂ|Ûç˚≤GÌ#8«⁄37l#XQH£0TüÉÚùt≥•ü|'.ZNÊ3©¨ZÆrYu∑˝ˆ€ªﬂµÌ∞O¡!ÕÕó›iOéz∆z>›6j∞°=˝‡sˆóìµ∆€oÈä9‰‹aÓﬂçofÁ¸ÂBWèó‹xûÕöÒæ›s˝vÎ”◊ŸÙóﬂ¥!ΩÜZèÀªZ„Ì∑≤+z_oáw†˚	µ¸Koÿﬂﬂenæ¿ˇºƒ.<˘r€uüñvÒΩmÂU™üiEÜ
iÓΩÒ!˜y)d“1S◊G>]´◊»äé…
A+ˇ^_BVu|WœÄ˙ıÎª}‘µ∑nÍt≠ß@_H«zÉO8·7ü~¿+Ù—MÍ€oøÌz‰øo∏·w-≠I◊°„∆çsÛÍ!ﬂv‘õ—]—pï√ö‹Ë|∞d◊„a⁄ïéÅù:ur≥ÍqEµGıê”˘˜ªÔæs«I´ª^≥ç®Êâ˚∆9™r«πûÖ5q∑µ	&ÿâ'û∏ÏöO_ﬁÈ∫Lè∂k“Ó∫&‘ÁSüSM∫ó◊}◊:Î¨≥‹}£:Jh˘`πR?w[K\HSπQœö5Àı^—çÄí]¥u`◊IAﬂÜÍ€;∏FË¿¢$Xãz∑(QP°1g≤Ë"L'
›@Ë"L7˙∫ê◊¡;ò ®Ò€n t@”8zm¢N.∫±–¢.‹ıÕÌ™´Æ∫l:y‘¥=›(Ï∏„éÆÎ•ˆ´™ÌËD¢ì€V[mÂ.⁄9‰w2“∑«zîEÅåñ_mµ’‹ ß*áN8:ÿ*ƒ—æÈõoM˙∆XìNZ. G9¥]u€’áGt›¸ËvO∫p÷ÖúˆO˚£–FÛÈÏˇ¯áªŸ˘√›EûnÚÙ·>º/ºÇÎ•˝’æ<˝Ù”Ó¨∏Ï’ªI^’ôN,πuPÏ¡ëêf≈Çø,˛Ÿ˙vﬁ’∫·z∂hz˝•ßmÀmw≤ohõ4j‚9Roõ˛ßÓiGüzâ5€e≥ïV≤'Óª÷~˛qÅ›ÂõÛ˛L€zª]l©-µØ>ˇÿ˜8ÿÖ4?˛›≤«ùæ˙‚cÎ›qªÚû◊lΩ∏ﬁ2;˜pkw‚ˆ“≥X≥]∞Ωˇ|Ç+ÉzÏ¸˚ﬂøı∏!Õˇ◊}“ËY~{ÙY◊	∂vÌ⁄.,÷ÖÆéï:&ÎGﬂf* ‘qW°∫.ö“ÍÇOèhu‘QÓˇòk>KÉI!ØNÓ:fTwL”±K«q-Øcç T´V≠eÎ–ª.>u√≠ãr›–´◊é¬¢‡f!G7È’c’SÁÜ‡X≠õ"ïIˇØ„~0“òÌµ◊^ÓWH£ûQ∫qSœ&]¸©-Ë¸ØÛEpÆ–:Íú§sΩ.buM†ˆ™e‘&’>Ú¨æ˙ÍÓ⁄BÁò?˝ÈO≈û>j\^€–yz—¢E5Œõƒ“®ùÆ[ä	iÜˆnõmπâuÚ°é!U™iŒrÜp~˚Ìﬂv∆aÁŸur!Õ˜é∑+Ó`+≠ºíMzÍ%˚Ó´Ô›:+á4U-”•wÿn˚Ìd≠ˇ¸ﬂﬁ@œ>6Ÿ˛1f≤πÎb∑æ|ß®BüÆâuª¢crp‹éŸ
«uLÆÍöU«m≠OÁõø˛ıØ.åR[“y$8/«`€’£\«ç1s∆g∏Î|Ÿ(‹…=~Î˜U=¶k◊†BæuYË¸
ktÃT∏Ø2Gy=¶L∫Ø“†∫èPΩ©ÁõæTUH£/|ıûnûÉÎ˙ ◊Î˙¢$ŒI7Œ˙Ç®–`3Œ≤˙∂≠∏€öÆtè¶ﬁ˙˙Ã™áñÆ«t-¶êF_öÈ:Pù‘Æt.÷=¨WµC}9¶Î¨‡æQ«Ω%XÆTΩﬂÇzÀTHSHc≠¸çéB=√¶Éô.ÜÉõÜ P
Ttc†Gõt!¶ F÷ZVa
&‘[FÈ∫Êπì⁄π!çñû
{UûÙËëì“çEuÉ]jù+⁄^ÓÔV¥5Ó‡Å†Aœ!›(l—…H'<ŸTû¥∫h’…I!ç∫ÌÍ¢)ÍêFePWTFÚ’áKΩfjÈD¨-útB–≈µ'POÕ£ﬁA
¨ÙMâÊ◊°ÍA'h’ßN¬¡„N¡[ı´˝“…Dº
zÇﬁEÖ¥ª Àƒ˝Aç¢ÃπÎwRà•∂¢)wl›åh}‹I·Küw∂ãÜ=mÎoºÈr≈øÈ“Œ∂˚˛«∫«ñ4ﬂÄnmÏ”ﬂZnû›˜;⁄Œ∏¯õÒ ◊'òÙÿîBöEøµÎ/>ﬁﬂÒ≤cF=n*OÍ13k∆vH«ÀÇ"¸˝∑Ûä
iìÊ˜≠Qüicu“UP≠c¨æ—‘7!˙¸´]Óÿ^ﬂˇΩcF'XÖ.:˘Vuºw
∂®„µN»¡Òæ™cöZ˜AH^y]$®g£B‚`“ç∫>z|I«†`ú‹«∞*cuCü{¨n≤6&M‡<Ó§/@46çŒ':«(ÄW•8wRÿØqÍK}i”†A∏Á
 :øÍïUÁı–
Bù˜ÉÎÖ∏wZQH£ãj]cÑ}!@P?
Né‘´W/Ô”âñ—≤ZG>ì™◊ó(z<%Aüu}vt/ˆq'ızish+◊sESÂêFø?≤Û!Æ'ÕÈáı∂´ÔªÃÍn∏Æ˝≤‰W;´›.§©xaÜ}ˆ·Áv¬9ˇ=œ<ˇƒãˆ˝7~“Tµ¸’˜_fówø⁄Œº¯d€¢…Ä}a¸T{j‘3EÖ4Q<Ó‰”5±ÆUu\≠ÓòÑ4¡ÔWt|◊¢zº)Ëµ(sœæk¸E›¿«`}∆u¸—ój¡ÙÓTHS˘:\7Ä⁄∂˛?8XaÑæ‹,dRõ/dY}Ÿ®cßz†ñ#§ë•Üy–gWCË|®ß
t<‘ó⁄:áuZ’ı∫ãs"§)\;Ó∂|÷ÔπÁûeOòËK=æÆ/KtO´˚=µ+µ=]#Í¸}”M7-ÎE£œxpﬂ®=œ]ÆpâpK∆}ÔW÷û4·H¬Õ|k†w¿ÉfıæPeﬂÚj–T•r
nÙ¯ìzkËÄ§ÁV’(ÙÌö∫~©¥“k]∏´◊ã∫∑Î¢MΩ1t3°0#Ë·¢n’
ˆ(}VRø¢¡.uπ¢ÌÈ‡å„ê€cßÚvÙxì÷£†E¢
0¥ø⁄ü §Q0¢2kˇıM±˛_6Í]¢}∫ÜïÚq'›¯¥m€÷mÛ¯√≤
U9‘+FI©∫∞jæ™Ç}8U:—Í[–`“â@…æ.Æ’ïU‹J˛søyÊçz‡—∏?®·>5œUS8ºíªÿÅÉÉû4=›ÔC“Ù“3£m£õ€¯ánZúÛù=p§mﬁ‰ø°Á◊ÛÊÿ‚˝d´’Z›ıêÈ{ÌX€∫ÈÆ∂Ú ´XÔéÕÏäª+l·˜_ŸWu∑~Cü∂yüΩoÉŒ>»Ö7´◊YÀÕ˜Èo∫øèæÂkπ◊°∂«˛ˇΩ ü2Ó^◊áÅÉkn+˘ÃÙ§—Õ£Bsr]WH£ì≤.XıYék∫P÷£F:èÖÍs¨yıÕâ>€˙<ÎB[!∫é_˙?›4VwL”Ö∫nt‹–≈zÂIëéÔ∫ –ÒQePê≠2)\–≤¡¿¡¡±∫™c¨n4sè’Yij
gÇGÉ‚gE7
ˇtCßIﬂ≤Í[9ùßÉsÖ •/Ç^§ö/∏ÅS[TØ/Nö‘NróÀÁ≥Q»ºqZRæöñ—µêzΩÈ⁄IW†§õ:}fÇπ£8∏™PÊNmóΩçIog:Ó¨£]HÑ2kÆ]gπêÊ’…”óÖ2⁄ØÍBöÍñWOöVÓj{¥´c—ÚûXpH’¿¡>]ˇ˚ﬂˇ˛?ˆŒ‹ ©}„è°®)Ñ$ï°2îOT ◊ ïJö4HÉJ—(“†ëi–djRR˘ÑJ>íBöMM¢Ô˝û¨ÛﬂmgÿgèÔﬁ˚Y◊µØ≥œﬁÔ∞ﬁ{≠˝æk›Î~Ó'›{≤õ∏π{∂{û§6fÂy¡¬˜q&oåÔ!UP]2πÛ%i‹8E%œT8N›…}ﬂ˜˛M€9%ç#'2ÍÁ°~Ôo˘¿ÑôﬂØhá†¯^sîáxÀQIÕs—ë4®“Øßˆ‹´Ùˆè◊Òx$1Ò?∂ó˙°ƒ+ÓôK8;„9|Êπº˜•s◊¬˝Åﬂ∞ÔºëÔ|˜ã4¶—Ók	C“pSgEå’Q/nﬁNYÇ¸ôÅ~T®Eê1«ÁÄòK|
Xe√<å…*í?VXôtpì¢c!…‚&Ö1/˚≥ç∆`Ñõ*
V“#ix §u>Lœ|»Ì”:ÒÛê4‘á∫B`¯{–°a¿ô01Òfeõ’-Æ’ﬂπ©ŒÁî4`àZ¢ S8§≠Ñ$1ÊaÏ∂„Øìß2©syV–<≥ »†Qn<L⁄ qi‚°.?VH!hXYÁ·*ë¬*\ıKÎ8—J¡Ó£ûj¢Ü¡ı~ZˆÌﬁ)O4πENZ%sß>óB“∏Ì®o”Œ#‰œ„«dPßª’ÉÉﬂ>óSRÊ¸/ëÖØìŸ„üñ!ØÆì'˛íg:’êÓ√HŒ\KØe‘¯Œ∫≠‰€-Î‰…÷Â•◊»w‰áõd·å“{‰;∫œÄ’§jΩGÉ6∂‹i˜Pß:‰>â¬Ω≈Mzπ˜pÂ~…Ωü(HÒU´V©É=∂ÂçíÔ uπØq/Â/b‚ÑpIº≈Rªßπæ¥HŒÈ√˝è:A1©ÁæÉÚés∞2À
*Jû¥Ó±˛$çõX@P!Ωe†iÔíHﬂ/9æo
n_ÂL,SpÛ|†Ú¨·˘R≠Z5}6ÍÏû<7 ‰Py∞¿¡ 9ˇ3&Ä@†O∏Á#«s˚E√ú>ûIﬂ‹©ë3ÆOÖ#∑?I3n¿d˘Â¿Øj
åpØeƒúÅíøpæàë4_~≤QF>9^NÍ•‰œSmÀ’≈
Jü—]ÉÚ§	W
n/çâùOXZ˜dí5cÏ‘ÓÔ¸6≥!ë˚8„|T5åÛX$eÇÁÓ¡å˘•‡ô¬≥áq7ô'§F“8Rû˘cqV˜#Q“õ0{¡8í55)<ô[¯í4ÿ+0óJmºŒBL4Kºé«£Åë◊˙Í6Ê»n«=Å~≈BsBD˘¸Y<„∑ç
ñ96˚2∂B\‡Êçé§q˚E”h˜µÑ!ihT2‹1ù$∂ç	>kn4∆°Ü¡|í¬çvù…;E»nÃéŸcê∆æHØ A∏q„á¢„0a‡…‡Ãc9$ÁO+‹)êÛÒq§ÑSjÁA.ÏR4"'«Eå´+
^<ò|W˘‡Úï/G™Û:tH><Ù®¨)81	√ì∆˝ÿàf%Bâ∂‡áKÒ¿HPi?⁄gy&V<88™&&[3`¿Ô§Î¥]ì&M¥ç¬')¨"}É;p‚ÜÈÂî3˛Á≈–ïfûÀ
I£.É™ú∆Ùk&ÎV/—˝õt*ïj∑î1}õ*Q‚ºj¸∑˚wı&“®˝≥:iˇL[Yπt∂Óœ>˛˚û‘o”_Æº˙&5ﬁøÁ{1Á+˝˚Ãc5‰◊É{O9ƒ√®w\iﬁu§îØ—4®k2í&mÿXŸdµíïJ¬ü¯ª{Í~ˇ»ZHo&œ˙#˜0W∏7ÛG)«Ωîå@‹œ∏Cª'|5µ{ÒÙ§ıL^x†„W‚Í¬˘¿≥z— Iƒ˝ØÉ¥Ó±ê=‹_‹ıq_Áﬁ5vÏX=Üï	™£≈—N<_∏ó@ösœHãòäÒ@;º§ÌP÷¢éb–«sá~ÁûLÈ£<€âë«üBÓ}òØ˙í4LD‹~¨‰Gö®âVëËf( \6àÃ¥“H;íÊí+.íG6	™*.ú…y–¸¯ÌO“•a˘yˇØö·i˚ÊÔ2$iwr4T¬◊ìœõjı*•´ƒAôÉrfDÔó§Për·≈π‰™kÛßÑOeˆ¬F˜xE~˙nè.8—◊B)^;B4–p'ÆŸ_Á∆¨¯ã˘é◊Ÿñq=+å|Ô¡ò◊s/‡~Óõ4Ñq$ﬂ˘ﬁø9üÒ‹qã·\ÿÛmGóÇ€W9„æÀ1&sû∑åÕQ-∞‡‡≤µ9%ìÂ¥∆Î≈G≥ƒ´h^gfœEõ¶ä‚Ã+}ç{ÛA∆Mò«C“ L`ºÑ∫Ü9< ˙œpÏ.x&3¶‚sBòyû˚ì4Ïëhû4ôÌ%QﬁY%É$Ô©&Ò|Oáı/|« [Z˚¶v<Œi√É#≥Ò⁄ô9_ZÁÅ|¬8-µ:≥Á¿≥«à»&ﬂœ‹wëº—ÒÉdêÎ-&e0˛å®ˇvLîx@@ƒ∏¥‚‘ó’[~¨∞¡ùÅ D€qlQnÜ*≠Åb∞›3íX[ßpÔÁ&
ùÜùL›l9rË793K…í5}?ÉcG…iröd=˚ˇ˚+ÁLoLÄœ8„ˇMπ”⁄ñ∞™”N?=√:dtç√:›°õƒ2ç∞´#j4»¬8˘úQ˝£Ò=˜î©Mdπ'A⁄rˇÒ7ÚNÔªÙÍùﬁ=-Ω˝ k‹Ω”ø.‘—›S”ª«¶v|éKHm8ç £—n¡ûÉ{!ôˆòÿ†@B…îö>öƒ(ÑÿAa’ú¡$ú{V0C)√dò—ÅY√v®ùíE´Ô3&Rì7◊—ƒ*ÿv«~Ó:˚M˚ˇ0Êp˜ÔG$˚9Ÿ¬q®èAöÓ+
].≈KüÎù1ˆ9ÎÏ¨)f∆¿oÉﬁçûÎ3&û∆ƒ©aï÷˝ù˚2cyÓµ˛coˇ{0«˜õL´]3CÙfv<üôvÜƒÑîqŸ§R€7÷cLGXπ∫9{&‘Óﬁò÷x=“$∂?^±∆*3mÌmÈkê5Êi˘òE?~[x:Î
∆<w!lH⁄ã œW∑p«6êØ. ˜ÅËû√æ˚˘FáDÎhbE˝JIâI¶cF£ÛÒ∞LmÇÊè3€•ˆMoﬂ,Z<¿Qç`éƒ#X≈∫Ô±*ŒD%äöd/«é¸.czTW	4¨¨ãWIöX„bÁè.∞P7°>ÅÿbıãÃ]®§xqßƒÇxHÎ9‚˚¨Hkõ‘PÙœ‘)§cÅU§Æ%Ω„2ÒC˝˚ÿ∞áÂÇ<ˇ\8ãEù2{N¬ù∫=ÿWj4ºKˆ¸∏O>~ÔSyq¡ÛíØ‡eô=î‹˚ãÌÙí*ªPs[I^º0∆t!93˜–H¥®∞äƒuEÎò±¿/≠æ≈Á.gf»|˜ã$n—∆ HöH∂fú;⁄ù/Œ‡9•∫…Äå4°fï<!EKVçÁÊ
K›∑~˘ÅÃõ‘K„∞Y	àu1í&÷-`Á‚ƒ1á≈ÛÖP7Tfê§lE}Ç¡$dæ//®–ºﬁr…B“∏gÃùjÀu7ˆz≥§Yøüæﬂ#€7+gù}ñ¶¯&*ò≤v≈zyÛ•Eûy∆s∂OxHÜ1fxêıÂÖoX¥”ïáÎby√/pÙ£çïë4Å∑M¬oÌŒœÄ&VÑ:Tä‹REÓz†{<7WXÍ˛ü7G g+^”∞TF±.âL“∑å8ûIH^#^Î∂åı˘1Lv°®ÑÔÚûøÆ‡7ƒ6¨l˘B√¯EÜÄºG≈à7MÆ\π‘W≤ü0#ikÈd!i‹3¶xŸbR∑ï-∏ÃN^y∆÷[m´H êcÃp·fXÖÜ§·8~—∆ Hö¿€&·∑åvÁãg@ì+‚éIOõ3W^i÷{f<7WXÍ>mHsŸ˚√7a1tGÖô§aÚF⁄nå⁄1ËMÕ„$&Ú1 T [¡y‚ﬁ;bÖˇ)ê*º(¯Ù5å+Hâ˘ˇ¬v|«~©ºPüëR”Hö¿z\≤ê4Œ†ûP'BûíΩÍD»S8LÉìÀxø˛dcÜ´ç´–ê4¸«/⁄XIx€$¸ñ—Ó|Òh≤`Â<í›óÊóªdRø˙ûÒ£·∑c$M<ﬂA¬Ww»r!d0OÁ2\A≤b¨Èà˜ﬁ1¸O!:Ê|<óxÔõ~Ø∂I-%mñ,YÙ;ºgH©NF.gÿK22†§!Eªë4Åµ{≤ê4†Aﬂ@µœæ4Åµj˙[9?ØxûÖ„öÏ¡#ê,cÃ‡˙ˇ=´–P4¸«/⁄XIx€$¸ñ—Ó|Òh≤`Ö˜
)ãóªW˛]Á—xn≤êÍæ˙ù…≤jÒÀr˜›wÀSO=“±¬µ≥ë4·B2~éC($Ñ!c0nÑÑA!√_&Ω¸u‰y9≤Ö1˛wadŸ≤e^HﬁÛ◊2U˘Êæ„<ü˛πêEè¥ò¯”‰Œù[SöWØ^]˝hHó^≤dI#iÏj…D“∏gL©*7KµFD(Ò6{{⁄rYµ¯SMCÈ%âá^‚]Q≤å1√—rÜUh(~Å„m¨å§	ºm~Àhwæx4Y∞rrÙdyBEÉö∆K2t#i‚˘íq›	WB)Û’W_ÈÑÙ–ê22.€ﬁ=˘ÚÂS»ﬁÛóÏvéÄqYı¯üÏ	Óo∆5I“b6LH{Ì»ô ï+K—¢EµéÏI&‚!TLì	+y:Ÿ[,‘)‘_MbÌü,cÃp¥öaäÜ_‡¯E+#ioõÑﬂ2⁄ù/ûM&¨\*ÓöÕ˙K¡ÎÀ∆s≥U˜Ôø˘\ÊåÓ‡π¥®F“’úûﬁ	‚2Ê”O?’î÷ºáî˘˘ÁüıÖøÀµ◊^´/2(A»†ê!LÇøê/ºÁ/ÊΩë.Ñ7Mô2E
( ©ë3Ó¸…D<Ñäy≤aÂ¬jõı¨/ÆÀ*|q∑ˇˆM;e“Äôû{∆ƒê	T·dcÜ⁄lÜUh~Å„m¨å§	ºm~Àhwæx4ô∞ö?æ<˝Ù”ry°õ‰æGFƒs≥UwàØe‹0í&®ÊÙ‹N(f cñ.]™·B€∑oWì]^®Pb“1!É_Ã˘ÁüØÑåS ƒÚ¢ ë√:˜‹sOQŒ¯◊)ŸàáP⁄$Ÿ∞rœàöd+45O>˘§@XY1íiåjkV°!h¯é_¥±2í&∂I¯-£›˘‚–d√ ≠tB“@÷$Kq*î	L$òàz•I„ïñÆÔøˇæ,Y≤D÷Ø_ØÈ´QÀ†êπ˘Êõıu›u◊…%ó\"yÚ‰Qb&ZÍò‡Æ(˝Ωíçx√dƒ 'õö∆T4°¸RwﬂdcÜ“íÜU(Ëâ~Å„m¨å§	ºm~Àhwæx4Ÿ∞JV5çS—<¸√¬ÀK≈H/µF‡u¡Ï’Ã≤eÀd›∫uJŒ@¿ê¶∫|˘ÚR§HıvÅòA)çê•¿k¸ñ…H<ãV2bÂû©…¶¶q*/>cÇÌø∂_Ë$€3ƒ´P–3í&3ËEªØIìô÷Im£›˘‚Œd√Í∑ﬂ~ºivÌ⁄%w‘n'%Ó∏/ûõ/†∫o˝Úô7©ó˙{xME√IP3zf£É ªÔæ+≥fÕíµk◊
ˇ*TH≥ ï*UJÆ∏‚
ı§H-Õµg."Ñä$#Ò,\…àïÔ3¶Œ√U•Dπb¡¬7˚≠]±^ﬁ|ië˛Ó1•˜íR3n@L–ä&€3îf4¨BAœHöÃ†Ìæf$MfZ'¡∑çvÁãg8ì+ÃL[µj%ge;Gö˜û•µ;ÚªLÏWO¯;d»AäÔµb$ç◊Z$ı˙‡9≥j’*ô6mö|¡≤ˇ~πÈ¶õ‘{Ç…x·¬Ö5Eu¢(f“jïd$ÇÌ°…ä’˛ÛÈ“•ãúù˝lÈ<º•˛M‘rÙQyæ„x·ØWü1âä}<\W2é1Ém√*X‰NÓg¯é_¥€fÈ    IDAT±2í&∂I¯-£›˘‚–d≈™sÁŒÍ£Añ'≤=%jY2„Ÿ∞fëî(QB`^,F“x±UN≠jTXì'O÷åMW^y•4h–@*U™§*öD
g ®5íïx»ó‘æOf¨˚Aiv›ÕÖÂÅNµÉÅ/.ˆyuÿ[≤È”-û~∆ƒê	Z…dc”úÜU0®˝ˇ>Ü_‡¯E+#ioõÑﬂ“uæÑø–0^`≤≈ë#IG˚Ôø'lÿ‰$a'H–/ΩÙ“0ˆò Höaâ#·=3uÍTô={∂¶—ÆZµ™4j‘H≥5%Ér∆SG<DÎD=Êˇ˚ﬂDΩ¥4ØÎ«L	≠ΩıŒ‚“†]ùÑ√‡√∑◊»¢iÔÈ3fÊÃôû}∆$qtA6œ|c%€x<Û•æáıµÃ#≠æf$MÊ€&a˜∞jÊõ6Z?‘Ã◊,r{8I:gh‘e¢‰π¨P‰NÂ#Ô˝·¡,ÿÀaN#i¢‹92q:ö±c« ÙÈ”5U6~N(h
,®iµì±xë§9~¸∏@<c‹Ï≈p≥d$i¯må©Y≥¶˛LFº6@.π‚¢Ñ˘…¸Ù›⁄˘%˘Âó_î∏Âæ@¯#}–ä!‡∞ÒxÊ˚B2é«3è“?˜∞æñy£’◊å§…|€ÿÜ@“#¸ÛœÀå3‘óÜ¥‹â@‘¸r`óL“B	ŒÑvyπI„Õ÷˘ÎØø‰–°C˙:Ì¥”î§…û=ªúq∆ﬁ¨pí÷Íœ?ˇT2†Cá˙[o÷¨Yí"·ÕÀÊ∑C)S∂å4ÔU/!àöâ˝g…ûüˆ»â'î®)V¨ò‹v€mrÎ≠∑ÍﬂK.πƒõbµ2C¿à*F“Dn;ô!ê8<ı‘S≤`¡ÇÑ0ÜòAAÉí∆À>4æΩ«Höƒ˘-ŸïDÅ-[∂(A≥xÒb)]∫¥˛M‘ÃZ—G7Ù3:íÊÊõoVÇ¢&ûçÑ1”sä‹˚ã‹x„çö—Ì√?îè?˛X~˙È'ı´∫˝ˆ€S˛?ÛÃ3C“é`ÜÄ!óIóÕfï6bè ad{˙˙ÎØUIsWÉÓq©®Ò%hÆæ˙jyÒ≈„"™ë4±ˇX‚T4ÔΩ˜û‘™UKé9¢Èœü|ÚIS”x§9˛˘gπ‡Ç$gŒúR≠Z5}∆@‘`$|Aûú©e‡’Äò¡(%ç{∆dÀñMvÏÿ!Ñ¥≠^ΩZ>˙Ë#˘Êõo$wÓ‹J‘*S¶å\{ÌµrˆŸâõÂ*pmKC¿0í#ií´ΩÌjÅ∞"‡K‘ƒcËìØM<44¢ë4aÌ v∞$B‡ªÔæîÄ/ø¸≤^5äÖˇ˚ﬂÚÊõoöö∆˝‡Ûœ?ó‚≈ã´‚Ñ¥ın1 %MºÖ>π'î4i=cP“8≤e◊Oütd~N`Åc≈0C 90í&9⁄ŸÆ“à5x:ê6¢ÊÆOhänØóÔø˘\ÊMÍ©4ÒF–I„ıﬁeıÛ*Œã¶Nù:ö•é…0JÖ\πrôö∆#çÜWP˘ÚÂÂé;ÓPﬂ ﬂ≈ àö∫≠™hänØRløÒ‚bIè†ÒΩDÎ◊ØWedƒ}5çS÷@ÿ‡[c°P^o}´ü!`°!`$Mh¯ŸﬁÜÄ!7Œ£ÜK‹qü¶ËˆjYµ¯eY˝Œd≠ﬁ›wﬂ≠$”πÁûÎ’Í¶Z/S“§›\Ñ.\X'9xZS‹1&Lò Õõ7ÊôﬁÁ˚Ôøóç7JÂ ï3ΩÔ·√áeÓ‹πrˇ˝˜õIq:Ë9©—ÛÊÕ+ªvÌ“øÑûòö&”›.";¯ì4Ó$æœò“U˛%Uïè»˘√qPRlØ\|2Ö:œÍh9zÙ®Ü>A÷8¬Ü{>5æ&√¸o°PÅ¢j€ÜÄ!_I_Ìeµ5<ç¿´Øæ*Cá’:z—ßÜ¶ˇº5RP—P{Ï1Mèè≈Hö¥[ç	wÅ‰ìO>ë`S?;ífÙË—“∂m€àw“Aìäós=Ú»#ô>)!1√]æ|πfï≤ÚO|U4]tëNû_yÂ≈ùL;05ç:NZ$UÛ}∆‡SsOÎ™û ¸Dx”Î„©ˇL®œ˙+‰d≥3ÊæD∫nÓkdÑ¬l•çô^{†„ZC¿#F“ÑL;î!`àö<¢LaÖöÇ™Ê∂ª“P®XBöPŒ¨}éVÅïs“àÊOÖA;©ª?I„˚]<]Sjue"÷´W/ÕÄ“Ø_?πÍ™´2º§©SßJó.]‘ª°fÕöÚË£è¶ê4Lt,®'.ø¸r=&Ü§B)®xﬁp√“µkWiÿ∞°l›∫U’8„«èWCŸNù:…ßü~*/ºÇf {„ç7§Mõ6j<À±!I Z⁄µkßF¥ªwÔ÷åA¯K¯™¥ñ,Y"}˚ˆU£–ªÓ∫K∫wÔÆaÉí=zhÓπÁΩ˛9sÊ»·√u5ùm˚ÙÈ£ôàﬁ}˜]ô4iíæÔﬂøø¥h—BØÅÛ‘®QC∆çw ∞88mGπÂñ[§wÔﬁ)Ô!mMM†C<Dz$áˆ∆†™)_∑TL≥?“Ùﬁ´R‘3·~∆‡[√Ωƒ)kxOÅ¨A]„|k,Öwàùœv7C¿#I„ëÜ∞jâÑ ﬂ3f»K/Ω§óASº‹ΩJÿDì¨ÅúÅò˘l≈kÍ=Ca2›†AÉ∏õƒ˛¯„èÚ˛˚ÔK÷¨Y•BÖ
öÖä	˛O<°Ø+V»¡Éuí	Iœ%≥$Õ“•KÂŒ;Ô‘ç5JQs°§ÅàÉÏ!åàP &Ä{ˆÏë◊^{MÍ÷≠+ï*URı	DÃÊÕõï<y˚Ì∑ï†·5j‘(%\ vÜ¢$ﬂWØ^]œâbá~È◊∫ukù¯s.
Áﬁ∞aCä-&olÛ¯„è´jÉm!&Nú(O?˝¥Ó◊æ}{i‹∏±n«Îﬁ{Ô’„≥ÇŒÒ0∏ÂZ\°nê&lã-“m≠úä \◊fêm_~˘•‚÷‹|A˘ı◊_ï0Û≈◊på.ë4‘∆ˇÉWM©*%§tïõ£J÷@Œ¨\¸©¨ZºVΩg"˝å¡∑Ê´ØæJ…Â|k
*§ø}î5ÑxBFõoMt˚≠ùÕ0Åp"`$M8—¥cÜ¿)@,ãè©0Ç¶h…™R‰ñ*M◊MX”∆OÀÜ5ãR»‘‘Â“K/çÀVbÇ9`¿ 5íÏŸ≥ßJ‡IaÄ¢‚Øø˛“Ô j‚πdñ§!<%Jàï…ì'K”¶MUIÛ√?HÌ⁄µUÉ‚dﬂæ}R¥hQπÊökÙ3B LP√∞-Ñ¶≤Ñp,W•a{Bâ‹˘÷≠[ß§DœﬁΩ{u‚ˆÑÕ|ˆŸgrﬁyÁ)©Ê
ì´ÎÆªNâî/(oä+&˘ÚÂ|(ò\°ÿ°ûê€∂m”cúq∆™⁄·˙8∆≤eÀ‰æ˚ÓKπ&TT®@ÛzÎ≠∑‰Ù”OèÁÊèX›è;&¥Ê¨®ï¶LôíB“˚°˝Nú8!U´VçXÏ¿#I„é‚ˇåÅ¨)QÆò/W4¢aPÑ3}∂bÉ¨]±>ÖúâÊ3∆◊∑ÜgF√¸˛!g\V(¬° oÃ∑&„>g[ÜÄ!‡5å§ÒZãX}ÅDÄÅ4ìﬂ§\]Œ\yÂ∫[Óí|ÖK»Âo˘™øﬂ∫NvnY+[◊(ê4ÆJÇÔL∞≤!W,L`¬NH°§§eb˛Ï≥œÍ‰ùÅ˘∞a√‘puFºÖq˘CîYíÂ…¨Y≥d”¶Mö•«)k iò∏@h¨ZµJ'/ˇ˚ﬂˇÙR˚Bv\˝ı)dáo=ú'ç˚åâ˚ºyÛt2œ†∏Ò-Ñ°ƒ©R•ä/êF˛d	m!D[πB”ÙÈ”%Gé⁄Gù'J¬õwr•ê/IC»·]à£ù;w™ R«J˙‡A„K“å9“ Ûç•¸6§≈}√˜sAûúrSŸ¢rUë+‰ kÛròt∑ŸÒ’NŸ∂Ò;˘¸ÉrpÔ/)€‚mƒ3&˜]Ó).Ö∑Û≠·…LTô2eÙæmÍ∫êªÄ¿0Å®!`$M‘†∂Ü dÉË˘ÛÁßx÷8T./tì\^&9;˚πíÁ≤ì
Ü‘»» ﬁ∂»—√ø…˜[?WR∆Ö3ÒÍÑ5≈´r∆ø∑0«SÖê&Î¨éBF o?Î¨≥TuÅ≤IºÀ‹3K“†r°_°ê»ì'èzπÆI≥}˚v}¡Ç_À°Cá§d…ír¡h»Ñ
d∏¢^AâDHLë"ETI°√áê"é¡ÑﬂHîúÖ$~2¥˚Bº¯ì4¯◊–NÑ•A‚©≤rÂJ)^º¯)$‡çë¿_¬±cÚ%i|çë!™ §»d∆¡ﬂkç§…£Xm1â¢2•Ãû1Ñ⁄¢∆qæhnˇ◊Âì+ØÀ'Ÿ≤ü-yØºH?NçºÅå°Ï⁄±Gé>*;6ÌîÌõN~ÊJjœ{êKµj’ä	!ÇJ–◊∑ÖclßÆÅ‘5ﬂöÃÙ(€÷0Åÿ `$Mlp∑≥Iè [“¸e4≠Ú«a
Ñç@F§UX≈Dâ 9Ô™ô¥Æ—WMCXì˝ú9sJñ,YFE√µgñ§¡_2ÖïwàπázH!Ñƒ`BB8$
J$¸g^˝uA9AX!_|ÒÖ˙êê	C^2˛` ÎåÉÒ*!Lâ¬$hÃò1ÍD¯·ıÍ’ì≤eÀ™W+◊˘ÛÁO5ÏO!˙'§ƒ$™Í	±C[Àñ-ïD¬_OîRL ˘K]]∏ì/IQ9ÅÑ±e{Iˇk$çwAÑ•Bö¢
ÃLÍjˇ+ Ï3ÜÁãox¢ˇÒ2z∆pﬂ·ﬁA·}ì&MbzJH,dÆS÷@÷‡e„|k lxFí¬;ﬁ	}Ôˆb´ô!`°!`$Mh¯ŸﬁÜÄ!ÌÄ®aPÕ{¬F(|1¡ ≈W‚˛)(dx1ÿdÏõA'UÚ‰!|’4æƒÊµâ¢¢	Ü§!â	j˙$à#1MÇh°/Q k»EXJ‘1ŒÏ∑[∑nÍÔÉ*íÜ0=HG1	Éîa^»TNBê>iÖ;QOàW á\]Y;v¨>”¶MSoÍÖr
ﬂ»+<U∏VÏ}√ùÿ\≈o≈J⁄I„›ﬁ.í∆˜
”z∆‡ó∂ˇ~}]x·Ö˙rœ|´∏ü˙åÅp≈ ∑@ÑtÏÿQ	õháÒºÄ»«ksÚoø˝VˇÁö Æ1òÁ/œV#kº˚{∞öÜ@r"`$Mr∂ª]µ!70·F˘0sÊL5˚LvSTß¶y˘Âó’óÜ¡5%ÇçÎîôU“∏˝>¨˝#-£LBù fR˚ûP'V—3c≤…˘ ^ì…LAÜÒgjÁ„ò|Ó&M‘Û‡@
ä3Íìôk‰∏â∏çë4ﬁmUTjyá™§	Ù
√E
±ò‡KéÚRƒïX™k≈¬∂3C¿F“x£¨ÜÄ!êˇ"€~ÔΩ˜‘Ô#ŸI5M¢©hË¡í4ˆ#2E¿Hö@ëä˛vıÎ◊W#pàh∫…ZÑã§°é¯ø†vsÂ—GU^Q¬S!s¨ÜÄ!`È!`$çıC¿4»≈‰ñÇ<€LQE√]Ÿ¡º∂n›∫	•¢1í∆”?«Ñ©úë4ﬁmJ|õoÇòÁ}§K8Iw,Ã«ﬂ}˜]≠:Ê‡ê7ì'O÷ê'¬ü¨ÜÄ!`F“X0Å∏D`˜Ó›j¬J¯Ô”3éÀ≤“NMCÊB¿!£ì/¶§	≤cÿn#`$M¿PE}CL∫1æ›¥iìfVãt	'IÉ~˘ÚÂïîA:bƒ%f ú¯Ãä!`ÜÄ!¶§	%€∆0bÇ¿¯Ò„3’*U™®/Yåí©`vI∆!≤sê±√*c∞åˇàÀzâÂ2Za¶Lzÿ˝Î_j|èÜ ^&ié?Æ©œ1∆àìtª§«∆Ä”J¸ `$çw€*[∂lÍŸD ˙h¯+Öì§UH˙ÍOéçŸ∏5ﬁÌoV3C¿0ºàÄë4^l´ì!`Ë ùî ¯—$ìi0RàôÙRìcÀãØÙB¿»|aâ√ n<Øí4òÄ“_|ÒEUvëˆõLM§∂MvØ§xËWæu4í∆õ-∆}írí&%‹$MÌ⁄µ’É∆yÍ∏ˇ	›˝Ï≥œ¬öÂâ¨s,d†<
6£€[oΩıèlq—¿›ŒaÜÄ!ê6F“XÔ0O"∞fÕ!ÆüÅ'ÔI-ú®Â«‘…?Ryﬁ˚ñbW^!7ºR≤üuñ\uÈ%˙’ıÚˇä/∑´üm˚Ò'9|Ïò|±uálˇi∑:z,e[T6x<`Ã…{Ø/í4_|ÒÖN∫ò–†`z‡Å‰·á6Ç∆´ù(ÉzI„ÕÜÉl ‹âÙ◊ºèF¡ﬂ´{˜ÓaÀ&5|¯pÈ‘©ì™Ï∏_`Ã}CaBû}
W:n» ÓC°ê4=Œü|Úâ˙VC¿0bèÄë4±o´Å!`¯!¿j*O&Îm⁄¥ëa√Ü•§$N$∞ dÈö?~ e]t~N©tÛçR¨@˛T…òÃ^ˇˆ]ªeı¶Õ≤j„f·Ω+L4hê&ïŸ„Fr{/ë4;wÓ‘â/&YyÚ‰ë-ZË§ÊÚÀ/7M$;Bèm$M¡·–Œ”’Ô£Q »π6i“DÕ}C-;vÏ–∫£†qdå?QÉ¢&ò¬≥ÒŸgüUBâÃQeü#i>˛¯c0`Ä>SÓøˇ~È›ª∑+VLOıÕ7ﬂ»„è?ÆF∆®T˚ÙÈ#•KóG“¨_ø^rÁŒ-≠Zµí'N()}Œ9Á»sœ=ß«π·Ü‰˘ÁüóJï*©“!f˛®
/^,ü˛yJx-ﬂ∑oﬂ^I)¬vI´ﬁºys5ºÁ?˝ÙìÙÍ’K&Nú®«≈[≠[∑n™e?∂Èﬂøø¸Ò«ß¸œu≤◊¿~:t–`(9fœû=e“§IRµjU:thT<çÇiG€«0Åå0í&#ÑÏ{C¿à:&Lê«{LrÂ %sÊÃ—’ΩD Í9ÛÙ”O°Mîgü%K‹(ïJ‹(Ú^1º!iñÆ]'À÷ÆKQÿ≈ÄﬂK /ê4ﬂˇΩfgy˚Ì∑U…≈§Éâ#
ö2e (Yc%~0í∆õmÁìzıÍ©∫0%Zƒ‰§}b$≥ÖÁ·Y®L/æ¯bô6mö™L!/∏gA\P…Ç¨†6ã"µh—¢≤gœ%=¿ñ˜¯jqÉt^∞`Å4H>˙Ë#Yæ|π CÆ<X	H∞Zπr•‹x„çrÀ-∑»∆çıÑ’nÿ∞!e1Â·√)ﬂS?àÓÎeÀñïeÀñ©œÁ‡Ÿ.¯ˆ‡ıU™T)›Ø`¡ÇJƒ†Ztˇ„KGùiÉ,Bëƒ5rèÊÛ[oΩUP<BD9≤ç:€Ω:≥ΩÃ∂7/ `$çZ¡Í`)0`l‘®ë†``%Õgúë±¢8c∆5ùu‰L≠2∑JÕR%%G∂≥£vçáéïy´÷»‹è>N!kP.±öÏ£·Xë4¨⁄2Ÿa–øb≈
5jﬁøø)RD˚d≈äuÂœ+ÒçÄë4ﬁl?zÑ™Ç˜—(—"i∏‘&®É!jÒAv?éÉoô˝-Z§˜-»^´WØV¬2BBcsî5uÎ÷Uﬂ3¬õ ùŸí∆ì|PâiH|Œáäp◊Æ]r’UWI◊Æ]•oﬂæzé®œŒyÁù'Y≥fM9˚Ú=Ü˜‘EJ•wﬁyG…¸Ü ï∏∑Ú!∏£FçRµ˚Ò˘ÙÈ”UI„˛Gua√ÿ`Ãò1™dt‰*!¬‰PAdA∞WÆ\YÊÕõ'5j‘àF7≤sÜÄ!Vå§	+úv0C¿$⁄H∑t2xd Ê“ îkr˚≤öŸ•Kóœôö•K  EïúÒø»öWóØêy+◊ËW®iÜ¢´¢±,—&iò,0iaeñ	ƒwﬂ}ßì\Kñ,©≤˘p˘Hƒ[;˜Iå§ÒfOp ºèFâ&I„àö‚≈ãÎ•9s·@Æ”.êÑ¯@Húta@Ñ.π–'åŒπáA^@∫†NÇ0A„[\∏ì˚R%+d§¥A√3öP)B©¶Nù˙è∞OWWæGÌÉu§“™U´4™uÎ÷≤m€∂î√è=Z@ië4ê6≤«T:ÑZQJî(Òè∫Ú<Î‹πs ⁄6ÜÄ!`x
#i<’VC yÄ†aunÌ⁄µRΩzu8p† ≥!Ã	ı_
·LùÓ©—∞¶Ãˆ"¬†^Zé¨ﬂÒùÓ †UM¨J§IöCáÈDÜp3≤h°òaïòDí{‰˘∑›võNRX%∂ÏM±Íë9Øë4ë¡5‘£¢®ò5kñ*yçmíÜkrÑÔ%júí&˛¸J“úyÊôöŸ…3xµ@ò†z)P†Äﬁ„ h)Çxoÿ∞°¯—†~a€∆çÀ÷≠[UIÉ
Öê%‘6|v…%ó®rµ
üAº@b£`¡ÿŸóLÒø?˙*i6m⁄§*¬¨h[<Ñ'QPÒ‡iqICòor&ÌMÑqMô2E9HmŒ∏`·¬Ö™∂ÂŸZ≠Zµ%ã!ÌÑQ°»+ÜÄ!`ƒF“ƒ[ãY}ÅCÄòxúH¨âo'¨„BV≈Å†a•”£ûiYΩ≤g[p∆ÚÚÍ≤Z?$¨¶∆B…níÜeVlô¥‡YÄ™	ıÃæ}˚Ùï%Kïı„Û¿_&!yÛÊUr∆Jb"`$ç7€ÇîpTmÑE£ƒÇ§Ò'jΩ^àéë#Gj»$
Ñ∫Û§ÅtÊ∆˝´_ø~J`LEπÇ°Jlãß°E|ÈâI√_
ƒaG®Z!´9.j¬–Pß@A“@A¶§E“pøE√Û_»"Ãç	√Ç»Å(1bÑÃû=[√Ä9/a•¥	ﬁtÏˇ¬/(aG÷,ÆôÎÉò¢æ(s∏Bπ∏6æ„8ê`à>e≈0ÅxC¿Höxk1´Ø!ê êÌÇ∏qVˆ‰1Qf†» ≤À.ã{Ç97+zp1ÓxOMπ≠»5ûo=Ryò6[ΩjP3Pè6Q
I√™,Ñ$YF∂√ƒè&ˆ!d¿3)!‘ã>JSÕxæõÜ\A#iBÜ0"Ä%Kjâ+Øº2"Á?h¨HÍ—±cG%)∏Ô@‘`,ú^ÅpFC∏§D	™»/êÑ6Q∏ocå Ñ¬Ò+T®êrxî)(ix˛÷©SGUÖ‹1ﬁÖ‡Å¿π¬ıx<´)ê(ê"ŒùQ∏ıBëÒF}	+%t’§ı>`wﬂ}∑f;ƒÃ)m§Éå·~M∏ﬂ∂ÖÈ1≤A°¬%´ì˚bâê™DXÏâ ¡NbûB¿HO5áU∆H|PŒ «f∞A√`y3+a§«˚†
Ç5äöA-ÙTxSFΩåß˛”fÀûüâ	QìI√D2"ÜÔ›ã’ﬁ_˝Ui‚/mÈ¬ä/ì^H‡Òu``œ
≥Ö3e‘#Ô{#iº◊¶Ñßö¬Ñú–√hïXí4é§@I(Q√>‹€ aR{V˛ı◊_zˇÀû={J∂%áezﬂ•á7Á#ºäcR¸=i∏˚◊ó-Jj«ƒ0√‚¥Œ«ıqÌ˛ﬂs}òüu÷Yj¨l≈0ÅxE¿Höxm9´∑!G0ÅÜúa5„B^5¨¬O:N§Ìâ†`%hüÈŸ>π¯ÇÛ„®µNVS·Óß
ÑM45∫È'¸%¸I?iXÒ'roVHŸÜ¥¨˚≤-rﬁªÉv1ê02H¸QfA˛1	r/ÒVí#iº◊ˆN—A™{àìhïXì4\'œ?.P“†xâwìrÓÕ¯»pÔÂz%Cc¥˙§ù«0#i¨Ü@ÿ8~¸∏*d au‘˝%˝ƒâ:xc0 `ú¡iÆ\π¬^áX–y–††ôÿÂ—òfo
_¢ÜˆÍ—£á#NµËÒùÚÖ’QW|I>£œ@¥∞z∫wÔ^U»@§‰ÃôSøsﬂ≥≤~§Û®`xA»@ÃûU¯9rh W&:¨ﬁí2õp:+ÜÄC¿HÔıó~‚∏q„¢VA/ê4ÑˇÚ,dÒ"QàŸ!g
*µ∂¥ÜÄ!ê(Iì(-i◊ax˚Xu‰k‘HŸÀï+'§e  d;ë
Y&»Jè!Niµ√ÓÉ?KáQ„’£Ü &Nµh€9ÂäW c8‰bíÖø®c Ç b»Ï¡ üæ¬˜|yÒ‚^2Ï«ˇ¶ê	¥Uí{;#iº◊˛.≥S†Ÿé¬u^ i∏_¢¬J¢û¯Ñ·F®Í?¸†œÓ˜êÔxÖ°ÇÑ¨O•m¢∑ß]ü!`Ñ#i¬á•…»di@1Ä^∞É''|àñ^)ò.[∂L”tBÃ8?å !g‚›s&5úËcLy°]À∏Ú†…®ﬂÚ‘}¬%jTÁ…ìG	ì@ã#` S\Ò%e¯•$æòT≤íNF≤ó@˘3Åû◊∂3“B¿HÔıº!ˆ1ä%T1Z≈+$◊À≥ÇÜ˛â°.ÑU2û+®n	âÊı—GÈˇ(#1ÊÖQ1˝¬ºfí°Gÿ5ÜÄë4÷Å‰ª§    IDAT! I√ $µÙïÅVâ4îdD˙‰ìOTq‡ï≤`¡%†PAÃ0–JDb∆·Õ
 7£iQÌN©UÊVØ4EÿÍ±tÌ:Ò˙|…û=õ<ı‘”r≈W|làˇê£‘>sÃ»88‡€ÜÜ@I„≠ÆÅä≈Ö»hNƒΩD“$3Q„z$ŸΩYCà4Y¶Ëåqnø˝ˆî¨RÒÓ€„≠_†’∆àåì∑lŸ¢Ÿ‰0àg¸L!™!€≈)Í∏.\8ÍG£ÉÃ?œb$M¨ê∑Û&< fÊÃô#É“é§a02`¿ ô?æf:Í›ª∑ÎRæ˘ÊMã˘Êõo™—nü>}§tÈ“‚H1Ñ¢ÀèÁ´oÑëÙÏŸS&Mö§i)á™§	ƒP”¶M•V≠Z2wÓ\ıá6lXäö'µÔ1o>|∏úõ¡—ê!C‰À/øî:ËÒ9gf‘â‘P–0–øı∫´•W£˚È“Nπñ·Øœìekø–4≠§ÊéT1í&R»⁄qF“x´/0)/U™î™/Q”D≥xç§·⁄]ùxÌØhbüﬁπ ÓP—71fBq√∏à… 6,Y1Ô" É1:øa≤ûÜZPWs¿◊“9°”ã˚I„≈V±:%&e îQ≈KªvÌd˘ÚÂ≤q„F!üpß6(YBi÷¨ô+nfƒf-ZT»l…3sÊL}O∂§5k÷®íÂ
ƒaéÕ`óÃ_|°‰Œ‰…ìıxê9LN`¢]Åt¡Ï÷!ˇÔAa¬J(ÑH£©Sß
~,è=ˆX¬µ]F‰¬ú¡(8£k≈H∏˘êëˆÙ‰ìOJç52⁄%®Ôç§	
6€)Iì	∞¢∞)·çm⁄¥ë&Mö§<Ø¢pZ=ÖIÍ≈sõJ≤5\;Èº!Ó|’5,z°“EY„B°¯Ö¶C¿à=(dòØpujjuNˆlR¯™|ÚØÎØëŸ≥…5O™≤Kª˙ï^ª˛$°≥yÎwrË˘ÔóõeÀ∂ùÚ˚·#)€¢≤!Dî˘Ô©IìH≠i◊‚Y`oa2x`%J€(Y≤§í4dÕ·s!ê++WÆTR‚Û<í◊_]Í÷≠´l4dœ<†€A“∏Ú +Ø»É>®ŒÁ<>*WÆ¨©ç˘Ü˝ßLô¢+Sæf´é§Ò˝uÁ¡g¶BÖ
+ˇ∆oËy'¡gÜt…(}í)’&≤M‘E<Ä5Ã…ˇGµz„f0}évÙ'˛ÜªInDÌx˛I„≠>—∫ukUÁç;VxÕ‚T<—N˝»5˙5ü}ˆô>kìµ8ﬂV„ùo„TƒŒ∑Üqì˘÷$k±Îˆ®fX8fﬁ‡Jﬁã.îª+ññ◊_ì*ìŸzCﬁ¨˝r≥,X∂RvÌŸü≤;á4P√D(F“$B+⁄5x2‡·1j‘(y‰ëGîq©ß	wzÙ—G5t	“Â1˘H˘ T ]Í’´ß≤_s`Ó‰ pjsê@˛Ö%¬ú i∆è/-Z¥¯«6é§Ò˝ﬁùá¡“B=≥fÕ“∏“¨Y≥*±T§HëêLê=ﬂà©Têá*§bW^!ÉZ>èóTùªèü"Îw|'?¸∞æ¬]å§	7¢v<æ˚Ó;yÍ©ßîxFÜÇ—JÏ@˝…ƒõåF<£YPe‡áÉc˚ˆÌ—<u@ÁbQÑ¬å¡'ôâmÊ»B°°¢qd„'∆K8VC Ú∞X…xÿyÀ†òπªRi%g
»±
lŸæS…öKW¶(lòß\èweçë4Î6v`C‡ˇp ñÅJ˜Ó›UæÀMÑ'î4ê4Ñ≠[∑N≥!πÌπ…¿£÷Xºx±ÜA¿∞m„∆çeÎ÷≠™pA1C»j>√Î∆)iKaBÇ◊D
iê!iFè-m€∂Mì§Ò˝ﬁﬂ†¢…ëJ¬&+IS≥fMU—l—XÆ/ê?i∫¸ó€øï¶FLMc$M“t•ò](3~Zõ7o÷PQ‘äVbÉ¿ˇ˛˜?%¸›≥)!+Œÿû∫x±¯5å î¨úL[N∑ØoÕÔøˇÆjî56¯÷ƒ¢_Yâé äÚ3f»K/Ω§ó
9”†V%©W≥¢úõ#{‘.ˇ∑Cáe÷ºe2cÓ“≤ÜEDî5ëP|G„¬å§â vé§G‡·√ÍÉG‰«⁄µke‚ƒâ)û4¯»‹yÁùr˘ÂóKø~˝‰πÁûSœöU´V©ÔUW]•˛/¨¸¢∆·;&§*Ö§·/bœ» ˆ„x‹8ëLœû=[√£OäICöÌd
wJVç˚1;5>DÑ∆Ö≥IN4ÌX©!¿ ;ƒYcP)/^‹ÄJbºN“–4(hX»·/äÀnÙˇñÖ/T¿ææ5ﬂˇΩíYŒ≥Üø¸ÕÃaI¸ì≤KOÕd!ÿyŒ‘ØYQZ4®Ur∆f»ö	3ÊÀÃyÀÙ+‘4Dƒcîë4I#≤KÙdB™T©íö˛÷©SG[ŒìÊÙ”OWu°MX_∑™U´¶ˇ3 √∆ºdP“*≈±\û7<8«é”¨Kúè2fÃçıGil∏ìπ"‹	Bıéwbµä)Æ%
ƒ®ûÔì€ä\ìó| 5:5@ºi¬Yå§	'öv,úM◊Æ]’¸öå{VíÅx iPç
fDM⁄}ïPr»∆D~¯°fÖÇºÅ–r°0FisŒ9Á$wß∑´7B@ ı¬ôûÏ¯PD√ö2[U¬†û>Y¯KÈ‹π≥™j‚©IO≠euç{ês≥‚ì#GéTØÖÔ:$Ÿ≥gˇá47ΩÔ“Ü}ê˛bl´G·Î>ê3ê4ùüS&v}4|é≥#5n§Ï˘˘ÅT	Á*Öë4—Ì¯p†÷£_˚fvÉX&$.Rôº¢{•¢~`(QBdõM¥[¿õÁãí‰ jP“ê›±vÌ⁄∫Xb%u≠ÒM·Õ{
dçÛÆ1ﬂÎ=Ü@Ê¿{∆£ûÈ‘¢^Ê•=ÜMòï¢™a√3?^äë4Ò“RVOC¿¨∞äP≥tIiYΩ≤gÍÌäÃXæB^]∂BÓæ˚n≈W1í&\Hv|8Hı{¸¯qUÙ°ÜsfÁ¯eç1B‹$6∞#zs+¸<XQ#‰"ŸÑlE›õÌÕZ≈I&ê(jPÑ·UCzn+i# ±ÂRxÙ—G™≤Òı≠Å∞¡#êpÛ≠±ûd§ç ˛3≠Zµ“ºg˙tl*w‹Ê˝åsÔØ˛\˙YΩjXP$ì`<¯‘IcøFC¿02âÄ3~°]K)ê˜‚LÓù8õÔ>¯≥¥2JvÑ‰Ö´I.$?éSÕ|Ú…'R¨X15Gı«Ñs%KñHõ6md€∂mÍyEhÂgú°~X˜ﬁ{Ø˙d·èE∏%˛T^+Ñ}∫œ{˜Ó’ïÙIì&ù¢ÚZù„±>Ù‘d$L/Ùü¥~¯AzˆÏÈâÀå'í∆ü®¡ {¯·û¿—Àïı≠Å®!äÑ
ê3NY√}ØP°B¶<ˆrCZ›bÇÄ?A3nPOÖ7e
aO≠ªâ+¢∆HöåZ’æ7bå Ÿ5k÷®4i.·∂⁄ªF¡ í&ŸCù\¥5^∂Ô⁄÷êßD#iXÒvÇ]ªv≈ÆÛ˙úÖLÆ\πR>AM”¢E9q‚Ñ\q≈2lÿ∞îlsÔøˇæÆ‹C‘∞
”±cGçÔ∆g/-‘T(T√¿"ïJ,˜L&a¨¢£†°jä‰ôÎ#„ãï"Äˇ«=˜‹£‰^zÍ+⁄Â»ë#jvÔÖo$ò9O:ﬁ£¶AUc%cP‘πﬁŒ∑Ü{ä:B°»iÉoçô3gåßmë¯¯4¯œåÿ9¶Ê¿¡"˛„Ó}Ú¯¿±ÍSä#iÇmi€œàê3Ì⁄µS#`<Hk“¸( üŒ) Ü*K‹ Ô©€ x‡Ï„.ëy+◊H8≥<1πgÖΩ~˝˙2`¿ π‡Ç<p•ô´ƒÃ¬Öe‹∏qÚ¡dnÁ(lÌÔ?√)ô®∏IÛ;Ôº#ï+W÷(&-dB¢ç!q05_¥hë``~«wËÑ¶Gèí%KÕ`«ˆNôÖK	Ë9sÊîªÓ∫K'≤™[˘P<˚Ï≥´OA&¸ò÷˚~éZéˆ∆Öœ	è£4k÷L˜A•T•J)WÆú†∆‚så‰Iqﬁ∂m[˘œ˛£äª	&h_Z∫t©8p@ﬂ?ÛÃ3rﬁyÁÈ1Ë?¸O∆îZ˚ˆÌìn›∫©ÍÈñ[n—∫-ZTﬁ}˜]ÌáêÅáˇQ|[‚ë§·ZQ$—F‘◊ÚÙ/_ﬂ6||}kå–_€+1 ƒÈ”O?UÂLº4Æ%»˛‘∏C?Ÿµgø.>ë˘…´≈HØ∂å’+È`EÇÊÌ∑ﬂVìZöÀ.ª,!º!‚πqQ†,ËpO©T‚∆xæî∞‘}ı∆Õ2`˙ù¨;ßˇPå˙Åæ9ÛƒOhJ˙x*¨“BPÙÍ’Kª‘®‡Æø˛zœ®7P“\x·Öß@ãöïLë"E§oﬂæ˙›Øø˛*•Jï“p&ﬂB»S˜Ó›5s
‰áÉbBMòÀÓ›ªcÆ§¡,ùîª◊\sç•ÿNÁGƒoå…˛‹πsiîÇv£GèV¢„h2Ê@¬,^ºXÎxx@÷†Ê¿àπwÔﬁ∫aèdÕ¢ÔFÇ!5}’D
,∂„∏ÙÓßè<ÚàfDÅ	à:¢áâ2Éh~;‹ñ-[&d$C!«Ç‡·ûI‘∞a√êûçÒJ“–¨Ñ:uÍ‘IU‡nV2á 5ÙKß¨Å¨¡ÀÜ–'G÷–Áπüòí9sÿ⁄÷ÒçÄÛ`ƒÉ&ﬁBú“Bﬁ7Ùâgœ!/#iºÿ*V'C@DΩ¨(ñ.]ZFç•>â`ﬁÔçÎRo'ªçk«CGéJ˝˛C¬ÊKC8´‰®3º˙L≠˚fb≤Kh"ìR˙L<(‡òt3a¬éjÅÇÅ0! L`P4qç®hJî(°+–‘∞ ‘B®(Pˇπ}„˝∑ûı?|¯∞íá¸ﬁ\ªëµÉœ*V¨® 
*‘4,lÎ˙	j+ûO´WØñ˝˚˜ßÑ;!ë'Ãír•|˘Ú⁄ó q9·˜çJb–˝÷4£⁄¢øÒÇ dÅıœF˙Í»ë#ï¨Iœ˚&–6ågíÜkD!ˆ +ØQhÉß±˝äP<H˙3F√¸èí∆◊∑Ü{ûeÃl€›ÛpE’òHç¢¶QáìãÄ®iXZ1í∆k-bı1Dt¢√ä6´ÿ≥gœ÷¡r8¢nË0a•Ã–+ÙÉ%»jÙÏØW‚§‚i]ÈÂôh•Á™œ†ÄÙé¨l~Å◊Iºî-[∂()É“äp»&ﬂî÷^øà%TÑ®‰ÕõW´Îà‘Ñüë˝â…4nî~‹óò¨≥$·]L ≠ƒ¥$
ºà\·s˙äBë(sÊÃQb5$™˙â€ñI-·#ICŒ–7 |PÊ∏ÇÍ≈ü§Åî¡âÁ≈ë4πsÁV%éA·Å√˘»<éÔ$¯5¸ñÕO%¥ûâH„ÖßaÁ3ånø˝v5WáúåŒ/ΩÙí≤8?¸∞≤X0C°Ÿﬁª√Crw≈“·9∞áé2cÓR>q∂éIßOü.ó^z©áj'b$çßö√*cúúaƒ˘˙ÎØk,?ó&ØıFœ¿«UùP“X9â@˜ÒSd˝éÔ‘S%Ü¡üe›∫u:©cEúI[j>3d‡A5∆Dﬂ•ıˆù8zoÆï
ÄxÕ9‹∏qcm+ﬂUbVìôîPòd„'¬$ïÌÑèÚÜ0®¨Y≥zπ©¨n>8%Õoº°§e⁄¥i:XmŸ≤•™¶0X§@“ñÑí¶xÒ‚:yÂwÏO“0Q"t	"í√i°xÃˇÜîºqJ2A±ZÎî<ÓŒÑVAÍ@±?}ì˜+WÆLŸ?ö$·9¨É!Ooë ¬Åw<\}}kË˜(
}}kxÓÖ”∑∆HöÃ˜#i2èYz{8öÍJi™ÌD-]åëÆcW∆∞^*F“x©5¨.Ü¿ﬂa‰ﬂíëö3®µ0'otå”xpªÚ
‘Ú¡∞UÍÀo∂I∂≥ŒíB˘.€13{†cóäm: ¬É%Á9Ádj˜¥HGŒ†,A!ÉW·(do-ÑIê∫íÊè?˛PøV‘„Ö†$5}/)Æ„‘D*˝ıóN∆Ò◊Ò/(§ò@õ¸?˛Zú0$Rêolﬂ}˜ù™P¬‡√ÛE
ô;ÔºS˙˜Ô/uÍ‘QB'5íü∂É»C5á⁄ R≈ÊƒÇCvCfD“8/!<kPmQ'PÓ'Ñnˇp†û$8Qéﬁê˙1∏ˇ˘˙÷8Âæ5êÿÙÕp˘÷8í∆àáå€”∞ £Ãn·ÊÙ÷ƒAqô…)–k∆H∏vÛÓöö€kaOF“⁄ä∂ù!‡íY-⁄6m⁄Ë‰«ä7àIÛ`ü˛ÚX£˙r”’Öbv°«ˇ¸K ∑jI3c˘
yuŸ
ïÛJçúaUú¨?òèB‘∏påÇ	Øau˛µ◊^S3—&MöË§Ãm3P2qbTBeÀñ’Å:ôf‚¡É&ógõ&0TY;™
D)*NàôÍ’´k»Ú?<h“"iP†ÊÄDÅåA]EF<
*3»ûmddBNœ˜.º…)i|ˇG•ÈÉ Œ∑nxË∏˝√—4âB“8¢É[Ó√Ñ@·%d%|–«Ò©ÒÖ‚¬ÛÖ‚¿≥.ﬂ#o/√*p¨Ÿí&û‹_5Ã…áÀVJøìuqú∞ßÙBÚ¡0\€I.$Ì8Ü@ e)´Ü<‰	w ì'Oéüá`’äïR&ÌGéÒƒEê]Ñ(U≠$*îÀtù˛ÛÈg“˛π≤ÔÁ_§y≠ÍÚƒCç‰Éœ÷I≥æœË±ñé&/øLFœySÜLù!ÁdÀ&/tÌ UJﬂ*(]6JÆª2ø|y™‰>?ßLÏ˝Ñ‹RÙZY±vùº≥zç:rDfø˚û¥´WW:7¨/geÕ"˛ıóåsæÙõäolèŒRÒñì!I;~‹%]Üèëï_¨◊˙Ã}ˇC˘`¬®L+iIC®
dˆƒ#ªg5ù	ì:B
(†Í¸ñvÌ⁄•ÌÀvxQbê±≈'” «hÍÑ˙/)õ≈®!Ï¥!!¿oíP5ETZüßw2&≤NÃ˛˛««1“´o"ë4\'·9êeF‘ÑÙì»pg∆(Œdòg∏”Ô}MÜ	ãÚ;„˜¡∂ÑÚlÑ–Ò-F<d} ÜU‡X≤•√≥x±´e‹¿.ÅÏí€¥Ó1D>[ˇu b£. H/¥Ç’¡¯€†ì¯{V-…“Ä˜I2™h∏B]¡ àÑç
+Ñ‚<zùLì4{˛,75h*o óÊ…-=5HÓ©xá‘ª≥Ç4Î;HV©,’nøMûô<]ñ≠˘ØL~™áÏ⁄∑_ËŸW^–GJ]_LÓj◊YéˇCf|J÷}˝çt>F>ò8Z÷lÿ$≠<ßÑŒ≠≈äË˚Úˇ*!]l √^ù-≥ﬂ].S˚ˆñ˝ø¸"u∫Ù‘:‹P∏†T}¥´‘)_NÍî/+É_yU	£`Iö…ãñ™)·Ñ%@¨aö3gNM≈ãwÖØ˘5ì⁄ñUõ\πrÈ
$©úQ⁄ƒãçÎì¨Úc`:a¬È–°Éf•≤bÒÉ ‰1jà„pzãƒ_¢‘SO=ÀÍ$Ùπ	3CÌ2BA‹0n!t¬Ü∞?˛∫æ≈ˆ(÷fÕö%µk◊÷PYûìÆÒxw1¨«*ê-Q:3.;∞ãî(v“è, ⁄ı_KõCR¨&ºpÕF“x°¨ÜÄàö+ÍÑÍÄt∂x$Sa–¬ÄÖÃ!.0ÉÉØx]ÑB“†Z)›¨≠å|º£¸˚Ê‚⁄¥ggÕ*9≤ù-m=/è‹_GU4ZwPÇÊö¸'3≠ÃZ≤LÊ,˝èLÌ◊[*¥n/zuì¢hJ€ÜΩ˙I£jïÂØ'‰ï˘ãdŒ‡æÍ_Ù’éÔ§È”eÒ»Á•÷c›ÂÒ&H˘◊ÔFÕz]~˘˝ê4πª™‘Ì⁄S>~ÂEı√˘Â˜ﬂ•lãva!i÷Æ]´T_íÜïD_“ÚÜ∂E"Ngb˘1(ıJ[gÊ∑1≈•U"˙—d€÷H»[»Y‘òà{%k!™ºnV≠Z•ìÈD)d^k⁄Ù§È'
?¬ü¨DÁ[„
Eg,„Î[√sè±ŒÛœ?ØôQP7j‘Hüá#o#√*p¨2⁄Cw≤k&õä∆·‚‘4å„òè≈∫IÎ∞Û#@ò!N‹ 1lå√‘p4 Éî.ï/f$¬˘ÛÁ˜I≥`¡%”Çw"úBÜB∏“îæΩ‘á¶ı¿!“˙ﬁ⁄ ÑyÔ¢ëœ…πŸ≥ÎvÛ?X)ìÊ.îW<)w∂ÌtägL◊cîÿπËÇdœ¡É“˙ûZ∫ÑPÂG:ÀáìFKÉ}e”ˆß4S≠;nóŒçÎÀ/åìŸÉ˚ Èßù¶·T¡ÓIÉÁ‰M<3æÄIéªÄ√àé§!Tì˜âT|âÃŸQnXâ,Œ∑∆7Íõoæ—Á™Qî5Ñ8AÊ†úÊs¸ôh¸Ãåxº}´¿± hK2o≤ôl*áã◊‘4F“d‘cÌ{C 
⁄SÆ\9•!Æ9ô2:±Ú4x`yÊôgtµ	”XB^ iºVB1˛ù‰}§‡Âó ˆw…ÀÛﬁñı[∑ÀkœˆìGû*è÷ªG
\ñWâíÈ˝˚»Uó]öB“†íqJﬂÔ w™ñπMW£ó¨Z£* 7;ê∆}˙…€/<'’⁄wïq›ª»çõ˜”n9tÙ®d9„L©◊˝I˘h“UÙ˝„)”¨≠,7<hO„`2∞:MV'åÿXI$§…◊8ÿkmL}å§	5€«âL“Ä2J?Ä  ¢º¯|ıNooMXÑÚM·Õ{
djR»2†.‹≠[7©T©íLö4IâÀÓîq[Iì1FÅlÅ—;6y/∫Pﬁö0(ê]rõ⁄-∫ÀÆ=˚’uw,ãë4±DﬂŒm¸ç iM@ë
ïásñ,Yí$øNé=h– ≈¿´ äPHöM;æïä≠; ≤q√U1ÛÚ¸E2Ô˝ÂıÁ˙K€AœKŸ‚7JÕ; H´Cî¨y‚°Ür‡óﬂ§~è'•[ìÜRµÙmÍIS©‰Õ™ÇY˚’◊r_∑>≤zÚ8Y∑e´Ù˝íí;˘Û^"ÜåêÀ/ #}[7OQÓ<Ûhk9v¸∏‘{‚I©]æ¨4≠QU√õz∑h"µˇ]V¶-zWÜMüT∏SF)∏}…ö¥Rp«sá7í&û[œÍnà™g îQI„⁄óP'ß⁄0¢&˙ΩûênRx˚˙÷Íƒm,Xë…%5YÕå§	¨çå§	ßå∂"Ùn∆åRøfEÈ‘¢^Fõ'Ï˜√&ÃíôÛñi÷A‘m±,F“ƒ};∑!7H_1Ü∞`≈+q˙—h†:uÍ»[oΩ•+H¨ˆyï†∑“P Ô≈ÚBªñôÇôqØœ’,K¬ùf=Û¥63ﬂY¶ôõ˙¥|HÓ´T^˜Ó'ü˝çn◊πQ=È¯¿˝ÚÁü)IsÌïW»ºÈw˚tSÚÜê(ºf0&sTÖ[J»ònè…yÁ‰PØôGìÂü¨’}‹UI…ºpæ¸fõ”ÍåqpZ$ç;ÆK…Möj|(ê‘b$ú(≈HöDiIªédE H⁄÷5®V1x˜œ:î¨Ì≠ÎÜ®AYYÛÓªÔ ö5k‘lüœ	ë ñ-õ.Taû?oﬁ<S“–0F“ R õ8√‡7«îK/>ÈçîåÂ«›˚§NÀJûBf«≤IKÙÌ‹ÜÄàf1Ç§Åú Ò≈_ú4∏`\ºxqΩv8zΩ Q¶Ã–+®™˛q¸∏¶≈Œ~ˆŸßÏœÁY}Tø>,YœÃ¢i¥)Œ3øö,gû)gûqÜæ(o,_°dL”ö’‰»±cjÏ_=™∆¡˛ﬂa:|Ë»Q9/«Iú`Jçû˝u7‚Ô”+á“î‹<¸©IìH≠i◊L ô$íÂı´˚ò)rØ&4ı‡¡ÉÚ⁄kØ…É>(è?˛∏<˜‹s˙=øÌ)S¶§¯û|ˇ˝˜“´W/=∆-∑‹¢ÊµÑuÏ€∑Oâyî£æüìjªKó.2~¸x5œü>}∫.\§ıy∏Z+YH» Æï±!OLBå®	W/ ¯8,HÕù;W	ô®ˇ/ﬁÛÖ(~ﬂ~˚≠
Úd%må§	ΩwX®”©z%‰…Hö–˚∂¡	“0vÍ‘Iµƒ@&S®”Ãô3URX´V-U”ƒC!fóJ5—*ê,Öj7êçs¶ ˘Áûs igΩª\˝n:4∏7Z’I9O˝˛C‘Ïê∞¶d,F“$c´'ˆ5œô3G0≥áp)[∂¨æ«+¨oﬂæ:q3få,òªsÔ^∏p°í:ê2lá*¥b≈äJ‹x„çJ»p¨_|Q6n‹(U´V’œ!»ä÷æ}{Ÿ∫u´å7Nø·ÖdÈ“•Íë¿ñÁdjüáKëó,$Ω÷ü®AQc%:>\ì$êråÁ¶o·3^®Ogª0í&˝∂1í&ÙæÀ‹cË–°IÍ‰êÏ;¸eY∏|ïX{‘ú    IDAT<ˆÿc˙äU1í&V»€yÅø ÙÉ.∏¯¶)Ntêúô!+∞ºèáBå*ﬁÓ©!ïJ‹’*o‹∂C
_ëO≤úyRA„ ûÉ?À—c«‰äK¢GπsØﬁ∏YLü#w‹qá¶M∆b$M2∂zb_3$DÃÚÂÀUÅ∑~˝z%”˘€Æ];)R§à∆Î>|XÆø˛z%hP»PPÀ@»å=ZM¬∑lŸ"Áùwûznê‚ïÌxA∫˛à∫ÆrÂ “ªwo%|~¯·5ì/T®êNV/ΩÙRiﬁºy™üá´íâ§3T¨(i¿ó(⁄ÃJ‰¿4òWF$ﬁ ≥gœñ6m⁄IìA≥Izøu„⁄g{¥ï;nÛ^“é–Ø0sGX∞l•Ù19Ê„Z#i2◊n∂µ!VX—"#%bîâCf@ú,ÖÿÎY≥fù4+´_?..€≠8T,qÉtºßf\‘9íïøpâÃ[π&Ê+ëº∆åém$MFŸ˜ÒÜ aFxg8„D2–î(QBC0⁄∂m´
5j‘P‚Eûj1ûë#GÍƒøZµjJÏ¯*D∑oﬂ.W]u’? Å‘©[∑ÆÜPnEÅºGmCxUjüüïJhg0X'IFê\∑5¡Ùò»ÓcƒC‡¯VÅcï÷ñ.ıv≤˚—8|ú/,@ƒ™I+‰ÌºÜÄà,Y≤D∫r1UÕö5kR·èc‚«y†]|¡˘2°Kª§jØ‘.∂˝®Ò≤}◊nO§+åUcI+‰ÌºëB ¢Ö¡È‘©Sı,"TØ^]	î¯∆‡õÅœ‘7‹ ã-JIWÍT8NI¡ÉWû¯Ÿ∏)é	±Ézèﬁ≥û¸%$œ ï+%wÓ‹©~^™T©∞@èœ¢p\8Dæpîa√ÜI«é√qX;FàÒ8ÄÜU‡X•µ•ÛZ¸xﬁK°,AépkÕì^Py-FÚrç§â$∫vlC ∫vÌ™#V
Y1DõL%^∆kªvÌä∫/ç◊˙∆ÓÉ?Kã!£í⁄èÜ61í∆k=”Í*-Ñ5Aæ,XPö4i¢˛3¯i‘´W/Ö§!k˛2Öñ®!0iÑ˚˜ÔØd6Nè=T≥`¡i›∫µfÇ®¡€Üsˇm∑›¶ûVÉíb≈ä…¿Åeˇ˛˝íCàTü>}˛Ò9«É(
Gâ◊gQ8ÆùPÎ¶MõÍ°P?A¬Yâ-F<éøaï6Vx °îÎ–°Cö·ü~˙©¥j’J
»'”FÙ¯ﬂ≤Qá~≤e˚Œò.@Iì‡ùÃ.œ€‹u◊]jé¯Êõo ›wﬂùT©∑iôx„ΩBàVÕ“%•eı ﬁÓd¨›åÂ+‰’e+¥Ô∆ãßP$‡0í&®⁄1câ $™åÄ˜ÏŸ£D°ûòöbˆé°¢#HˆÓ›´*Bû(xå·/ÉBÊã/æP“ÜcP»&ƒ}ﬂˇsåÅ	£BuÉÒ∂m€N9ˇßˆy∏<‹‚ıYÆ>‚K‘0!ëÅïÿ!`ƒC‡ÿV©cÖùBÅ‘(ú˚6*π‘»G“/vµåÿ%p‡=æeÀŒ}•U„{‰_7ùÙJÀli›cà|∂˛k5ªø˘Êõ3ª{X∂7í&,0⁄AÅ‡ Â4<bÙìÕè&ûIóÆ0ŸCûP—†¶aÚvı’W˜#HÄΩå§IÄF¥K8<iÅAÈÇ9pˆÏŸ3Dà4ŸÑÏí¶€ø«Wã¶µOf?œ∞rlêÏ$0âC)≈Ñ2ìïÿ `ƒC‡∏VicÖ:ë4í]PR#kP*>˝Ù”RΩB)È”Ò§¢.J√∂=§”√É&i\Üß!CÜË¬B,äë4±@›Œià®„5◊\£7MﬁáÀ 1û¿çÁÅ±K≈›≥·}r[ëk‚	ˆ∞‘ıÀÌﬂJè	S%oﬁºéêÃ≈Hödn˝ƒºvîdYÍŸ≥gb^†ﬂU≈Û≥(úD®”+ØºbDM8A‚Xë$0Â∆oÍ∑ﬂ~”∂&‹ı‰Í¶MõT—∆‰©	&»˝˜ﬂØŸ¿»∏Üœ‘ÈßüÆãœ>˚¨˛ˇ˚Ôøk¯„¯Ò„Â¢ã.ﬁJï*ÈU36 ÏëBhˇ£è>ˆ¶ëƒ*à¶Û‰.Èë5d√ñjHã5Ç™ˇ“À¸%ÔÀoøí)sH∑vIÔ«Z…ŸgeïÉø¸*OyQFMö©«Ó”πï<ÒhS9q‚rÀÆ2eT9ˇºsÂË±?R˛?˝¥”ÂÒ~√d¬Ù7Â¢‹πdÍ®˛R±Ï≠∫ˇÇwWHÌá:È˚ÁüÍ,Ìö’ó3Œ8]~˚˝∞Ùyv¥åú8Sö÷Ø%ó~ Ûßåêõo,‘5Mò1_∆œòØŸ’x≈¢I‘ÌúÜ¿ﬂØ{ÓπGZbÎìÕ4òNœc∑˙p}Å¸2∞E„§Î”45Ñ=@X%s1í&ô[?1ØùÃNGéQπ|2îx~Öª}uö;wÆ*iP‘∞êd%∫Díx î‚e î))&ﬁÑvÎ÷M≥ÆÒóêF&ˆ®´0¯ﬁΩ{∑zQ·I√gÓº®6n‹(/ºÇÜÔ38p‡ÄÜ4ÚªZæ|πê%ás6n‹X	ùp∞B-ÇO†ïÃ!¿o∞ù;wJÎFµÉ&i^[∞TÍ∑Í&ìGÙï€o-.ı[?!U˛]JûÏ“Z™7zTrû{é<”´ÉÏ⁄ΩWnØŸTV/ú"≈Æ+,%*’óèLñrûß$ç˚ÙÀ≥e”◊€dxøÆ≤ÏÉè•—#=eÔ∆˜‰Àç[§¬ΩÀ“9/JﬁãÛË9›[]k’H⁄˜,€w˛(#˙?.Ôº∑Rˇˇ¯Ì©F“dÆKÿ÷ÜÄ! HË∫wÔÆFä¨0$õipºì4‘ﬂC“@÷$Kq*ösŒ9GW XqKÊb$M2∑æ]{" ‡$xç’Ø_?.)Ëk¿√Ç…5∑å®	∆êvå4I3fÃ%ON;Ì4ÕÿV´V-Õ¢˘B∆4¡∑n›*ÂÀó◊œ0ø˜ﬁ{SHö-[∂§¸ﬂ≤eKU›°¥)T®ê’B 4oﬁ\r‰»°üü8qBIüˆÌ€Î˘≤eÀ>æ;I<î9sÊTíÔ±PIö±ìg+yBü⁄’V©”¨ì|˙ÓLŸ∏y´∏‚2πÇÛeˇ¡üÂﬁ]dËSù”%iÔ;\~¯iè<”≥Ωº2ü¸Ú€ÔrÈ≈yüôŸ≥…†ûÌµOΩøÍSÈÿ˚YYµ`äî∫˚AyÎÂaR‰öÇ⁄+›◊J˜Ít∏ì)iÇÔW∂ß!˜∞¢¿ÄpÏÿ±“¨Y≥∞K@„†x_ΩLV5çS—ƒRÍ•˛m$çóZ√ÍbdV‚Òe ª·…^|âû”(j¨DÅHí4Ñ#°îÎ‹π≥^f›%Jî–∞˚?¸0%<âÔ_ à§¡úÏmÑQQ¯-Ò"{È»ë#OÕÔÇ.òëƒ*lïåÒÅ »∏øÒó9ÉJäW8¬ù^}cë¸¥wø*Z¥OÌÿ)∑‹ıÄl[≥Pæˇq∑‡≥ÒÎìf.EØ-î¶íÊÿ±„ÚPáﬁBÖ)B®∫ıë6ÂéE8‘⁄wgHÖ{ñ’oOïÛŒÕ°_ÖÍIc$Må;≠ùﬁà%◊^{≠`@ã|î4•∞œ…V‚ù§!¶i/2€’ÓîZeN∆Ã&rYΩq≥ò>G”nõäÊdKIì»=ﬁÆ-»¸F
Ó“•KÀ⁄µk’<òg_†ÂË—£r„ç7 Í’´%ú;ˇÛ;íoédŒTÁãÀÁüÆäî(çHœm%:Díx ‹	Oö©SßÍ≈@¬êùç∑ÎØø^ñ,Y¢øW2ß.\X6lÿ ?˛¯£ûOü„]É‚åÒ+äõK.πD˛¸ÛO˝ùV´VMU9Ñ?›~˚ÌÚ»#èËy0"g?≤¬e…í%l@F´∞U2FJèúqaå·0&‹	OöW^Ëw≤O}≥Cj>ÿ^>^4]n≠⁄P:¥l(Ô©¶ﬁ3Z?!]⁄<®$ÕÂÔï’oOì\Áü'GéìÎnØ#ü-õ)˚¸,ó‰…-˛ıß|¸Èórw„ˆÚ·ºó’o¶L…õ§ÌC˜üÏSø¸*_mŸÆÍH°”F ’WùTµ◊|∞ÉÙyÏ·†ï4f£Nkß5ºÄ rO†<∏,Ê€-\\˙¬ŸŒñâù€	µ:rTö??J¯K«{Ø·k$ç◊ZƒÍ„òƒ]vŸe∫"a	‚RwR«„«èK±b≈å§	¨lcDM@‡êë$ i»⁄∂h—")X∞†4i“DÚÁœ/m⁄¥ëí%K*)CB åÅ1g1ëp|¸jV¨X!EãU¬Ü0g“µC8p†Ïﬂø_C‰Y‹ºy≥™u»,DˆRâ?˘‰£gx$±
†©<ª	j82»B≤˙*g¸Á·H¡IÉÃ¬i#Â™+/ó¶ûî¸ó_"˝üh'≈+’ìüÎ-ÂÀ‹"ÔæøZ™>àÃˇúT≠xªî¨“Pmﬁ@}eÜø4]FNú!ÎﬂM=hä]SP˙wo'˚˛"7ﬂŸ@ÊΩ2\6o˝V∫ˆ&À_/W\vâ¥Î>H˛ªn£|∫dÜ4|§á‰Ω(∑ÜB}æ~≥î´›,$OK¡ÌŸÆûäqc„ÕèÄ¬ä;ˇ˚b7π!R»≈Œˇ§≥MÊî∂·iÔÖõ'+∏Èc»ñåôùº€:ôØôàêÂâlOâZFº>_ñÆ]ß“hFVN"`$çıÑdA µl-{˜Óï2e h¶VŒY-Ø\π≤z^º˝ˆ€rÁùwÍX®Nù:
&z√á◊ê&{3gŒ‘x
·¯\8æcµﬂî4±Èe¥ﬁ$‘4®j¨DÅHê4œ<Ûå˙ê™TµjUyı’Wu<äèÔ)$¿≤Üﬂ3$LØ^ΩÙ;~”lˇ÷[o©í„·m€NÜ≥@ƒˆÓ›[}AÏ”ßè~…≥lŸ2%¬Y"âU8ÎãcqèeæAXSZã¡é§)\ üL—;®jB“ı≤¸∞kèÏŸw@™T(#”FPÂÃò…≥ï¿°‘≠^Q.∫ÕÿD”€À>T≈ÂéR7À¶-€e√ä◊UISΩa;ŸˆÌ˙äòû[jüzf‘ÀÚ‘scOˆ©¸ó…íY„‰ |ó ﬁ˝•rΩ6ÚÂ¶-)◊äqp£˝dÀˆù˙{à’|‹≤;’Sﬂâ–ÿc:</˛•0pÅ¥·≈
T≤õsÜÇ•◊ˆE2 j"≤oVí1≥ì◊⁄$î˙[«DòTîâˆ9ICò-»d+'0í∆zB2 ¿äxZŸZò‡?Ò—G©°hÖ
§oﬂæöÜl.LÃ i _Í÷≠´iæ.\(ê<Â ï”Uz∆;<	#Â≈§êâ¢ë4±Ìa¥U”¶MµF‘Dæ-"I<‡IÉÇ5Õ·√á5—∑¸˙ÎØ:&ÖÑÒ/lOÒﬂáœ“⁄è}ò\c"âI¨"Q_/Û_ˇ˙óVÎ„y¡-æ·ICË—#MÎ…·#G%ªü¢úœ¥ﬂ§¢4ˇ„¯q9~¸O5ˆ/ø˛vH≤fÕ¢©º}«”>ï∆>úÁÃ3œ	Í[kûLª˝ﬂˇ˛7§„Ñ≤≥ë4°†˜˜æ3¨48C&wH‘1®%X˝·=7<òLˇ’ nñ0ùÑæ†¥·LΩ¸”…18‚ac%æ`0 Jƒ≠∑ﬁ™P#i‚ª=©=øóZÚÖv-•@ﬁã„ˇ¢˛æÇÌªvK˜âS-Ã)ç5í&a∫∫]H:§ó≠Ö‘ê4®j0%§◊ë4/§ı}¸Ò«Â∫ÎÆS2¶_ø~∫è+˚åÉπ∏„é;d˚ˆÌ:d<ƒbÜë4±ÔöæDF¬åG≠DÅH¥#ŸòeJÑI¨ü@Æ¡e*}s¸@πÙ‚‹ÅÏr 6ØÃûØŸòz¥oûÈ}Ω∏√èª˜Iùñ=tÓéz4V≈Hö ëw™≤Û¯Ü//^\
(†ØP•πN®"Æ€V∞…™¬@∆‘5A6`åw√∞ç/ÿIì&Ö’D-∆óñ‘ß˛˘Á5cæ4Éö7N¢f˜¡ü•√Ë	J–0…r!í∫°˝.ﬁHÎ…Ä Ès”À÷B(C•JïNQZ¯í4Ó=Ê§,P†(ı-ë*Q√±N?˝t]º2„`ÔÙ.ó™úGà¸G¨ÑÅH,9rDÁ)âP"âU"‡»5∏ê˝g{¥ï;nÀ¸o˙ß=˚Â»—£öj; Çe+•ﬂà…:œf\´b$M»3	„¶‡¬ôêÒ‚—P§HëTÂÅAú‚ª0PŸ∏q£fGÿ±cá~AY√ƒ…J| @;¢®Íﬂøø¶√Î÷≠õfíßâZ∏ë``éâ,ÉÊ`
´ß¸nîáJ^s˛hÓC{¢ÆK#aà4(iÃá&Ì^‰H≤b‚—¨Y≥hv9;ó!k§ï≠ÂØø˛J!^.ø¸Úî{Ω?I”Ω{wçÔá®ô5kñ8ô=ãQÑãíı≈yÿ†ƒa2…ˆë~v`ÆÈ61Ÿ¥í6æDà·ˆ1ÏEÁº„Û≤í6ÜUËΩÉˆ°CáJı
•§O«ìaç…\\f'|ôªçU1í&»„3£ÜÖS≈ä£ŒF3òaï…ë5``Aë[Ò&ﬂ~˚≠¶<Ãù;∑‹ˇ˝ÚƒO»∞a√T‚›©S'ı¯»ó/ü:ÎßÎÀ´Ç§°Øa,IC
∆◊^{-‚íıX‚‰Œy€™U+ΩOÚ‘Èûöq©®Ò%h∏«º¯‚ã¶‹K£ÉA“‘Æ][S1Id"jÂT‹d‹p	ÅX∆¬ßVÀi”¶•ô≠Öloxï`
LH6∆¿#Få–4ΩÑÅÓaÉ“Üøx”P∆é+«é”œ!ÅxVﬁÙ‹sœÈæ„«èW‚3“·NÅ∑äm	Ñ:·QÑíEçe®oø0‚!p<´¿±JkK∆´êÑ:ÚîÏÖP'BûbiLI`OÑatéÁ<åH?k© dÕÎØøÆq‹~`∞~Vºá ´Ä¨ﬂà°NoºÒÜf¥(T®êZâ”gÎ6§∞3d ¿ôüâ¬¸ëB“Pgﬂ´WØVÇâ∏Ê/ºPA'+™“2ﬁu◊]:a-]∫¥èUS˙,«#[@·¬Ö5ç3*éAÿY¯≠1Há¬®∞V≠Z2wÓ\π·ÜîÿrDQjﬂìÊBÏökÆQS<1&ÙyAé°tât6-_¢&Cü|=hå†…¯~Ç*Œ≈-Û˚Ö–äU6Äåkõ-å§…<Ó^ iÆ Ö6Âœ?ˇL5[˜;Óœ§÷Â/œÓÔ+WÆî	&HÎ÷≠ï§·œ≥è˚>j≥Üj`
üc&å19äaﬂE'“wIì˘˛…=wB‘–ÊF‘Ñi#«‘∞
´Ù∂‰˜åö1X_ö‘"ˆGq~4<ã¸Ωf£];#i2@ø&yN=C∆^^*§π‰Eab¿ »2Øx©ÖDâ4H29°Hy·Ötıâ*‰©KYEåµ?ÕÒ„«’ÙëzBr–Ø≥cEìp'÷öY˘Ñ∏$≠"5BπX=%•#§€Ú“Ñ>	q√J+d˚£LCY‰º	 w0¥£¨_ø^•ÁÙ]Åa2Ïäõ¯~øoﬂ>3fåºÒ˛°êUÑ∫`j…ƒ°T©RÔ L\P∏1·Ä®ÈX∑Üê¢€ÎÂÀÌﬂ ÄÈs‘É∆öå[À4<–ôX≤∫lDÕ?qs$çàáå[5∂[x+ÓÁã/÷g¡ÄN$îl-®f|IÚCá©q∞øÇî)&z€æòﬁŸ◊@–åGI»3ﬁJx0‚!p´¿±JoKÁ©XøfEÈ‘¢^xáG6añÃú∑ÃåF“§”Å f[`≤Öz¶Q£Fö≠…ãı*ö6Abâå5Jï'd¿` a0x`y¬ìÜp(V∞∆™∞Zâ¢¬Ñ∫Aî‡EB÷ƒâï‹8p‡ÄYC∞†®Èÿ±£ﬂˇΩ*WPwëbï…*|^\£Ø·$$Ñé;ü#`»Rπre≈Çz@“∞ˇî)St◊wpÔHﬂÔªvÌ™§◊ó_~©ø&;x‡¿Ü£º·x£Gèñ∂m€FbÁQ√	kïπUSt{µº∫lÖÃXæB´G»$S¨ï]^≈äz˘4!µ\{€}¯‘ñÛÒ‡Âæ‰[∑Xc≈˝í˚7
ê*ıVÅ‘ ºçx∆
x’∞c%tåxC√*p¨“€“BûN¢„ïP'Íb$M=È∫[µg≤HxÜØ^.L¸ô „ã@!Ki’¨xVõ  vÓ‹©dD+Ô(- oYÀ⁄R7BÜ îÄa ñ+W.UÕ†z!¥âA<aGê080Ïwﬂ}˜©'Ÿ8|ãVBæ ñ-´d$êAyCò8¶‘¢Eãl„HﬂÔ]X‰¶ì‘CoT@€∂mã	IC≈ù)ÔΩËSCx”¯ÖK%÷fi±¸zÓ‘∑Ø5ˇD1÷ƒC†ÌÍÖÌbÖïÛ#ºîpV|˜ö4i¢a¢^.,RÒÃÒâ‚≤s¨@Ù·áÍ‚œ]∆x®@-Ñˇ~¡∫0·R—r°\Å'∑Û%j:tË†akVBC¿àá¿Ò3¨«*£-]*Ó±ªHâbWg¥y¬}øv˝◊“¶«êòßﬁv¿IìJÛ%hH©AO¢∆•Ï6¢∆[-◊´W/$¢Ó 4áL¯‘êB"ñ*êr ñÅ™˘)ƒZ|P“†ÙÅ∏Å` ö5´íÑ?adÕ@ô˜Ü	5¢n‘∏qc]]#î	H5(áÿA\AÇ¢§!¨V&
+»›”Sæ8í∆W„UílY•@ô≤k◊.Ìî®jî/´°P±*Ñ4ÕxÔô˚—«Z˙"Ñõ˘©§ﬂ"È4F‘§é]¨àáX˝∂B9o¥±‚ûÎ´û°ÓÑØpØ^Ω∫Á’t(91"&Ï÷7S"aY®6YH C∏n{€m∑)qìï†€ﬂ7”^r<'-µ®Íä∞b
œ{T5VÇG¿àá¿±3¨«*£-›¸Ç¢&Ÿ
DçWÊŒF“¯ı@_ÇÜêç‘V˘„°”2hy˚Ì∑µ™^ÈlÒÄ[§Î∏yÛf)WÆúÜAvP˙ıÎß+ï^H√Õ†ñê&åé!?P˘@Œ8OÍäJ ≈+î¯÷‡ˇ≤a√deíˇŸ52y…¯ƒ¬ƒ¿Øp§‰&;€ì≤ï-DŒÏŸ≥5|*Oû<a!iÚÁœØ»X*i\ø#Æõk•@–‘,URjï.U≤rfÓ 52o’ıû°0˘¿)3óHˇ^ºx¸@#j˛Ÿr—&ºÿw≠S†XA¢´%4¢ú‰$D; I»HöxI≠LÜ(»oxv@û,\∏P=’0ÊÁz¿îgFı‚sΩÑË∞ ûCKó.’‘‡…?Ñ%ÛÃb;º„|∞Q“ÄﬂÛ¨„¯ò›sè¿¸ûÁ¶;Vˇ˛˝u/<ÁÌáô›éÁ7◊O1¢&≥Ëù∫ΩÅ„gXéU [:·dS”xMEC[I„”c12≈ÉÜœçª$_¢&÷iƒπ1$À6¸¿†A°1H˙ÌX´h˛®d0∆hóï1¨D2Dñ'´r)(kãa@J¡Ÿ◊XõÔP“‡q9ô√ "SH&[∂l—¨Núè°ÉÑ|Î÷≠AÖ;a^»yP˙ÓT¨X1UÙ8íÜl#ÆcY0$á»Ç£@÷T*q£T,~CD”u÷¥Ï≥/dÈ⁄u)‰D4u1≥Òå{Dfw4}:âD†ƒC∆≠ê¯[dÑƒÛÓ›ª•[∑n©ÉZ“3é§· ®A ﬁ´T©¢Jìx)ˇ˚ﬂˇ4¨?≤ÛŒ;O÷ﬁyÁ}Ü± Ç*e /û)„∆ç”P]pc2ÇZc‰U´V©øäG»TÖ,4p¸!∞Xp`Ò¿îõ,àQ∂ÖËa’¨{ﬁ±∏Å)?œŒD/^ÑoSP”ö (∏7‚!p‹´¿±
dKág≤©iúäÜK_≈d òEj#i˛FñI°¨t«càSZƒÖ>±:Œ$€&bë˙)~\T*¯±¸˙ÎØ™® Ègú¯¢∞%˙9r§z6Ã$˘>µÃÏK∆≤u∫jË2y`Ï p`	˚)∏Ô–¸_{g∑ÂîˇˇC¢¡QYbH
Cci¡/©,	Mc˘"’hHeää¯˝EÖD÷Bç,£YJ{^Dñb,ÖP÷©Pô4MòˇÎ˝mŒ„ÓÒÙ<◊}ﬂ◊}ﬂ◊Ú9Ø◊Ûz∂k9Á}Œ}]Á|Œwô<πÏ⁄µµ£;Ó–É›¡˚ÓÌÔΩgﬁ˜\¯ÒßÓ≠%ªóﬂ]Ïi|aAF–ÂÃT∑yﬂ,¡»E†Ò8$‘H§…Ê£±9ëÜg.±bàÉH√ÔàïYºpn•XÜ ∏{a—qùE4Ò\¯é8∑ÁØw…≈∫ìœ(|Áø˛˙kã•F
qæZY°`¢
s>xpÔ,6∞¯$	Æ∑|gÛÑyÁx—≈˜%b?˜Úzo—ÉxÉòÉ(ƒúã ˘Ùi(X b5D¬6n$‘dﬂÎÇ3´‡¨Ç…:òπ!÷â{ûÔ⁄µj‰¥X3yˆ<7hƒ˝&Œc‘ãrâ4ˇVHvPí$–¯O‚4ví|*•'–æ}{3ªf‚ÜôµJ∫	 ÷ ‘`UÂc÷x"’ﬂÀ5Æøó´Yc∑OùçŸÂ*oc(Kó≠pﬂ¨˚ó[¯—'nÈä/ ,f¯/ vèqkí`|ÃÂ#–H®ŸH†*Îê‡Ωë¸#+bÖò¿˚7æX¯\ù±i,_à1ÉïœæÛ;4|ë°2Sò·Á∏∏5U‘Û¥≠~˝˙ˆ/¸%È    IDAT&÷¥ëgs2‘!Ã‡é?,Z∞úA»¡ç	+œÃ¬ªò`¯XÂê!õÇ(Á48≥‡VE,5ƒ
¡Öqk¬B·¶Eã&Ç# ïxí>ä3Ööè>˙»ï‡$<àUp·…;Üg€/∑€÷M∫o∞}Oj˘Á∑ﬂπ”ªp|'i	s‰®â4ŒY†L^¬,`ÿâ€NRUÉââfªòH≥8#xiúJ¶xúÍ]Y]±¢˘Ò«6qY∞`ARP•Æ∏]ÚÇ‰;¬qæqñÖ/YÕdO3Å∆ﬂ5Õ5iÇèΩLVà∏Ôêù/ª∏ü∂lŸ“‹F◊≠[∑â „EæÛ≈{´æº’?'aÆÉ{1ØºÚäâ0ùgéÉ`Çõ+¬õplå∞	G‡`û´∏!ÊÙË—√:!Å∏2¸qÖòlà/X‹‡:EÜAÊOôÖﬂπ∂œ¢âÎ”Ãô3ÕáLP,ràqÉŸ”V ±ﬁ‚;5jÇè /“?CGF…M%	ΩOÁcè˙çªq¿üí–§
€p˘‡ª‹s/øaœi/2*çMΩH„„–0Y·%Ã.Sì5Ñ ®Q£bµXK¢HÉ@C¡7æE"M!®ˇöòù≤†‡9≈œû¶7‚‡vFÏ‹ƒ|ês|!» –D≈l≥¯ÙÚøcòM⁄Öâ4¡«#¨p%†ºgxáSò£ “‡¢É √WyAÜc2øûÓEö§-î…ñ»{ÎóÁû{Œ‹á±û¡=â@ˆƒÄ„Yà1Ç¡}q√jÒ≤À.3ãÑ.ÑÇﬁKÜ≈	ÒmàgC3,q∏2nM(ˆ◊¿]å„m¬è»ÉC<4oÌ|ƒˇH∆&õj≤ÔKâ4Ÿ3ìHì=≥ Œ¿¬ö¯ëΩ.<√ù}ÍÒ·ﬁ W{‰…YÓ÷—\Õö5Ì5Û‘ã4ﬁÕâ`ßôO#0vBØô¯äõ€ì&˜¡áB‹X1ÅcbÕ.[îLÉ/›ëºPÓΩ˜^{â≤Q	ó@!ö45q{6Ö;ö≤ª¨∞∂¨U´ñπŸ¯Ç ãKéèıÖ‡‚øº(É S^§…ÓÓÒ:ó#gd
Ù¬-\∏!é Æ‡≈F‚¢∆={ˆ,€9Eê!¿=Ò·pï‚}‰ÉÁ#¬p˛Ø~ı´üâ4⁄«Úë¬5HÏ7_¢ã•÷<Qã;W¨^F®¡íÜ∏H∏@ë4AED º€µ}hƒ@∑_˝=‚QÒ µ¸‡£œ‹9=ŸëQssÚ’OµH√"g¯·6…¡,5ÖÅ»Kì$wq(ö‹Ô•∏±íHºo3è$®%/“`ÊœÆ±J8
)–§U®â€≥)úëî€U`E [≤M‚∆ÉPÉàiH+ç’AkÀã4π›1Ωg!Ï ™îw˝¬í	KE‡WU∞ƒ¡-*ÛX~'7Òh:vÏX’%˝¨êx◊ì5KBM¢ªZçK Ñ∏4w˛s"ÑöÓn∂84QíZë◊|î˘Nö¥ò¢‚wçπ/.d1àÉ+Ñ&˜¡ü˙qc%ë&xﬂfâ¿åY>üÁ=˜‹”~ñ5Mn,ÀüUÅ&çBM‹ûM·å¶‹Æí…
D\Fÿ’Ù¡ΩH√3TŸsr„\®≥∞Æ9¯‡É]ΩzıÃ›)Û¨B±◊ÕjÆπÊG|.Åx ŒVÔX“ ‘ƒ9ê0¬ÃyΩÆsÀæXi¡·°¢ZR+“x+Íã&MüivÂxQ˙ÄwQnø&˜¡{'n¨$“Ô[d¶çˇVq≤¶…ûe)ö¥	5q{6Â?örøBE¨∞ÄE§a±Î≠k∏√ê!C‹E]î˚Õt¶¿jf’™Uf≠¥ÛŒ;ÁEÖòs>^XZ›ú*àq(∏=aU£""}4`ŸI<DÑötwujÁ˜ú,E´f.|∑√íÜ–ƒhç≤àûZë+Ç"•…ä∆ º5í∞¶âz—‰>x≈çïDö‡}ÎèÃ¥¢Òì5Mˆ£ –§I®â€≥)ˇï˚*cE,Ñ¨kkò8+ûWÓ¨ufq	H®).o›M¬"ê)‘ƒ—ı)”≈)˝ñJëÜ®˛ò¥ß—ä∆X„dM£…}Gl‹XI§	ﬁ∑È≠hx‡∑≈[XK2;ÒsádMìŒ≤£ãÈ‚¥π*&==wîûMlŒ`}Bz‰˝ˆ€œΩı÷[?
õ„P
Â¥†¨p}bìÑT⁄°Ä´‚"ƒü¡R∆^.∆=uèü‡Y«3óxJ$êªûFâƒÉ@y°f`œÛ-Ew‘)∂ç∏ﬂb–ƒE†I≠H„}ÎX‘¯¥µQ`a◊Ôı◊_wè?˛x‰˝Òhw–	kÿå‚xΩ∏±íHì›(ÛV4uÎ÷5qfˆÏŸÆEãˆÛ|†ÿ4Ÿ·¥££ –¯j'Y®â“≥â@Åœ?Ù–CÕ"Öî÷,ﬁ£R¢ƒ**L|=fŒúÈj◊Æm1_≤)#FåpΩzı≤ Î§ËÆQ£F6ßÎÿê	‡Í4vÏX	5!s’ÂD†¸\Ö{ëöõ›Q-§ÿ&’6•]ªv±äáï:KT¿ñ-[Zgl3≠;PÏ¿ìÜ¬NFî}Ú4a˛Ëã+â4¡˚6”ä¶wÔﬁ&Ã 0∞ -Ôµ◊^+kö‡8#'–$A®YΩzµ˚Ï≥œ,}4Ÿq2Àü˛Ù'≥˚€ﬂ≤Ï•¸ÁΩœ˚˛∂€nsù;wvì'OvS¶Lqç7v|ñnºÒF{beã+4Âñ[nq=zÙ(IÍ‰∏=«ÛÔ°`W¯˙ÎØ-Ö6©±wŸeó`'9gáç5r?¸∞;¿›ˆ€o¯\X8^®¡åÁñ5*" Ò ‡cªR[‚‘\”Î¸He~¬ΩÈˇ›zø≈ü°ƒ)´±©i¸†bÌwø˚]<>	™Âcè=f/∆®\MXÉÄ∏±íHºo±|8p†-R˙Ω`¡◊ø◊Ø_?wÚ…'€Ó B«ú{Óπ¡/ú“#£dASæ‚fQÛÕ7ﬂ∏Áüﬁ≤?XëÜ‡©ôÎ, ¯^ÃB*‰K.πƒ2°›~˚Ìn⁄¥iˆ˚¸˘ÛM§9‰êCÃöó'ûGsÊÃqƒk;„å3Ïs‘ßOübV◊Ó∑Áx.Ä\ÁgàÃƒ«#•¯˜ﬂÔ:uÍ‰Æ∏‚
≥ñA`!Ö5˝pÊôgö@C†Ù|–Rgg¨	ªuÎfñ€∂mkñtÕõ7∑Û∞¢!ûOÊ¶˜Cå#Æ◊∏q„‹ä+¨.<_''ûx¢cﬁàÄÓªÔ∫û={:¨yH≠=r‰H{ø¯‚ãÓ˙ÎØ∑˚ ^}ı’6øƒbãÏN<ªO?˝tK”}œ=˜îz¶Áúsé5·ÓªÔv’´Ww&L0ä˙ruÂºã/æÿ¸Ò&ƒ'•õœôÀpyb√PBMRzWÌHﬁ˜xß,_æ‹öãUÕÖgµ+iˆ'\öFèõ\f=≥˚Óª['‹ú‚VR'“»’Èß!óß4LX√zpƒçïDö‡=O∂êπsÁZ÷êV≠Zπ[oΩµL§a±ì˘ø¥Z•eÅ∆∑!.BÕøˇ˝o˜Ë£è⁄"°cè=ˆ∞Ök˘¨6•iæ˝ˆ[[Ï≥∆öÇÔq«g÷3ƒ§Ò""¿v€mÁn∏·òXË_zÈ•%qçâ€s<ËÁŒárÃ1«X<ÿÕõ7œ≤˛,^ºÿ¨õ?ˇ˚ﬂM,C4arÕb k¡uÎ÷πX,°ÃB∆ ˙ıÎª;Ó∏√Dæ#rº˙Í´fq»=ÓºÛN≥§AÒ±ﬁç≥fÕ≤qÇ–Ç•1¬
0zË!ª6ì}Æã √µñ.]jˇ#SqéjN8·ª<ñYú√|Î +Ø4kû3fÿ˝p≥Cÿ<˙Ë£Mö>}∫?~ºâ4gùuñ	J‹ì∫Sb˝ÍWø w§è//‘î¬“.“ÄT9à8ÑGyƒh
AÖœlﬂ ù’æUQ≈ƒôqOÕv„üöm±g(àˆàÂQˆ©¨{S'“‡Í‰Mü”æêarÇ∫»‡e#™%È÷0π«çmLDôò)x`v#aË–°e"ixUÇàÉ@'°ÜwÇãh¸ΩŸÌgëYﬁ °TÓN1XŒx7ì&S§¡:çEvf¡¬£„∏=«É}Ú~:
1Ñ¨TX¶h√Üˆ¸'°¡;Ï`¬àèC´ÛŒ;œ-Z¥»¨~â#àõbç∑÷B‰sç áeÂÛœ?wMö4±˛cÒ@∞`6È üáı¬
Ç"b#‚V6‘K¨l∞ò¡äÜ¬ÒX0RØÆ]ª⁄C<Zπr•çÍèı‰ìO∫—£GõP≥◊^{π%KñòEWªzıÍôeB‚Ω˜ﬁk"ÌBàGH§ZX“0nìXjpyZ≥fçı-¢óäà@ºê1ôπ Ç¥k⁄ﬂÃù|\”Ç∫A·Œ4eŒKnÚ¨ye‚Ô	ÍÇ–Áí*ëÜI$f≤ºày·©87lÿ0«íIHTM¡í>as∆âã'>ãå?Cô9g7$“d«ã£„$–ƒA®¡ ˜èâ'ö{–Âó_Ó~˝Î_ˇL†°-•z6ë—1fÍ‘©eÔ8ƒ$DôLëâ ‹~n¿3	·√ﬂƒÚ"˚Qó˝•bï}Ms;c–†An€m∑5—Ñ¬ª 1ÇÙÃXƒ<Òƒ&íêµn‘®Q&l‡N&‡Guî	oûÖX≠‹t”MÆi”¶ˆ7‹€8Ü>ƒ5	ÖM∫ÃÛA¸˝8ëëcIàØƒ=πÓSôÎ,_rº•u¬Ö	ÒaóT
à0å1 oe∆./cêÎP7Ê®>†1ñ9X!Z·vóÙ`«l÷`Y+°&∑œîŒÅ®‡9∆öíÿoæ‘©Ω≥;È∏¶Ó∑5pá6ŒﬂÌËoﬂwﬁ^ÏûôÛí[ˆ≈ ≤˚ngù’ıl∂}î*ë∆ßﬁV<öüÜâèK√Ñï›´(ñ§OX√d'VL ¯,2IfB≠íâ4ŸÒä£@u°Wì≠,¶è=ˆÿÕ¶7.’≥	˜&ÈﬁJ´=ƒòÚ1i$Ï›°âO¬Çöchc±S6a≈b+ƒ‹¥‚Tà£Ö/Ó?¨]p˝AåA¿!V6Xπ`qÇàÅµä∑l¬’ãT„≈KîfÕöŸ5q+ÚÆTLÿ_zÈ%≥`…<ÒÑ¯1ãàsX‚på?7#¨dàO√ÿæÎÆª ƒF,|[j’™e¬èØV º€»&E˝∞Ç°ö}˚ˆuoø˝∂âòﬁè„âE„Ö)_v§qcÂŸÖêìÙ‚Á¥ì¿›≈Wà',kpÉ¬uÿ«¨Ò-9¨Ò˛Ó∞Éò;TÉ}ˆ∞?W$ﬁ ∆P/˝Ã¨d^{±{˝øÛ◊‚›ŒÛK√∏[ŒîÔÈTâ4òºÚÖ9)_*ŒÇ$Ú≈ÑàØ(ñ ÷(÷ªu
 
?ˇ›v€≠U,ª';åòΩÄQ%;iÇÛä≥@„[≈5<Ä- ±6!Üã›Õï†œ¶‡Ω¸»Øæ˙ ,$6|)/“ ‡6»¢ù¬bù˜à»≈.ï±¢L|?˘‰{Ü‚"ßB˝âaÑı	1∂à·ÇBú-&⁄ƒhA¸£]àe∏Eµn›⁄Ç<◊≠[wìÊ"ƒ√ÂÄ0·´,sÿÑ¬ÇÅkòö5knrÓLà:*X‡‡˙ƒ‹–À{	QãÊGB∏ƒ!ûPG‚…ì	qèø!⁄Po˛G›	†MÏDDÑ(b‰ ‡⁄Ü Å%)å}·⁄,<∏s¥bÖ•OXSüàÇÄ∑±]*n∫ØDô¿kØΩfÔ,æciìoAxÁœ3íÔI-©ix…Ú"˝√˛‡6lò‘>Õ™]LFò01A">ÕÊ
.&2º4ãÌñR …}V0#ppU¨0%ß/Ÿ${F) `b◊ëùAƒ"‹x–™dG@"M0^Ih|K£&‘ ¥bΩ@Ä›Ó›ªWöπ™gS∞ﬁÃÔ(Õ∏ŸT∂‡≈=äE)≠S*bï)Œ|¯·á&núv⁄iñı(nÒºpoBÃ¿$ûÇ8ÅBú¿Iì&ïe0bNBåﬁ∏¡ºó¿øY7·öÑÿC6%
nQ,ˆyø ∂ àîèì‰≠Y^x·≥¥zÊôg69¡+,2*±å–ÁØO=·œ¸	KPÇ”.2T·EüPo‚÷xW%Çì1äÇıqnàSC÷*¨Fº´ˇÁöÖàâ~<‰7˙„sv¶P„9«ßˆ™©à@eàãPÉ`√œƒ˜¢∞>«˙Üg-œc¨bpm•4h–¿¨/dh‚8€ëëJëÜ…/˚|;(òD≥˚S~á&Û⁄,ä1g%:eÖÖ3fæŸL…Ä¿˝ô‡‡øùma"‡}º}dÓÚugëC(∏E±P(f)‰‰S<ÑÃ©s)<TòÙ≥ÉÖ≤9V^úawéæ§Õ¥ùIf±W&ﬁLƒòúÚ=ÌAºsÈâ4USKí@„[%°Ü84∏‹‡¶qÍ©ßöµ√ÊJ!ü„UèÑxë…js‚ÒJò/∞»œÃVßñ"à!úî˛oÓÔÃπ8æ2ë·eÎ≠∑.òÂIæ◊G\√"áyCeÖyME©∆„‘«π÷—äçA6	N7!2◊vÎ<H3Ê7Ã€J±÷å"˜Tâ4Ì€∑7ï”‘0“b*KT˛™D^0´WØ∂¥çõ+\ã	/ì›™^ﬁô◊¯‚ã/l@≥CìãH„3<°L˙]-ÆœB>Sú!x/MæídICÍXL∆} √l?§> %Ê˛Q(ÂBâ3Ï‡a9Ö@SÃâq+WZdWaÀ¨b÷!
}V$“TN2âM‘Ñ‹O»‘C∆¨*+iÇÚaE"ﬁ/<3±úaAA†¿íØlƒ6∞Ãÿwﬂ}Õà˜ÄJÙ–◊>Ω8ÆVal(FØï¡jÑ´VIjÇÒ“Q"wi6Ì¡Tâ4~íàÔ|Æëuü›-v±L¿‹K¨RX8}˙ÈßÆMõ6ÆKó.eÈ≠ΩHÉπ5ñ+3fÃ0ì-Ç˛±6fÃÀêAú|û	8W—q‘Î≤P0èÂ⁄®éπà4\3]
~”Qg|Ö9π«åù‡ò˚TóÏH4°¡ç‡~ò“aä|“I'Y5¶Oüni@ø¸ÚK3Ì'”ãoE¿;Ã™Ω~8ñL'Ù}√ıàﬂÄ0ÇI5ãLπ} A8òıÊ'∆≥¢ﬁﬂù>%)©>âA–L&ËÏ6£ !– ÜQXañN,öRXÚ£Õ≈∏áDöÕSN≤@%°F"Ma>È<«1«‰õ9FAá˜i»	¥ãPÉx¶ãM˜—5Ú#¿ë˜$õƒÆI{aéÄµ¢$AøãΩIòv˛jøìÄDâ4‡0óÇô*tÇ–CÉE7/D≤êˆãt§XU‡J‚É˙=ˇ¸Û&§≤a·ŒnV3,V	ûá5ˇ'`!˛ÂƒÀ¡◊ø¢„xÅ3±"Ë˛z:d"óØH√ÑêÎy∑¶\¯Ú¸ëÚ-!ƒˇùÄÖò-ìf+$‹÷»*ÅÎY>4IV˙é]-ÛÛ{Ïa‚)6ŸÂA§!˚>Îd¨@ BpCxC$·Z‹ëab⁄¥i∂ìâü%~ò~Nü˙îù˘¥—OÓ	Ü»˝G(Ïæ"“UÏ Ñ^§¡_Î>;∏9i'7üûﬁòvñÁ„éÁÄ Fih¢ ‘¯wÒ6XD‡¥≤¶ÿûÙ±+6»òÖHÉÖ-YÅ(Xƒﬁ·=îçk4Ô;,3ÿ`bìÄw>sƒÚ®&Hz?'±}a«œ¡5åπñeÃøv›u◊ƒacnõ8(jP*	H§ëHì≥HC`:DÚX!êRë:"bãÛ€nªÕ¨#XcIÉ Cp^&¥ÏXáÿ/§mƒ™c¿Ä&Ó B‡:≈˘úªπ„’f“ÊEÇ/qˇ\c“0∞§	{◊.ÏßK"çœ ÅX‚≥`≈dKÓÅP√ˇ±JbL_ Í ‘‡ﬁ∂m[kZç5Ãzä¿Çå	RI”g5ƒuä~:Ë†ÉL†i‘®ëù√X@ÿ√ÀÓâOf6à|πEQ§aåòW^§—nXæ=-ë¶"ÇihJ-‘^Î‘©ìΩ;xÆUÂÚ)ë&¯g>ìs≤y±Üò^<SyØ˛`Û'àX√F}≈ıÿ4`#âπ◊b„äÑ
*"ê/Å∞EÍÉP√ÿMÍºA"Mæ£NÁ'ÖÄDâ49ã4ÈEDaÒŒ">3p0V1∏¿î/œÑàâQÛÊÕÀƒÅÃ„X¨„ÂÉ#˛x°¸qL∆xY_áÇ˚¨\c“xëÜÔﬁ›ââ7±Ê•H,ÑJıÇsrè÷J~A¡DÜÙY2S¥¬Ñ¥ûÏb‚äÜ Ca'gÚ‰…vçÃÎÒ∑SN9≈≤<r»!¯Ûr
◊¿ïk%RÉ"˙‡oçÈ9.rÏÂ[Ç∫;—÷bÎı"MæÆ\˘≤I⁄˘≤§Ÿ¥G”(–îR®!√3ã6(™JÉÊs<iüÂÚÌ©à’Êƒ6zrISåÖ#ñ•d˘√÷ß´N:[µØ∞Ù9ŒW¨Ç≥“ëÈ  ë&≈"ãgR{Â8K&Dƒä!ã"ìT\ñXå„ ‚›∞⁄¿ ÖÖ7ˇcÇuƒGò’ñ/∆‚Ûc~f°éHÉ®≥j’™Õ«Ó%◊„:Íƒ=si*±&Ã¢
f‚à)¨¢‡M˙X,_jÎÔGå!3D:R¿±£	k,ßÕup9¡<S∞Ò©=âSCÏ!/“‡5{ˆlª'nOÙ„´ØæZaz–\…A„rÌÕÖr4ŒëHÛS?§Y†)ïP#ë¶pœÅ ﬁyôb.≠ºSr}és-\∏I#ÕF1Ÿ“\∞ˆ§‡™ÆíÅ0Ákπ’ >gâU|˙J5-â4)iª&ËnÆ)∏Ω{nLd«aNF$Dóï+W⁄BkÚaâ2lÿ0>À=ôùx‚âf±ÅXÑ%Ãí%KÃJÖ‡≤Ïdq>øãÜâSE«a˝Ä˚ì)Ç !PØ\c“I¡ù)÷î"-Zò/≤ë#Go‚À`BK|!Ç7#êa5CAt#˛.IX« f–ßXŸ ‰¿1ã˛œqúÀ∏V:àtÙ7nRå	∆A6±z‚˛œÒÏ@„E_áQ‚êÇ;åvÍrwÚc@ÕOüÜb¶ÁñHS∏ßPêws
¨ax'eìÂ©|≠±&ò<ÓªÙiÌ⁄µ◊∞à_Ÿ'_‡˝¨íÅ c7∑+'Ô,±J^ü™E˘êH#ë∆|Ø	òóK!=""â/∏ ˘ÏN/æ¯bô+1Kl,ÓYÃc9A
nD¨q|@Wƒ“lRpÖA¯>|∏π¢Ttìà9sÊîew‚<\Wri∞Ãa—âlCõ+¥aÀìbª=Ö˘"#˛Ÿõ2wÒÀ'∂VEå˙ÄÇò«q∏ò¡ÜÛ(∏;WÜ…1"«!»·.Ü‡„]©>|Ú…'õÂÖ>"‡sµj’Ï˜yÛÊY HbÑëûkV≈ ß‰~ÂïWÃÃ+!ïxê%M∫Ç•≈j$“ÌëÏè´Í9û˝7Ój–ü;wÆYyíı0≠E"M˛=_Ã±õmK{±*-›=z$“l⁄'©J¡Õbú/&!˘LDHèM§˘äÇı!`ÖÅSe)±	,Kñ‹¶2¶Ã]± é√$ﬂ∏">|ae’Öxë¡w≥ä¯·™Dﬂ—áôÖ~•À˜;Ø,ù5πËÁÚ˜"êK/Ωdc2¨î’ä+ÚN˜Vùuù‹§]§ëÕÊ«M1Ñâ4π}nÉúÙ9‰ZAéas·ñ[n±Õ~NkëHìœ{ÏÊ_„“]A¨J«^wé&â4)iû~˙iKœJ&¨ZTú$æ
Vaπ‹ÑÕ5i/2D2}ΩÛŒ;éÙµ>˚S‹í∆*&IΩFöE	4UèÍB5i™ÓÉ\è(ˆsúÏ\dÍ:˜‹s-SWZãDö¸{æÿc7ˇóÓ
bU:ˆ∫s4	H§I±HC _ΩíeÊíK.âÊ-r≠ÿ9√Õáÿ:>¿më´PÂÌíˆ"√ﬂ}∆åTöî›añ§±
ìM“ÆïVëFMë\H°F"M~»ˆ»b?«gŒúi&âØ∆œi-iÚÔ˘bè›¸k\∫+àUÈÿÎŒ—$ ë&≈"M'´ÅvsÕÕaù[≠|f's&™E/≤‡=#V¡Y≈˝»4ä4Öh*sÅåÛX)îP#ë¶p£¢ÿœqﬁˇ—'6]îÁÖ#æÒ ƒÜ#^ ÓÏ˘∫í∫ÆQΩ~±«nT9©óX°§c“D@"M Eƒ2/uË–¡vÿai˚?k+Yß¸Ò*Éóí^d¡{@¨Ç≥ä˚ëii
%–êµç ﬁKó.µ!QØ^=≥&8‡Ä‹|`Å¡Y∏√*ﬂRŸı∏œE]Tx<ﬂ{eû_°&Wë&Ãv%˝Z£/FëH≥ë2©Ã◊$T‡ÛØí=ÕAÇ3´‡¨td:H§IπHÉ[ŸìóÊßx4
ƒ,™E/≤‡=#V¡Y≈˝»∑ﬂ~€!¥íe,ÈÇs°ÇÑìÅèâ¡I'ù‰∆>n‹8w˝ı◊õ@≥lŸ2◊Ω{wÆ^Y ¯†câLngûy¶≈+/˙ú}ˆŸõdázÕ†«Ö-‘H§	J>˜„$“‰Œ.ó3±¥fÔŸgü5´kïÏ	húôXg•#”A@"M Eö˛Ûüf÷KπÍ™´Rk“˙Ø˝´,]8í_˛Úóë}ËEºkƒ*8+Öhh˝Áün±°‚›∞aCB∑ªÓ∫ÀÇÀ„u¬	'∏?˝ÈOÆOüKŒ’    IDAT>fÂ2zÙh∆xÜﬁx„çtùÁ'WO;Ì4˚{«é›C=‰v‹q«M~ˇÍ´ØÏà4DºÉnªÌ6◊πsg7yÚd7e Á?√ÖËù0ÖölEöB¥G◊áÄ,i6rîHìˇx“$8C±
ŒJG¶É@Ø^Ω‹à#,€ ?ßΩ§*∑Ôlπ<9€ÅèÉ´}¶Y«îXg•#£O†ê≠'à7Ym|AJ∞¶9Ú»#ÕÂâÚ·á∫˝ˆ€œDöû={∫ªÔæ€ΩÒ∆nˆÏŸ6Å@TyÍ©ßLÏAÃô6möπèr»!ÓÂó_∂à6˛˜ï+WöH√Û˜“K/u}Ùëª˝ˆ€Ì<ÇŸœü?ø†"m
K®ëH˝œO–J§ëHt¨TuúÊ U˙ÈˇbúïéL	Âõˆs*Eüäª~˝˙o çÖ›`QNΩÌ˚E/≤‡#T¨Ç≥“ë—&PhÅ∆∑°+ñ{ÔΩ◊Òn†ÙË—√‹b?˛¯cs%˚‰ìOLp·ôIúW_}’qƒ&–4j‘»Œ˘À_˛b÷47∏”V&“º¬ˇ¬üOé;Ó8≥Ã¡Zß–%°ÜuΩ{˜vªÓ∫´Ya]§Oi$“Ñ5r5	NR¨Ç≥“ëÈ ‡É∑ìÿK‰¥óTä4t˙)ßú‚ñ/_n"bMö
Dö›wﬂΩlQÂˆÎEºwƒ*8+]≈hp]Ωzµ€kØΩ∆˙ıÎ-˛5ÛÊÕs;Ôº≥k◊Æù[¥hë€j´≠Ã≤¶yÛÊ\ã,_∂ﬂ~{;w‚ƒâeV1Uâ4/ΩÙí	9ôÁ:&M˘ﬁŒW®πÈ¶õÃ$Ø~˝˙π=˜‹3∫J5´îÄDâ4a}D4	NR¨Ç≥“ë…'‡ﬂCÃ«ÿ Sq.µ"ç úFkö8Y—!’ã,¯£J¨Ç≥J“ë∏‘‡¶ÉHó.] ö6k÷,wÌµ◊Z Ãj’™≈¢…≈hº∞Ç¿∞xÒba|A0iﬂæΩ={2≥;yëw•cé9∆Mù:’Ìøˇ˛e"±l∞§¡™fßùv≤tæC)ÔÓÙ‚ã/öTÊ˘àAX6√í∆∑3°Êã/æ0+!¨gõn∏·wﬁyÁπvÿ!„Kï¸9â4i¬˙\húdV|6â—Å•¶,Ç≥’ëÒ#@ºX∆ª‚—¸‘w©iÿA≈öÊõoæIï5ç∑¢©Y≥¶Y—D9`∞¶A^dÒ{¶∆bUÆQøÍgü}fñ∏ûêï»[w∞Ä^µjïπ—ƒ°S†Å«ä+Ã¢¸Ûœw˝˚˜w<q„π‡Ç‹¬Ö›/~Òã≤@ødcÚ")z…àGº2A!æ¥n›⁄Ç±ìŒªIì&√Ê‹sœµ	ìl2;e∆§!À˜¶è$‹¢Eã¢ƒ§)?Ç
5^ú!˚)⁄≤aè'S‰ä√XS" ëF"MXüÕAÇì¨åüIﬁá|ß ‡Û¨V	áÄﬂÿ"\◊Æ]s∫®øF„∆ç-Æ]˘åç9]4•'˘¨Nlˆ`E#Ar„@H≠HC„Ω5>pNCπ˘Êõæ~QOªùŸzÈôbúUíé$ê-"o± At Œ	ÒSòÄúu÷Y&ﬁtÎ÷Õ&}m€∂uc«éuµk◊éÜb4æ·$Áúséex¢ \#<‡Ú≥ä,ikò†ù|Ú…&¨¯IÙ¿ÅÕb	k,c(¬„⁄^§Ò◊C<£∞∞Ò•ÅÉ+Í ÑöÚ‚åo;Y∞`Ñ€ìœåô¡§ädE@"ÕF\
Zô’∞©`ÕAÇ3¨àUyqÜE+AÍ˘“¬58€™é‹∞aÉ≈Ö#)¿≈_\’·˛ü9 2˚ÓªØõ4iRl¨ïsjlÅN˙«?˛a±ÌÓøˇ~ªVﬂ<áU6HµH vCﬂˇ}⁄»Wí±¯¬ÙÅ*.E/˝‡=%V¡Y%ÈH¨1∞d¿ÉgV ?˛¯£€gü},"∏vﬁq«f¬w≤ª[%
•h2« È∂∂∂€nª¨Ü∆⁄µkÕ‚fõm∂Ÿ‰ºˇ˚ﬂéâ`U◊„¸m∑›∂‰˝P^®aq¿ÿ¡•	˜,ﬁì¥ëâ)m√o|»ê!ÓƒO¨≤çY’¡E' ëf#râ4˘Ω|Á º∞F<¯‡É≠2˛wÊ≠X8∂i”∆2Òa5:j‘(ãâ5sÊL¬éÖ<õ∏∞by¬ÛäMI~&ãÖÁºy>Ù–C&~\Ûøc—ßO&œ}~¯a‘)X†≥B¡J„\]â3YIú…ÏUu˛≥AÕÊ„`ÿ∞a∂AèP√˚ü12a¬˚ˇ†AÉLºÒÛ#ƒÉò´/-l»∞…Öõπ∑§!˚#„„¯ÉY—˙,éº?…ÊàÎ9ÔU∆Îò1c\≥fÕÃ˙K[6“|¡Zï1Lhä<–e˛éï4÷?Guî[∂lôâ∏∏smÍ }ü¯,pÍ:tËPãØGÃ=‹îi7nÿxì`e]´V-;èc®Ô˜Ãﬂâ€«?◊a^W]uïÕ+±FæÚ +≠=ÃH∏p¿T⁄d»$cû˙#‘¿Â÷[oµFïü§^§yÌµ◊‹ˇ¯G#¬¿ﬂm∑›9>¯ ±0£bC˝çKÒ/≤∏‘7
ı\∞`A™°:Å ¬/G&XvÖ…ÓOL ∞‡‡E¸Ì∑ﬂ⁄öB hû¸KB^ŒXvî¢rfíº˜ﬁ{ª{Óπß,∆K)Ííˆ{z°fã-∂∞ÒÅ®èã,V3,DË'&Ïbï≈dtó]vI;∂ÿ∑_"Õ∆.îHìˇPŒW§¡Åƒ«ÊÚøÛ^„ôÑòÚƒOòxÃBôw±◊Œ8„ÀÆwÙ—G€œ∏`"n‰√;êE-cÎ\è∏`e·cÆåı#ÔKÆÕ∆U¨#<Î‘©c˜a1N}s)∞‚y µº[S.◊—9?¯›Ô~Á}Ù—ü!Ò.·¸„ÚÀ//søÛŒ;]˜Ó›MË@h`≥1aWÊRvåƒDCÊŸlåëíÒÜ–¬x√™Ü±∆&Á *"p0?{Ú…'mÉå±„À¥i”Ã∫ŸíoYõ˘;Ô`‹¨)X Û~¶Æàìàå|nª‹aëy>åYDGÑ¨Æd¯!Êpû∑¢˝ôøssX}ı’Wˆsﬂæ}MÇüòzk6	˝ºÄ(° 
I`ä∏§≤)Å‘ã4‡@!|‰ëGl±¬Bß¸éh‹/5>\Ï(3nÆ]i≤Åi≤g◊3_ÿuÙÈúGéiŸàÿq‰ÂÀnN´V≠Ã-•i”¶÷L^ÏÏƒDI§¡“Ÿ‚çkƒπﬁﬁ¢â6‹-/“‘≠[◊∆ìM\ùÿÅSâ?â4˚P"M˛cπ–"AêX)b¡Ä»ÇêB–vûWÃ,O=ıT«é=ÔBÀ<´ÿàË–°ÉY¿T&“ ∫¸˝Ô∑xaø˛ıØ›ö5kLH¡*ÀH˛é%ü,∏_ç5≤ÜÁEbìa-°í?ÅÕâ4^ËxÏ±«lº˝ˆ€6obmÑ∞¬ALa£à1ƒ1ÅÙ-V5å;6ıHs∞∂¬‚ãﬁeôk0Ê∞6Ò˜ÛÃ‡¡ÉM®¡zôÎ¸˛˜ø7—qàMêLãfD&˛ÔEöÃﬂΩHÉ(¬8dáª1Ì†˛à&ƒZ•X∫tÍ‘…Mü>›⁄A¡]ô1ç%Ôq>K„«è7Ò´¨∆∞§·:¸é•„à6 ¯Ÿc˛»5∏˜’W_mÇ(BÃ;ôãb•C©H§AeSQ¡àüU*& ëÊø\º€é›¡$>t∫åõõSí˙@mÅB¡l}¿`ó›&à≤Ï@2!‡EL·ô¿7*ÓNAÉ◊ä°Æª—≠ Sm&vLTŸ}fÒ√"»ª;±–a◊s&kÏñ)Xb¸GèDâ4aç‚∞E6qQATi‘®ë{·Ö,‡:õèﬁÊôgû1∑ø…;ë˜ãH,(∏Üè9F;Y¸"lŒíK2÷±Ë§~b√ÎÔ6Âya±‡7;≤eXﬁ›â˚x±Ü≈8qh@ØX4Ÿí˝˘Ò^Ëò7oûm4xÀƒ6º;∏èO√f6œ&>÷1~>)wÅÉΩH√X@a|Ú>≠(–3◊C DÑ·X∆`˘D§Òc·(S§al#Æ 6!.·&à‡Ñ≈4‚mÒÎ‹™`RëH√\ëœÔ¸/ø¸≤Ï<ò4h–¿>gÂãw#Àø◊tâ4ˇò¶!‘†@˙≈MÜfuÏ§3Ò∆Ïç› Å‰`Ç Mfömv˜òL≤ã√Œ/b¸ÑÒfG—∆Ô(EÖÑÑg;XA‚ÿÑ›gï≈ÚÅÉY»≥ÄX≤dâôE≥É»N;jq»6≥$]O"çDö∞∆sæ"Ç
n&~CÅ Ïƒî©ÃÚ1ô›{2ÏPMx6aQL}LäkbÓSà-,d}XÄÓ¥”NÊí¡F&n≤˙ DjÒ,Æq¬Ω≈/‰±NgkÑÍ’´gçpsÅÉ%÷dç≤ Xˇ∞ˇ¸Ûœ€C¶∏ÅãÙﬁ:Öãa=Ç5c	ó ~FË√Mà∏5ã/6+,FpÖcL!®Ò◊:?∆%˜cﬁ≈˚˝–CµXoôñ2Â+œıßﬁí∆_ãﬂΩ%¢ÆKâ4¨cóƒ c.à•˜Gh§Ã±¶·3Ü5Çñ3º◊q%D§dlÚ?D>pÿzÎ≠ÌsÄh ÁK>GX“`}ˆÈßüZf&ƒD/ï¸	H§…`H`DÑ
;–)Ñ˘#/ﬁ¯0±Ä£!óAÒÿÎN"P,º(¯·jÁãx~Òbe∑É]#|¶˝n";'ÏÆ∞”•G°Ü\&ˆàaŸîÚÁ±¿`˜ñ¬éª]~°íÕu≥=6h–Êäƒ&§ƒtS\öl©GÎxâ4˚CÓN˘èÀ|EïƒΩ¿ıÅÑXUYæ “SrÍ‘©∂–dÒL`s¨E˝"îÖ¯å3ÏzlP º∞Y¡¬ö∏2∏@Ñ≈-Î üúèãnì'O∂Ö9÷:à’ƒ|cëL›rµH≠*w¶X£‹˘çM/fn%∏-B
Ômƒ‚´ÒŸ«b¡Å8∏8!¿¶Ô	P›∫uká;’E]dbÛ,,KXÆ0ß¬-AπÊÕõ€G(DÏ‡åü D˛O}´dÁ$÷%®HCªp}b»ÁÇµ˜•ﬁà4X¡0ŒyS?Ê¥ç˜¿}˜›g\$˝ˇ<XÑﬂaÉ∏Éò	¨o±⁄A`Ú÷J˘ıòŒÜÄDör„ so&≠‚≈ò$b(f
4<‹Ω`!Ó•käÄƒÉ ÒkÿâBFßÕãõP√§åEE∂¡#3œ√⁄ëæÍ>æ¶÷L,i•T†…Ï+/÷é¡óKö§≈qã«ß9ºZJ§Ÿ»íÖÅ=YÏ#j´dO _ë∑]¨Up≠‡Y»Ç1àHÉ5)Ò9èÁìX∞g°JaÅÕ"ù/ﬁ3S¶LqXÍxÅéM66XL”ˇKó.µˇ1á∆öÇ≈;ÌX»S|ˆƒ\cja≈gì†™,ÄÂˆî˝xÃ<+‚»P1à-É∏Ä¬ÿA ÙÆ@¸üx•0ßﬂây‰«„áµ"„”«n¡‚Ñç~,r∞¬A¿¿ÇÀ0
Ôq¨j8|=6ÁÓÑB#Ç˜‚æå9,√®V0æﬁƒdÚ;b£‰À{ëìÛ}∞§ˆ‚ıÒíó/_nnWÃ=Z∂liueÓÅàÉ CªpÑánçÂ}X∑1w·ÛÊ]°‡Ñµ¿¸FNÈŒñHS˚L°&éÆOﬁ≈…ø\$–îÓ¶;ãÄdO†XB¶π¯˝„ Ó*ì≤m¯LL∏å9<ìvNô®∞ÎƒdÑ‚3-∞≈‰åâ?Á1ia2Éo;Ôò«„oŒ¬¿g⁄‚<6∏>úDvÑô±sUàíã@ìYLºq£≈§Z%ﬁ$“lÏ?ûXSêèÖÜJˆÇAÆ∫vÌ⁄M‚TvIû≠,fI•L∞“Ã¬ﬂ(ÂˇŒﬂ*s1•<ﬂ ã–\èÖ;AÑÛ)a± ßi;W,è+∞®¨o9∏l˙ùs]àeì≠pëÌ¶öèë„c“0óA ºoe„ùˇ—æÕ±°>îÚÌá'.Vl j√&‹OîDöÕÃjPFQ‡£>¯¯Ä≤–`≤OëM∏]MD†xä!‘xhvé∞daóã]*v¡ÿ∫˛˙ÎÕLszvûpGBHa7ïx?Ïl·nÜI<ÓfÏ¿≤ªF6‚ ‰Ãù;◊|¿Ÿ•„wvÔÖ‰Áœ#–†/<«1ofÅ@∂íBX=Â+–oËN≈  ëf#eû9|6‰Zí˚®+ÖÄï	¡XâπßR
Vq‚£∫fG¿g˙$cfå¬ÏÆ¢££D@"M%ΩÅÈæä(ÑÏft
ÛØ(‚¯›üùC1h¢ÿS™ìà@PÖj|f,üùmÇÎa^_≠Z5ák1}0É«?wRFbYCÄ_≤%‡ﬂM‡yb`2M<,cÿë#H!qXcRM@=üÅ$Û<œÉ›Y¸◊v0?.Ñyªö†£/=«I§ëH÷h/Ö¿¸ó¿øqVZ
Vaı≥ÆMƒMbÓ¬fìJ¸	H§©¢ô|k ¡Ü¬n*_Q*Ï∂ÚEAò!˝ô≤8E©áTÅ\	R®!˛±H≠â•§O}YæÆà6?˛¯£≈ˆ¬ç	b‹îŒ8„«}˙WLÖâ@@>_8tD~Rz˜”ÃÛ¸±‘ãﬁ7Öÿê@ìÎ(Lˆyi$“Ñ5¬%<')V¡YÈHH#â4{ù RÏ|R∞™¡‰Ω‘™=£à?É/.Ö8
~ó6`≥tòàÄDû@°ÑD‚»∞H›rÀ-MpA|¡ΩâÇeªRà3ƒü¡•	wX˘aÅC=K“S‚
Ö◊'˚◊Á˘å‡OúJfﬂd·"”Bˇ˛˝≥ˆ_Ø™%–TE(ΩˇóH#ë&¨—/·!8I±
ŒJGä@	H§…¢◊1?G¨ÒV5à4X’[¨Aú¡rÜÔ¨ggÿÅUÅ$(ÑPÉàB¸Ri"“º˝ˆ€e1e»tÄ0Oñì¡Éò_Ù§Í‰ªixòØ◊^{≠•d≈¸ûlƒ#ÆnRÂEûOaç 4{ˆls´"_XEMX$ìyâ4i¬ŸÇì´‡¨t§§ëÄDözù‘~§;#VëÜÏ.TpaÇI2Ÿ'›ôgà=CÃLËUD@D È¬j [“¿ÎD≈S2”fb1sÚ…'ó!Ê8“y˙ÙŸÊom⁄¥)K›z›u◊Y`a‹©.ø¸r≥≤Òñ4ôÁÒ3~‰à>«{¨}+´ìö§*ÚoüDâ4˘è¢çWêú§Xg•#E ç$“‰ÿÎ§6cbÉXCûy_kmÿuÕwíç	=;∏à2L‚}!‚ôHXD®àÄà@ZÑ-‘TƒçTîX¬îOõI™I2(ê¢23Îß ¥P»ÃT˛òäÓS˛º∞˚PMÿDìy=â4i¬ŸÇì´‡¨t§§ëÄDözù¯Lrû{ÓπMÆÜHÉ`CÜÑï5j∏vÿ·g‚bÃö5klQÄ‡Ûè¸√Ñk∆_îVÑx2Ñ™Î" ";≈jb•\Ö%–ƒΩãWâ4i¬mÇì´‡¨t§§ëÄDö{Îb◊Â›°rΩÓLƒô·aFV3πí‘y" I# °fÛ=*Å&i£Ω∞ÌëH#ë&¨&·!8I±
ŒJGä@	H§)`Ø`òúıX«áü3›£∏=V6|!¬êÑü˘N@`H#‚p›yÁùÆgœûõ∏e≤êPÛÛë!Å&çüñ¸⁄,ëF"M~#Ëß≥%<')V¡YÈHH#â4iÏuµYD@"L‡˚Ôøwù;w∂t‘|5jîÑö ˝%Å& $Ú3i$“Ñı±êú§Xg•#E ç$“§±◊’fà(ÅLÅf¸¯Ònÿ∞anﬂ}˜5¡&3XofıeQ„úöàËTK"çDö∞Ü©Ñá‡$≈*8+)i$ ë&çΩÆ6ãÄà@	 –tÍ‘…˝ıØusÊÃq-[∂¥ ÍL'p˙à#‹[lQaÕ”,‘‰"–ê¡™zıÍõÂ¡·°*àÄDâ4a-	¡IäUpV:R“H@"M{]mÅà»¥†°jCÜqW\qÖâ~¯°€oø˝‹oº·9‰êÕ÷<çBM.¨æn∫È&◊¥i”àçUßÿ$“H§	kÃy·!¨Î•·:,HC3’FÅ,	H§…òó¿wﬂ}Á∫vÌZfA”∏qc∑ÎÆª∫Å∫~˝˙π3f∏”O?›Õü?ﬂUµHìPìã@Cœ˝Á?ˇq\pÅ€∞aÉπëmπÂñ·v®Æ+i6v◊–°C]ˇ˛˝›5◊\„xé®dO†™ÁsˆWL˛iíﬂ«j°‰B@"M.‘téàÄà@h>˚Ï3∑Áû{∫È”ßª6m⁄îâc«é-ª«YgùUi\öÃ §A®…U†Òúﬁ{Ô=◊∞aC∑h—"w‡ÅÜ÷ó∫P¸H§Ÿÿg„∆çsgü}∂π\ﬁˇ˝ÒÎH’XD@D 1$“$¶+’à/ÅuÎ÷π5jXHø›§I7h– ˚æzıjss ∆‚#…BM.Õ⁄µk›Ò«Ôé<ÚH◊∑o_≈z˜ÓÌ~¸ÒGãı£í^i6ˆΩ8§˜3†ñãÄà@‘H§âZè®>" "êr¸±´_øæ{Í©ß‹)ßúb4ÊÕõÁj÷¨Èö5kH∞I¢Pìã@?D0°}˙ÙqÔºÛéª¸ÚÀ›—Gm|?˘‰mT“I@‚ÑDöté|µZD@¢K@"Mt˚F5ÅTò5kñk›∫µ[∏p°k‘®ë{˝ı◊Õ¢∆ƒÖô3g∫≠∑ﬁ∫J>IjrhﬁzÎ-◊≥gO≥Nö<y≤´U´ñ#¬‡¡É›§Iìåﬂu◊]ÁÆºÚ *YÍÄdêH#ë&ô#[≠Å¯êHﬂæSÕE@D ëàQC  >¯¿ë*°ÊÀ/ø4ê8¿uÈ“≈µh—¬Çﬂ)Ijrh˛ˆ∑øπ√;Ã›yÁùnè=ˆ(≥JÚÃ>˙Ë#7|¯p7a¬ƒvŸeó 8uL¬H§ëHì∞!≠ÊàÄà@Ï	H§â}™" "ê<_˝µ€q«›£è>ÍÆ∫Í*˜ÿcèπSO=’Ω¸ÚÀn‘®QøÊœ˛s‡Ü«Y®	*–d∆ıL∑n›‹¡Ï.π‰í2Nc∆å17'RöS÷¨Ycúq%S:Ó¿√)QJ§ëHì®≠∆àÄà@H§I@'™	" "êT'Ntw›uó{ˆŸg› ï+À¨jﬁ|ÛM ≤)qjÇ
4Ôæ˚ÆeiZ∫t©≈Û!Õ6±ˆ⁄k/w„ç7¶ÃÄÃ:t∞ø·Út—EYñßùwﬁ9ú:6!$“H§I»PV3D@D 1$“$¶+’HÅÔæ˚Œ,<Œ<ÛLw¯·áª˝˜ﬂﬂ‹wÜÍ∞
È⁄µ´Î—£á	€l≥Mï ‚$‘hh41Xù~˙È&fa)3e ◊Æ];wﬂ}˜πŒù;ª+V∏ﬂ¸Ê7nŒú9&vQû{Ó9g¸ÔU‘â# ëF"M‚µ$" 1' ë&Ê®ÍãÄà@“	‡˙tÕ5◊∏Ò„«õªñ"ﬂ~˚≠€gü}LÄ@|∏ı÷[÷5[mµUï8‚ ‘hzË!WΩzu±(˝˚˜7ÎïW^q6t∑‹rãªÏ≤À ò6Ã~ﬂbã-™‰§“A@"çDötåtµRD@‚C@"M|˙J5Å‘¯˛˚Ô-≥S´V≠\€∂m-æ
Ç∆q«g‚ÉOŸ]®(5A\öÜbôô∞¢¡Ö	ó¶é;∫ÁüæL®!‡2ÅÅ	∫ú≠ãXUıˇ¯êH#ë&˛£X-ÅdêHì¨˛TkD@D —ºi∫ø˘Ê◊¨Y37˛|À˛ÑMõ6mBn<∏Fë’hs%äBMPÅ&≥MﬁZ¶2°&—ÉBçÀãÄDâ4y ù," ":â4°#’E@D@
I‡¬/4öÛœ?ﬂ‹|~˘À_ö€ñ%}˚ˆuSßNµt›”ßO7—¶≤%°&Å∆∑msBqi|0·BˆâÆ_i$“ƒwÙ™Ê" "êLiíŸØjïàÄ$ñ¿W_}Âé:Í(w“I'πgûy∆Çﬁ>ÒƒgÂ‚ã/vwﬂ}∑≈∞AÄ	R¢ ‘‰*–¨_øﬁmΩı÷÷ÃÚBAó|A◊•KW≠Zµ (tL
	H§ëHì¬aØ&ãÄà@§	H§ât˜®r" " ôåH!Ω”N;π>}˙∏·√áªx¿b¥<Ú»#ÆFçÅ ñR®…E†yÎ≠∑,ìV2ƒÊ=z¥´[∑nôP3n‹∏≤`¬Å Ë†‘H≥HÛÒ«ª7ﬁx√ùv⁄iÆ<˛G Ó#è<“ÌΩ˜ﬁ©j∏àÄà@Ò	H§)>s›QD@D D∏9yÅfÓ‹πÆEãvıè>˙»‚÷4n‹8P6£R5π4~¯°•ÿFÑ⁄m∑›Ãz±j—¢EñNõ`¬dæÚüBD≠K%ê@öEö~˝˙ô[$÷w›nŸ≤•;ˆÿcM∞·y@Fπ+Æ∏¬\+UD@D@D†X$“ã¥Ó#" "PF^K  mIDATƒ†¡ıâÙ‹Ïz˚r€m∑πû={∫O<—Mò0¡’¨Y≥ ˚S®…E†°Ω{˜vµj’rW]uïµáÂø˝Ìo-ªÇçädC Ì"Õ7‹`ñ4|Æh¯∫ˇ˛˚M∞Y±bÖõ4ií;·Ñ≤A™cE@D@D /iÚ¬ßìE@D@JM¿[ñ<˝Ù”∂òzÍ©ßlWúÖ◊∂€nÎlV&ƒgŸrÀ-´¨n1Ñö†È¥k◊Æmqx(N&∆Ã=˜‹S÷ñn›∫π∏?ˇ˘œU∂Oà@&Å4ã4∏4y1f‘®QÆSßNÊ⁄ƒw>£∏Ôjõm∂—†Å¢êHS4‘∫ëàÄà@°º˜ﬁ{nªÌ∂3A„úsŒq=zÙ∞›3fXJn,mXêª&H)§PT†y˜›w›ÅXV›´Øæ⁄\0fœûÌZ∑nmÓN∏4}˛˘ÁÓ˛Á‹ò1cÃ
@E≤!êfëN|¶¯L"Nõ6Õ–!‘»ä&õQ§cE@D@¬$ ë&Lö∫ñàÄà@I	å1¬væü}ˆYg:vÏËû|ÚI≥0πÈ¶õ,61l¯^U)ÑPì≠@s˝ı◊ªÓ›ªªø˛ıØÓíK.q.¥lV7ﬂ|≥≈·ÒÂé;Óê´SU™ˇWH Ì"M¶5xæ»äFÅRêHS*Ú∫ØàÄà@ËHœçU	±YÍ‘©„˛¯«?∫vÌ⁄9\p"(Æ◊^{m†{á)‘h^˝u◊§Ió)º∞ê¨_øæõ?æ≈ü°êŸÈ”O?u{Ìµó˝OEr!êvëfﬁö∆Û„°X4πå&ù#" "â4aP‘5D@D@"C‡á~p3gŒ¥Ä¡Xü‹zÎ≠ãw°ÎÆªŒÌ∫ÎÆfÖÇÖJ±Ç	hÄH›€¥ic±gFéi‚Ìò5kñY“TØ^=2¨Uë¯êH„Ãíÿ4|ßÄ.äEˇÒ≠àÄà@	H§âcØ©Œ" " ïÿ∞aCô@√BÀ4£Gè∂∏-Ì€∑w}˚ˆµÖBH´V≠‹Ò«øŸkÊcQìç@„+‹sœôE©	¸óø¸≈Ω˘Êõñr[E¬$ ëf#Õ°Cá∫˛˝˚€œ|ﬁîv;ÃQ¶kâÄàÄdC@"M6¥t¨àÄà@¨óß·√áª9sÊò(CYø~ΩπBç;÷’´WœÕù;◊ÇÖVVrjrh 5¸æd…∑œ>˚ƒäΩ*i6ˆÅÇ±æ£”j«wåG™ñ" " â# ë&q]™âÄàÄx≈BK\à|!µ5ôëp-¬ïàÄ√aßÁŒG†ÒıÙhvıÔΩ˜^∑’V[©sE T•iû~˙i7yÚ‰P€∆≈ﬁˇ}ªÃ˛˚Ô∆ÂBΩ±µN9ÂîPØ©ãâÄàÄDìÄDöhˆãj%" "P 4∏}ÛÕ7ñ	Í≈_t]ªvµÿ/AJãö0_Ô˙ƒ.ˇ„è?Æ8A:I«&P
ëÊû{Óq|E≠œäÙYPÃ˙wÎ÷ÕÒ•"" "ê|iíﬂ«j°àÄà¿	|˜›w&–,_æ‹2%Â„•2°&LÅ∆wAÉ˘"%wê`Ò%PJëF÷!Uèou$ë¶jV:BD@íB@"MRzRÌ®í¿ƒâ-kAxÛM[]ëPSÅ¶ FÈ »É@)E	Uwú∑:´™YÈH
â4IÈIµCD@D†Jk◊ÆuMõ6uΩzı2ß|K¶P”§IK€KZoVQåkëo{u~ÚH§âvüJ§âvˇ®v" "Pi
AU◊à,ÅuÎ÷Y›j‘®JΩP√≈$–ÑÇT)"â4EÑù√≠$“‰ MßàÄà@Ã	H§ây™˙" " •'ÄP√bW4•Ô’ ;i≤„UÏ£%“õ∏Ó'" •' ë¶Ù}†àÄàÄ$Ä¿≤eÀ\ù:u–5!M$“Dª∑%“DªT;(â4Ö†™käÄàÄàÄà@H§âv'I§âvˇ®v" "Pi
AU◊ÅêHÌNíHÌ˛QÌD@D†$“Ç™Æ)" " " 1  ë&⁄ù$ë&⁄˝£⁄âÄà@!H§)U]SD@D@D@b@@"M¥;I"M¥˚GµÅBêHS™∫¶àÄàÄàÄƒÄÄDöhwíDöh˜èj'" Ö  ë¶TuMàÅ’´WªZµjπùv⁄…≠Zµ™(5ñ≥Xg•#E@D )$“$•'’»Å¿æ˚ÓÎñ.]Íñ,Y‚ˆŸgüÆê›)ÇÛ´‡¨t§àÄ$ÖÄDö§Ù§⁄!" " " 9Ë–°Éõ4iíªÎÆª\˜Ó›s∏BvßHxŒK¨Ç≥“ë" "êií“ìjáàÄàÄàÄ‰@‡â'ûpßü~∫˚Õo~„^x·∑›v€Âpï‡ß[xXø~Ω˚˛˚Ô›÷[oÌ∂⁄j´
+˙√?∏˝Î_ÆZµjnõm∂	ﬁòYlVné./" "ÄÄDö êtààÄàÄàÄ$ï¿⁄µk]ã-‹{ÔΩÁzÙË·ÆΩˆ⁄Ç
5≈gnºÒFwı’Wóu›ê!C\ÔﬁΩM∞ÒÂ±«s;v,˚˝˜øˇΩªÂñ[\›∫uM∏9Êòc‹'ü|‚.\ËvŸeó≤„ÊÕõÁö7oÓÊœüÔ~˚€ﬂdxãUA*ØãäÄàÄ‰D@"MNÿtíàÄàÄàÄ$á¿ú9s\˚ˆÌMº@∞@®©]ªvAX·a√ÜÆeÀñÆfÕönƒàn∑›vsü˛πª‡ÇÃRfÊÃô÷÷°Cáö Û¯„èªFçπ5k÷∏ë#G∫1c∆∏◊^{Õ*7m⁄‘Ωı÷[n⁄¥iÆm€∂eL.ΩÙRw˚Ì∑ª∏&MöƒñUA*ÆãäÄàÄ‰L@"MŒËt¢àÄàÄàÄ$É ¢¬ñ'+WÆtávò;‚à#\≥fÕ,ò0.Pa.ÜH3uÍT◊≠[7˜˛˚Ôª5jîu“◊_mV/ƒﬂAîŸcè=ÃBÜü}˘œ˛„∞¶°ΩàU0ÔºÛé˚ﬂˇ˝_˜‡É∫-∑‹“˘ÎpYñ4…¯®" "i¢“™áàÄàÄàÄîê nO/ΩÙíª˚Óª›¨Y≥Ã“köÌ∑ﬂﬁbπ=åÚŸgüπoø˝÷ıÎ◊œÑîBîAÉ9Ñ'DñÚÖ{6h–¿ƒ~^¥h—œb’‡Öbb’¿Å]ﬂæ}›ÎØøn.O¸}Ú‰…Î¶Kó.Ó√/D3\1≠ÇT\»ôÄDöú—ÈDHÑç?¸–-^ºÿÕù;◊‹|æ¯‚U∞	´Ïæ˚ÓÓˇ˛Ôˇ
&“w¶a√Ü^ˇ¬/4K°zıÍπ—£G;'cìY&Núh÷6S¶Lqtê{Ù—GÕ ≤aµk◊ŒıÔﬂﬂç;÷uÌ⁄U"MXC◊pi4D@D@D@D@6!ÄXÛÂó_∫U´VπuÎ÷ô≈ñ6a¨Pû}ˆYR\(K‚ º˚ÓªfìYpe:Î¨≥,0±f]8Óø¯≈&«=¸√n‘®Qf1s¡ª'ü|“b⁄p›˚Óªœ‹£>˛¯c´?±idI∆»–5D@D@  ëF„@D@D@D@D†hä·¬Éª/∏2w∆¨Ñˆ€o?Gf&˛ŒW˘Ä¿dt:Ú»#›yÁùÁ.æ¯bdp⁄sœ=›ﬁ{ÔÌ.π‰≥,B :˚Ï≥›eó]&ë¶h£G7Å‰êHì¸>VE@D@D@D 2ä!“¯‡ø∏l=˝Ù”ÉÜ‡øßùvö;˛¯„›<‡™U´f¡íqö0aÇ˝Î°sœ=◊-_æ‹\Ω:åH3~¸x Lv(\úà›s‘QGπ3œ<”ıÈ”G"MdFó*"" Ò' ë&˛}®àÄàÄàÄà@lC§∆wﬂ}ÁÜÊÆπÊö26CÜqΩzı≤4‹æå7Œ,b|È‹π≥Æ[∑ÆÛV5ƒÆ!–3œ<cnZoæ˘¶•˜ñ%MlÜù**" ±! ë&6]•ääÄàÄàÄà@¸	K§Ò§÷Ø_o1u»VEñ™ä ?¸`Ç÷5ôN©iõU©€´˚ãÄàÄ(&ç∆ÄàÄàÄàÄà@	Hx[¨Ç≥“ë" "ê≤§IJO™" " " "ÇwíXg•#E@D )$“$•'’à	¡;I¨Ç≥“ë" "êií“ìjáàÄàÄàÄƒÄÄÑá‡ù$V¡YÈHH
â4IÈIµCD@D@D@b@@¬CN´‡¨t§àÄ$ÖÄDö§Ù§⁄!" " " 1  ·!x'âUpV:RD@íB@"MRzRÌÅêºìƒ*8+)" I! ë&)=©vàÄàÄàÄà@HxﬁIbúïéÅ§êHìîûT;D@D@D@D $<Ô$±
ŒJGäÄà@RH§IJO™" " " "ÇwíXg•#E@D )$“$•'’à	¡;I¨Ç≥“ë" "êií“ìjáàÄàÄàÄƒÄÄÑá‡ù$V¡YÈHH
â4IÈIµCD@D@D@b@@¬CN´‡¨t§àÄ$ÖÄDö§Ù§⁄!" " " 1 ‡Öá:uÍ∏›wﬂ=5.]ó/_Óñ-[Ê∫uÎf_*" " …' ë&˘}¨äÄàÄàÄà@dxë&2äAE$“ƒ†ìTEâÄDöê@Í2" " " " U¿2ï‡∞8¬ÚHED@D ˘$“$øè’BÅêHÉNRE@D@D@D@D@D@D@íO@"MÚ˚X-àâ41Ë$UQD@D@D@D@D@D@D ˘$“$øè’BÅêHÉNRE@D@D@D@D@D@D@íO@"MÚ˚X-àâ41Ë$UQD@D@D@D@D@D@D ˘$“$øè’BÅêHÉNRE@D@D@D@D@D@D@íO@"MÚ˚X-àâ41Ë$UQD@D@D@D@D@D@D ˘$“$øè’BÅêHÉNRE@D@D@D@D@D@D@íO@"MÚ˚X-àâ41Ë$UQD@D@D@D@D@D@D ˘$“$øè’BÅêHÉNRE@D@D@D@D@D@D@íO‡ˇäQvﬂŒô™    IENDÆB`Ç                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              go/src/github.com/docker/docker/docs/reference/api/index.md                                         0100644 0000000 0000000 00000000336 13101060260 022275  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/api/
description: Reference
keywords:
- Engine
title: API reference
---

* [Docker Remote API](docker_remote_api.md)
* [Docker Remote API client libraries](remote_api_client_libraries.md)
                                                                                                                                                                                                                                                                                                  go/src/github.com/docker/docker/docs/reference/api/remote_api_client_libraries.md                   0100644 0000000 0000000 00000011741 13101060260 026706  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/api/remote_api_client_libraries/
description: Various client libraries available to use with the Docker remote API
keywords:
- API, Docker, index, registry, REST, documentation, clients, C#, Erlang, Go, Groovy, Java, JavaScript, Perl, PHP, Python, Ruby, Rust,  Scala
title: Docker Remote API client libraries
---

These libraries make it easier to build applications on top of the Docker
Remote API with various programming languages. They have not been tested by the
Docker maintainers for compatibility, so if you run into any issues, file them
with the library maintainers.

<table border="1" class="docutils">
  <colgroup>
    <col width="29%">
    <col width="23%">
    <col width="48%">
  </colgroup>
  <thead valign="bottom">
    <tr>
      <th class="head">Language/Framework</th>
      <th class="head">Name</th>
      <th class="head">Repository</th>
    </tr>
  </thead>
  <tbody valign = "top">
    <tr>
      <td>C#</td>
      <td>Docker.DotNet</td>
      <td><a class="reference external" href="https://github.com/ahmetalpbalkan/Docker.DotNet">https://github.com/ahmetalpbalkan/Docker.DotNet</a></td>
    </tr>
    <tr>
      <td>C++</td>
      <td>lasote/docker_client</td>
      <td><a class="reference external" href="https://github.com/lasote/docker_client">https://github.com/lasote/docker_client</a></td>
    </tr>
    <tr>
      <td>Erlang</td>
      <td>erldocker</td>
      <td><a class="reference external" href="https://github.com/proger/erldocker">https://github.com/proger/erldocker</a></td>
    </tr>
    <tr>
      <td>Dart</td>
      <td>bwu_docker</td>
      <td><a class="reference external" href="https://github.com/bwu-dart/bwu_docker">https://github.com/bwu-dart/bwu_docker</a></td>
    </tr>
    <tr>
      <td>Go</td>
      <td>Docker Go client</td>
      <td><a class="reference external" href="https://godoc.org/github.com/docker/docker/client">https://godoc.org/github.com/docker/docker/client</a></td>
    </tr>
    <tr>
      <td>Gradle</td>
      <td>gradle-docker-plugin</td>
      <td><a class="reference external" href="https://github.com/gesellix/gradle-docker-plugin">https://github.com/gesellix/gradle-docker-plugin</a></td>
    </tr>
    <tr>
      <td>Groovy</td>
      <td>docker-client</td>
      <td><a class="reference external" href="https://github.com/gesellix/docker-client">https://github.com/gesellix/docker-client</a></td>
    </tr>
    <tr>
      <td>Haskell</td>
      <td>docker-hs</td>
      <td><a class="reference external" href="https://github.com/denibertovic/docker-hs">https://github.com/denibertovic/docker-hs</a></td>
    </tr>
    <tr>
      <td>HTML (Web Components)</td>
      <td>docker-elements</td>
      <td><a class="reference external" href="https://github.com/kapalhq/docker-elements">https://github.com/kapalhq/docker-elements</a></td>
    </tr>
    <tr>
      <td>Java</td>
      <td>docker-java</td>
      <td><a class="reference external" href="https://github.com/docker-java/docker-java">https://github.com/docker-java/docker-java</a></td>
    </tr>
    <tr>
      <td>Java</td>
      <td>docker-client</td>
      <td><a class="reference external" href="https://github.com/spotify/docker-client">https://github.com/spotify/docker-client</a></td>
    </tr>
    <tr>
      <td>NodeJS</td>
      <td>dockerode</td>
      <td><a class="reference external" href="https://github.com/apocas/dockerode">https://github.com/apocas/dockerode</a></td>
    </tr>
    <tr>
      <td>Perl</td>
      <td>Eixo::Docker</td>
      <td><a class="reference external" href="https://github.com/alambike/eixo-docker">https://github.com/alambike/eixo-docker</a></td>
    </tr>
    <tr>
      <td>PHP</td>
      <td>Docker-PHP</td>
      <td><a class="reference external" href="https://github.com/docker-php/docker-php">https://github.com/docker-php/docker-php</a></td>
    </tr>
    <tr>
      <td>Python</td>
      <td>docker-py</td>
      <td><a class="reference external" href="https://github.com/docker/docker-py">https://github.com/docker/docker-py</a></td>
    </tr>
    <tr>
      <td>Ruby</td>
      <td>docker-api</td>
      <td><a class="reference external" href="https://github.com/swipely/docker-api">https://github.com/swipely/docker-api</a></td>
    </tr>
    <tr>
      <td>Rust</td>
      <td>docker-rust</td>
      <td><a class="reference external" href="https://github.com/abh1nav/docker-rust">https://github.com/abh1nav/docker-rust</a></td>
    </tr>
    <tr>
      <td>Rust</td>
      <td>shiplift</td>
      <td><a class="reference external" href="https://github.com/softprops/shiplift">https://github.com/softprops/shiplift</a></td>
    </tr>
    <tr>
      <td>Scala</td>
      <td>tugboat</td>
      <td><a class="reference external" href="https://github.com/softprops/tugboat">https://github.com/softprops/tugboat</a></td>
    </tr>
    <tr>
      <td>Scala</td>
      <td>reactive-docker</td>
      <td><a class="reference external" href="https://github.com/almoehi/reactive-docker">https://github.com/almoehi/reactive-docker</a></td>
    </tr>
  </tbody>
</table>
                               go/src/github.com/docker/docker/docs/reference/builder.md                                           0100644 0000000 0000000 00000175745 13101060260 022064  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/builder/
description: Dockerfiles use a simple DSL which allows you to automate the steps you would normally manually take to create an image.
keywords:
- builder, docker, Dockerfile, automation,  image creation
title: Dockerfile reference
---

Docker can build images automatically by reading the instructions from a
`Dockerfile`. A `Dockerfile` is a text document that contains all the commands a
user could call on the command line to assemble an image. Using `docker build`
users can create an automated build that executes several command-line
instructions in succession.

This page describes the commands you can use in a `Dockerfile`. When you are
done reading this page, refer to the [`Dockerfile` Best
Practices](../userguide/eng-image/dockerfile_best-practices.md) for a tip-oriented guide.

## Usage

The [`docker build`](commandline/build.md) command builds an image from
a `Dockerfile` and a *context*. The build's context is the files at a specified
location `PATH` or `URL`. The `PATH` is a directory on your local filesystem.
The `URL` is a Git repository location.

A context is processed recursively. So, a `PATH` includes any subdirectories and
the `URL` includes the repository and its submodules. A simple build command
that uses the current directory as context:

    $ docker build .
    Sending build context to Docker daemon  6.51 MB
    ...

The build is run by the Docker daemon, not by the CLI. The first thing a build
process does is send the entire context (recursively) to the daemon.  In most
cases, it's best to start with an empty directory as context and keep your
Dockerfile in that directory. Add only the files needed for building the
Dockerfile.

>**Warning**: Do not use your root directory, `/`, as the `PATH` as it causes
>the build to transfer the entire contents of your hard drive to the Docker
>daemon.

To use a file in the build context, the `Dockerfile` refers to the file specified
in an instruction, for example,  a `COPY` instruction. To increase the build's
performance, exclude files and directories by adding a `.dockerignore` file to
the context directory.  For information about how to [create a `.dockerignore`
file](builder.md#dockerignore-file) see the documentation on this page.

Traditionally, the `Dockerfile` is called `Dockerfile` and located in the root
of the context. You use the `-f` flag with `docker build` to point to a Dockerfile
anywhere in your file system.

    $ docker build -f /path/to/a/Dockerfile .

You can specify a repository and tag at which to save the new image if
the build succeeds:

    $ docker build -t shykes/myapp .

To tag the image into multiple repositories after the build,
add multiple `-t` parameters when you run the `build` command:

    $ docker build -t shykes/myapp:1.0.2 -t shykes/myapp:latest .

The Docker daemon runs the instructions in the `Dockerfile` one-by-one,
committing the result of each instruction
to a new image if necessary, before finally outputting the ID of your
new image. The Docker daemon will automatically clean up the context you
sent.

Note that each instruction is run independently, and causes a new image
to be created - so `RUN cd /tmp` will not have any effect on the next
instructions.

Whenever possible, Docker will re-use the intermediate images (cache),
to accelerate the `docker build` process significantly. This is indicated by
the `Using cache` message in the console output.
(For more information, see the [Build cache section](../userguide/eng-image/dockerfile_best-practices.md#build-cache)) in the
`Dockerfile` best practices guide:

    $ docker build -t svendowideit/ambassador .
    Sending build context to Docker daemon 15.36 kB
    Step 1 : FROM alpine:3.2
     ---> 31f630c65071
    Step 2 : MAINTAINER SvenDowideit@home.org.au
     ---> Using cache
     ---> 2a1c91448f5f
    Step 3 : RUN apk update &&      apk add socat &&        rm -r /var/cache/
     ---> Using cache
     ---> 21ed6e7fbb73
    Step 4 : CMD env | grep _TCP= | (sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/socat -t 100000000 TCP4-LISTEN:\1,fork,reuseaddr TCP4:\2:\3 \&/' && echo wait) | sh
     ---> Using cache
     ---> 7ea8aef582cc
    Successfully built 7ea8aef582cc

When you're done with your build, you're ready to look into [*Pushing a
repository to its registry*](../tutorials/dockerrepos.md#contributing-to-docker-hub).

## Format

Here is the format of the `Dockerfile`:

```Dockerfile
# Comment
INSTRUCTION arguments
```

The instruction is not case-sensitive. However, convention is for them to
be UPPERCASE to distinguish them from arguments more easily.


Docker runs instructions in a `Dockerfile` in order. **The first
instruction must be \`FROM\`** in order to specify the [*Base
Image*](glossary.md#base-image) from which you are building.

Docker treats lines that *begin* with `#` as a comment, unless the line is
a valid [parser directive](builder.md#parser-directives). A `#` marker anywhere
else in a line is treated as an argument. This allows statements like:

```Dockerfile
# Comment
RUN echo 'we are running some # of cool things'
```

Line continuation characters are not supported in comments.

## Parser directives

Parser directives are optional, and affect the way in which subsequent lines
in a `Dockerfile` are handled. Parser directives do not add layers to the build,
and will not be shown as a build step. Parser directives are written as a
special type of comment in the form `# directive=value`. A single directive
may only be used once.

Once a comment, empty line or builder instruction has been processed, Docker
no longer looks for parser directives. Instead it treats anything formatted
as a parser directive as a comment and does not attempt to validate if it might
be a parser directive. Therefore, all parser directives must be at the very
top of a `Dockerfile`.

Parser directives are not case-sensitive. However, convention is for them to
be lowercase. Convention is also to include a blank line following any
parser directives. Line continuation characters are not supported in parser
directives.

Due to these rules, the following examples are all invalid:

Invalid due to line continuation:

```Dockerfile
# direc \
tive=value
```

Invalid due to appearing twice:

```Dockerfile
# directive=value1
# directive=value2

FROM ImageName
```

Treated as a comment due to appearing after a builder instruction:

```Dockerfile
FROM ImageName
# directive=value
```

Treated as a comment due to appearing after a comment which is not a parser
directive:

```Dockerfile
# About my dockerfile
FROM ImageName
# directive=value
```

The unknown directive is treated as a comment due to not being recognized. In
addition, the known directive is treated as a comment due to appearing after
a comment which is not a parser directive.

```Dockerfile
# unknowndirective=value
# knowndirective=value
```

Non line-breaking whitespace is permitted in a parser directive. Hence, the
following lines are all treated identically:

```Dockerfile
#directive=value
# directive =value
#	directive= value
# directive = value
#	  dIrEcTiVe=value
```

The following parser directive is supported:

* `escape`

## escape

    # escape=\ (backslash)

Or

    # escape=` (backtick)

The `escape` directive sets the character used to escape characters in a
`Dockerfile`. If not specified, the default escape character is `\`.

The escape character is used both to escape characters in a line, and to
escape a newline. This allows a `Dockerfile` instruction to
span multiple lines. Note that regardless of whether the `escape` parser
directive is included in a `Dockerfile`, *escaping is not performed in
a `RUN` command, except at the end of a line.*

Setting the escape character to `` ` `` is especially useful on
`Windows`, where `\` is the directory path separator. `` ` `` is consistent
with [Windows PowerShell](https://technet.microsoft.com/en-us/library/hh847755.aspx).

Consider the following example which would fail in a non-obvious way on
`Windows`. The second `\` at the end of the second line would be interpreted as an
escape for the newline, instead of a target of the escape from the first `\`.
Similarly, the `\` at the end of the third line would, assuming it was actually
handled as an instruction, cause it be treated as a line continuation. The result
of this dockerfile is that second and third lines are considered a single
instruction:

```Dockerfile
FROM windowsservercore
COPY testfile.txt c:\\
RUN dir c:\
```

Results in:

    PS C:\John> docker build -t cmd .
    Sending build context to Docker daemon 3.072 kB
    Step 1 : FROM windowsservercore
     ---> dbfee88ee9fd
    Step 2 : COPY testfile.txt c:RUN dir c:
    GetFileAttributesEx c:RUN: The system cannot find the file specified.
    PS C:\John>

One solution to the above would be to use `/` as the target of both the `COPY`
instruction, and `dir`. However, this syntax is, at best, confusing as it is not
natural for paths on `Windows`, and at worst, error prone as not all commands on
`Windows` support `/` as the path separator.

By adding the `escape` parser directive, the following `Dockerfile` succeeds as
expected with the use of natural platform semantics for file paths on `Windows`:

    # escape=`

    FROM windowsservercore
    COPY testfile.txt c:\
    RUN dir c:\

Results in:

    PS C:\John> docker build -t succeeds --no-cache=true .
    Sending build context to Docker daemon 3.072 kB
    Step 1 : FROM windowsservercore
     ---> dbfee88ee9fd
    Step 2 : COPY testfile.txt c:\
     ---> 99ceb62e90df
    Removing intermediate container 62afbe726221
    Step 3 : RUN dir c:\
     ---> Running in a5ff53ad6323
     Volume in drive C has no label.
     Volume Serial Number is 1440-27FA

     Directory of c:\

    03/25/2016  05:28 AM    <DIR>          inetpub
    03/25/2016  04:22 AM    <DIR>          PerfLogs
    04/22/2016  10:59 PM    <DIR>          Program Files
    03/25/2016  04:22 AM    <DIR>          Program Files (x86)
    04/18/2016  09:26 AM                 4 testfile.txt
    04/22/2016  10:59 PM    <DIR>          Users
    04/22/2016  10:59 PM    <DIR>          Windows
                   1 File(s)              4 bytes
                   6 Dir(s)  21,252,689,920 bytes free
     ---> 2569aa19abef
    Removing intermediate container a5ff53ad6323
    Successfully built 2569aa19abef
    PS C:\John>

## Environment replacement

Environment variables (declared with [the `ENV` statement](builder.md#env)) can also be
used in certain instructions as variables to be interpreted by the
`Dockerfile`. Escapes are also handled for including variable-like syntax
into a statement literally.

Environment variables are notated in the `Dockerfile` either with
`$variable_name` or `${variable_name}`. They are treated equivalently and the
brace syntax is typically used to address issues with variable names with no
whitespace, like `${foo}_bar`.

The `${variable_name}` syntax also supports a few of the standard `bash`
modifiers as specified below:

* `${variable:-word}` indicates that if `variable` is set then the result
  will be that value. If `variable` is not set then `word` will be the result.
* `${variable:+word}` indicates that if `variable` is set then `word` will be
  the result, otherwise the result is the empty string.

In all cases, `word` can be any string, including additional environment
variables.

Escaping is possible by adding a `\` before the variable: `\$foo` or `\${foo}`,
for example, will translate to `$foo` and `${foo}` literals respectively.

Example (parsed representation is displayed after the `#`):

    FROM busybox
    ENV foo /bar
    WORKDIR ${foo}   # WORKDIR /bar
    ADD . $foo       # ADD . /bar
    COPY \$foo /quux # COPY $foo /quux

Environment variables are supported by the following list of instructions in
the `Dockerfile`:

* `ADD`
* `COPY`
* `ENV`
* `EXPOSE`
* `LABEL`
* `USER`
* `WORKDIR`
* `VOLUME`
* `STOPSIGNAL`

as well as:

* `ONBUILD` (when combined with one of the supported instructions above)

> **Note**:
> prior to 1.4, `ONBUILD` instructions did **NOT** support environment
> variable, even when combined with any of the instructions listed above.

Environment variable substitution will use the same value for each variable
throughout the entire command. In other words, in this example:

    ENV abc=hello
    ENV abc=bye def=$abc
    ENV ghi=$abc

will result in `def` having a value of `hello`, not `bye`. However,
`ghi` will have a value of `bye` because it is not part of the same command
that set `abc` to `bye`.

## .dockerignore file

Before the docker CLI sends the context to the docker daemon, it looks
for a file named `.dockerignore` in the root directory of the context.
If this file exists, the CLI modifies the context to exclude files and
directories that match patterns in it.  This helps to avoid
unnecessarily sending large or sensitive files and directories to the
daemon and potentially adding them to images using `ADD` or `COPY`.

The CLI interprets the `.dockerignore` file as a newline-separated
list of patterns similar to the file globs of Unix shells.  For the
purposes of matching, the root of the context is considered to be both
the working and the root directory.  For example, the patterns
`/foo/bar` and `foo/bar` both exclude a file or directory named `bar`
in the `foo` subdirectory of `PATH` or in the root of the git
repository located at `URL`.  Neither excludes anything else.

If a line in `.dockerignore` file starts with `#` in column 1, then this line is
considered as a comment and is ignored before interpreted by the CLI.

Here is an example `.dockerignore` file:

```
# comment
    */temp*
    */*/temp*
    temp?
```

This file causes the following build behavior:

| Rule           | Behavior                                                                                                                                                                     |
|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `# comment`    | Ignored.                 |
| `*/temp*`      | Exclude files and directories whose names start with `temp` in any immediate subdirectory of the root.  For example, the plain file `/somedir/temporary.txt` is excluded, as is the directory `/somedir/temp`.                 |
| `*/*/temp*`    | Exclude files and directories starting with `temp` from any subdirectory that is two levels below the root. For example, `/somedir/subdir/temporary.txt` is excluded. |
| `temp?`        | Exclude files and directories in the root directory whose names are a one-character extension of `temp`.  For example, `/tempa` and `/tempb` are excluded.


Matching is done using Go's
[filepath.Match](http://golang.org/pkg/path/filepath#Match) rules.  A
preprocessing step removes leading and trailing whitespace and
eliminates `.` and `..` elements using Go's
[filepath.Clean](http://golang.org/pkg/path/filepath/#Clean).  Lines
that are blank after preprocessing are ignored.

Beyond Go's filepath.Match rules, Docker also supports a special
wildcard string `**` that matches any number of directories (including
zero). For example, `**/*.go` will exclude all files that end with `.go`
that are found in all directories, including the root of the build context.

Lines starting with `!` (exclamation mark) can be used to make exceptions
to exclusions.  The following is an example `.dockerignore` file that
uses this mechanism:

```
    *.md
    !README.md
```

All markdown files *except* `README.md` are excluded from the context.

The placement of `!` exception rules influences the behavior: the last
line of the `.dockerignore` that matches a particular file determines
whether it is included or excluded.  Consider the following example:

```
    *.md
    !README*.md
    README-secret.md
```

No markdown files are included in the context except README files other than
`README-secret.md`.

Now consider this example:

```
    *.md
    README-secret.md
    !README*.md
```

All of the README files are included.  The middle line has no effect because
`!README*.md` matches `README-secret.md` and comes last.

You can even use the `.dockerignore` file to exclude the `Dockerfile`
and `.dockerignore` files.  These files are still sent to the daemon
because it needs them to do its job.  But the `ADD` and `COPY` commands
do not copy them to the image.

Finally, you may want to specify which files to include in the
context, rather than which to exclude. To achieve this, specify `*` as
the first pattern, followed by one or more `!` exception patterns.

**Note**: For historical reasons, the pattern `.` is ignored.

## FROM

    FROM <image>

Or

    FROM <image>:<tag>

Or

    FROM <image>@<digest>

The `FROM` instruction sets the [*Base Image*](glossary.md#base-image)
for subsequent instructions. As such, a valid `Dockerfile` must have `FROM` as
its first instruction. The image can be any valid image ‚Äì it is especially easy
to start by **pulling an image** from the [*Public Repositories*](../tutorials/dockerrepos.md).

- `FROM` must be the first non-comment instruction in the `Dockerfile`.

- `FROM` can appear multiple times within a single `Dockerfile` in order to create
multiple images. Simply make a note of the last image ID output by the commit
before each new `FROM` command.

- The `tag` or `digest` values are optional. If you omit either of them, the builder
assumes a `latest` by default. The builder returns an error if it cannot match
the `tag` value.

## MAINTAINER

    MAINTAINER <name>

The `MAINTAINER` instruction allows you to set the *Author* field of the
generated images.

## RUN

RUN has 2 forms:

- `RUN <command>` (*shell* form, the command is run in a shell, which by
default is `/bin/sh -c` on Linux or `cmd /S /C` on Windows)
- `RUN ["executable", "param1", "param2"]` (*exec* form)

The `RUN` instruction will execute any commands in a new layer on top of the
current image and commit the results. The resulting committed image will be
used for the next step in the `Dockerfile`.

Layering `RUN` instructions and generating commits conforms to the core
concepts of Docker where commits are cheap and containers can be created from
any point in an image's history, much like source control.

The *exec* form makes it possible to avoid shell string munging, and to `RUN`
commands using a base image that does not contain the specified shell executable.

The default shell for the *shell* form can be changed using the `SHELL`
command.

In the *shell* form you can use a `\` (backslash) to continue a single
RUN instruction onto the next line. For example, consider these two lines:

```
RUN /bin/bash -c 'source $HOME/.bashrc; \
echo $HOME'
```
Together they are equivalent to this single line:

```
RUN /bin/bash -c 'source $HOME/.bashrc; echo $HOME'
```

> **Note**:
> To use a different shell, other than '/bin/sh', use the *exec* form
> passing in the desired shell. For example,
> `RUN ["/bin/bash", "-c", "echo hello"]`

> **Note**:
> The *exec* form is parsed as a JSON array, which means that
> you must use double-quotes (") around words not single-quotes (').

> **Note**:
> Unlike the *shell* form, the *exec* form does not invoke a command shell.
> This means that normal shell processing does not happen. For example,
> `RUN [ "echo", "$HOME" ]` will not do variable substitution on `$HOME`.
> If you want shell processing then either use the *shell* form or execute
> a shell directly, for example: `RUN [ "sh", "-c", "echo $HOME" ]`.
> When using the exec form and executing a shell directly, as in the case for
> the shell form, it is the shell that is doing the environment variable
> expansion, not docker.
>
> **Note**:
> In the *JSON* form, it is necessary to escape backslashes. This is
> particularly relevant on Windows where the backslash is the path separator.
> The following line would otherwise be treated as *shell* form due to not
> being valid JSON, and fail in an unexpected way:
> `RUN ["c:\windows\system32\tasklist.exe"]`
> The correct syntax for this example is:
> `RUN ["c:\\windows\\system32\\tasklist.exe"]`

The cache for `RUN` instructions isn't invalidated automatically during
the next build. The cache for an instruction like
`RUN apt-get dist-upgrade -y` will be reused during the next build. The
cache for `RUN` instructions can be invalidated by using the `--no-cache`
flag, for example `docker build --no-cache`.

See the [`Dockerfile` Best Practices
guide](../userguide/eng-image/dockerfile_best-practices.md#build-cache) for more information.

The cache for `RUN` instructions can be invalidated by `ADD` instructions. See
[below](builder.md#add) for details.

### Known issues (RUN)

- [Issue 783](https://github.com/docker/docker/issues/783) is about file
  permissions problems that can occur when using the AUFS file system. You
  might notice it during an attempt to `rm` a file, for example.

  For systems that have recent aufs version (i.e., `dirperm1` mount option can
  be set), docker will attempt to fix the issue automatically by mounting
  the layers with `dirperm1` option. More details on `dirperm1` option can be
  found at [`aufs` man page](https://github.com/sfjro/aufs3-linux/tree/aufs3.18/Documentation/filesystems/aufs)

  If your system doesn't have support for `dirperm1`, the issue describes a workaround.

## CMD

The `CMD` instruction has three forms:

- `CMD ["executable","param1","param2"]` (*exec* form, this is the preferred form)
- `CMD ["param1","param2"]` (as *default parameters to ENTRYPOINT*)
- `CMD command param1 param2` (*shell* form)

There can only be one `CMD` instruction in a `Dockerfile`. If you list more than one `CMD`
then only the last `CMD` will take effect.

**The main purpose of a `CMD` is to provide defaults for an executing
container.** These defaults can include an executable, or they can omit
the executable, in which case you must specify an `ENTRYPOINT`
instruction as well.

> **Note**:
> If `CMD` is used to provide default arguments for the `ENTRYPOINT`
> instruction, both the `CMD` and `ENTRYPOINT` instructions should be specified
> with the JSON array format.

> **Note**:
> The *exec* form is parsed as a JSON array, which means that
> you must use double-quotes (") around words not single-quotes (').

> **Note**:
> Unlike the *shell* form, the *exec* form does not invoke a command shell.
> This means that normal shell processing does not happen. For example,
> `CMD [ "echo", "$HOME" ]` will not do variable substitution on `$HOME`.
> If you want shell processing then either use the *shell* form or execute
> a shell directly, for example: `CMD [ "sh", "-c", "echo $HOME" ]`.
> When using the exec form and executing a shell directly, as in the case for
> the shell form, it is the shell that is doing the environment variable
> expansion, not docker.

When used in the shell or exec formats, the `CMD` instruction sets the command
to be executed when running the image.

If you use the *shell* form of the `CMD`, then the `<command>` will execute in
`/bin/sh -c`:

    FROM ubuntu
    CMD echo "This is a test." | wc -

If you want to **run your** `<command>` **without a shell** then you must
express the command as a JSON array and give the full path to the executable.
**This array form is the preferred format of `CMD`.** Any additional parameters
must be individually expressed as strings in the array:

    FROM ubuntu
    CMD ["/usr/bin/wc","--help"]

If you would like your container to run the same executable every time, then
you should consider using `ENTRYPOINT` in combination with `CMD`. See
[*ENTRYPOINT*](builder.md#entrypoint).

If the user specifies arguments to `docker run` then they will override the
default specified in `CMD`.

> **Note**:
> Don't confuse `RUN` with `CMD`. `RUN` actually runs a command and commits
> the result; `CMD` does not execute anything at build time, but specifies
> the intended command for the image.

## LABEL

    LABEL <key>=<value> <key>=<value> <key>=<value> ...

The `LABEL` instruction adds metadata to an image. A `LABEL` is a
key-value pair. To include spaces within a `LABEL` value, use quotes and
backslashes as you would in command-line parsing. A few usage examples:

    LABEL "com.example.vendor"="ACME Incorporated"
    LABEL com.example.label-with-value="foo"
    LABEL version="1.0"
    LABEL description="This text illustrates \
    that label-values can span multiple lines."

An image can have more than one label. To specify multiple labels,
Docker recommends combining labels into a single `LABEL` instruction where
possible. Each `LABEL` instruction produces a new layer which can result in an
inefficient image if you use many labels. This example results in a single image
layer.

    LABEL multi.label1="value1" multi.label2="value2" other="value3"

The above can also be written as:

    LABEL multi.label1="value1" \
          multi.label2="value2" \
          other="value3"

Labels are additive including `LABEL`s in `FROM` images. If Docker
encounters a label/key that already exists, the new value overrides any previous
labels with identical keys.

To view an image's labels, use the `docker inspect` command.

    "Labels": {
        "com.example.vendor": "ACME Incorporated"
        "com.example.label-with-value": "foo",
        "version": "1.0",
        "description": "This text illustrates that label-values can span multiple lines.",
        "multi.label1": "value1",
        "multi.label2": "value2",
        "other": "value3"
    },

## EXPOSE

    EXPOSE <port> [<port>...]

The `EXPOSE` instruction informs Docker that the container listens on the
specified network ports at runtime. `EXPOSE` does not make the ports of the
container accessible to the host. To do that, you must use either the `-p` flag
to publish a range of ports or the `-P` flag to publish all of the exposed
ports. You can expose one port number and publish it externally under another
number.

To set up port redirection on the host system, see [using the -P
flag](run.md#expose-incoming-ports). The Docker network feature supports
creating networks without the need to expose ports within the network, for
detailed information see the  [overview of this
feature](../userguide/networking/index.md)).

## ENV

    ENV <key> <value>
    ENV <key>=<value> ...

The `ENV` instruction sets the environment variable `<key>` to the value
`<value>`. This value will be in the environment of all "descendant"
`Dockerfile` commands and can be [replaced inline](builder.md#environment-replacement) in
many as well.

The `ENV` instruction has two forms. The first form, `ENV <key> <value>`,
will set a single variable to a value. The entire string after the first
space will be treated as the `<value>` - including characters such as
spaces and quotes.

The second form, `ENV <key>=<value> ...`, allows for multiple variables to
be set at one time. Notice that the second form uses the equals sign (=)
in the syntax, while the first form does not. Like command line parsing,
quotes and backslashes can be used to include spaces within values.

For example:

    ENV myName="John Doe" myDog=Rex\ The\ Dog \
        myCat=fluffy

and

    ENV myName John Doe
    ENV myDog Rex The Dog
    ENV myCat fluffy

will yield the same net results in the final image, but the first form
is preferred because it produces a single cache layer.

The environment variables set using `ENV` will persist when a container is run
from the resulting image. You can view the values using `docker inspect`, and
change them using `docker run --env <key>=<value>`.

> **Note**:
> Environment persistence can cause unexpected side effects. For example,
> setting `ENV DEBIAN_FRONTEND noninteractive` may confuse apt-get
> users on a Debian-based image. To set a value for a single command, use
> `RUN <key>=<value> <command>`.

## ADD

ADD has two forms:

- `ADD <src>... <dest>`
- `ADD ["<src>",... "<dest>"]` (this form is required for paths containing
whitespace)

The `ADD` instruction copies new files, directories or remote file URLs from `<src>`
and adds them to the filesystem of the image at the path `<dest>`.

Multiple `<src>` resource may be specified but if they are files or
directories then they must be relative to the source directory that is
being built (the context of the build).

Each `<src>` may contain wildcards and matching will be done using Go's
[filepath.Match](http://golang.org/pkg/path/filepath#Match) rules. For example:

    ADD hom* /mydir/        # adds all files starting with "hom"
    ADD hom?.txt /mydir/    # ? is replaced with any single character, e.g., "home.txt"

The `<dest>` is an absolute path, or a path relative to `WORKDIR`, into which
the source will be copied inside the destination container.

    ADD test relativeDir/          # adds "test" to `WORKDIR`/relativeDir/
    ADD test /absoluteDir/         # adds "test" to /absoluteDir/

All new files and directories are created with a UID and GID of 0.

In the case where `<src>` is a remote file URL, the destination will
have permissions of 600. If the remote file being retrieved has an HTTP
`Last-Modified` header, the timestamp from that header will be used
to set the `mtime` on the destination file. However, like any other file
processed during an `ADD`, `mtime` will not be included in the determination
of whether or not the file has changed and the cache should be updated.

> **Note**:
> If you build by passing a `Dockerfile` through STDIN (`docker
> build - < somefile`), there is no build context, so the `Dockerfile`
> can only contain a URL based `ADD` instruction. You can also pass a
> compressed archive through STDIN: (`docker build - < archive.tar.gz`),
> the `Dockerfile` at the root of the archive and the rest of the
> archive will be used as the context of the build.

> **Note**:
> If your URL files are protected using authentication, you
> will need to use `RUN wget`, `RUN curl` or use another tool from
> within the container as the `ADD` instruction does not support
> authentication.

> **Note**:
> The first encountered `ADD` instruction will invalidate the cache for all
> following instructions from the Dockerfile if the contents of `<src>` have
> changed. This includes invalidating the cache for `RUN` instructions.
> See the [`Dockerfile` Best Practices
guide](../userguide/eng-image/dockerfile_best-practices.md#build-cache) for more information.


`ADD` obeys the following rules:

- The `<src>` path must be inside the *context* of the build;
  you cannot `ADD ../something /something`, because the first step of a
  `docker build` is to send the context directory (and subdirectories) to the
  docker daemon.

- If `<src>` is a URL and `<dest>` does not end with a trailing slash, then a
  file is downloaded from the URL and copied to `<dest>`.

- If `<src>` is a URL and `<dest>` does end with a trailing slash, then the
  filename is inferred from the URL and the file is downloaded to
  `<dest>/<filename>`. For instance, `ADD http://example.com/foobar /` would
  create the file `/foobar`. The URL must have a nontrivial path so that an
  appropriate filename can be discovered in this case (`http://example.com`
  will not work).

- If `<src>` is a directory, the entire contents of the directory are copied,
  including filesystem metadata.

> **Note**:
> The directory itself is not copied, just its contents.

- If `<src>` is a *local* tar archive in a recognized compression format
  (identity, gzip, bzip2 or xz) then it is unpacked as a directory. Resources
  from *remote* URLs are **not** decompressed. When a directory is copied or
  unpacked, it has the same behavior as `tar -x`, the result is the union of:

    1. Whatever existed at the destination path and
    2. The contents of the source tree, with conflicts resolved in favor
       of "2." on a file-by-file basis.

  > **Note**:
  > Whether a file is identified as a recognized compression format or not
  > is done solely based on the contents of the file, not the name of the file.
  > For example, if an empty file happens to end with `.tar.gz` this will not
  > be recognized as a compressed file and **will not** generate any kind of
  > decompression error message, rather the file will simply be copied to the
  > destination.

- If `<src>` is any other kind of file, it is copied individually along with
  its metadata. In this case, if `<dest>` ends with a trailing slash `/`, it
  will be considered a directory and the contents of `<src>` will be written
  at `<dest>/base(<src>)`.

- If multiple `<src>` resources are specified, either directly or due to the
  use of a wildcard, then `<dest>` must be a directory, and it must end with
  a slash `/`.

- If `<dest>` does not end with a trailing slash, it will be considered a
  regular file and the contents of `<src>` will be written at `<dest>`.

- If `<dest>` doesn't exist, it is created along with all missing directories
  in its path.

## COPY

COPY has two forms:

- `COPY <src>... <dest>`
- `COPY ["<src>",... "<dest>"]` (this form is required for paths containing
whitespace)

The `COPY` instruction copies new files or directories from `<src>`
and adds them to the filesystem of the container at the path `<dest>`.

Multiple `<src>` resource may be specified but they must be relative
to the source directory that is being built (the context of the build).

Each `<src>` may contain wildcards and matching will be done using Go's
[filepath.Match](http://golang.org/pkg/path/filepath#Match) rules. For example:

    COPY hom* /mydir/        # adds all files starting with "hom"
    COPY hom?.txt /mydir/    # ? is replaced with any single character, e.g., "home.txt"

The `<dest>` is an absolute path, or a path relative to `WORKDIR`, into which
the source will be copied inside the destination container.

    COPY test relativeDir/   # adds "test" to `WORKDIR`/relativeDir/
    COPY test /absoluteDir/  # adds "test" to /absoluteDir/

All new files and directories are created with a UID and GID of 0.

> **Note**:
> If you build using STDIN (`docker build - < somefile`), there is no
> build context, so `COPY` can't be used.

`COPY` obeys the following rules:

- The `<src>` path must be inside the *context* of the build;
  you cannot `COPY ../something /something`, because the first step of a
  `docker build` is to send the context directory (and subdirectories) to the
  docker daemon.

- If `<src>` is a directory, the entire contents of the directory are copied,
  including filesystem metadata.

> **Note**:
> The directory itself is not copied, just its contents.

- If `<src>` is any other kind of file, it is copied individually along with
  its metadata. In this case, if `<dest>` ends with a trailing slash `/`, it
  will be considered a directory and the contents of `<src>` will be written
  at `<dest>/base(<src>)`.

- If multiple `<src>` resources are specified, either directly or due to the
  use of a wildcard, then `<dest>` must be a directory, and it must end with
  a slash `/`.

- If `<dest>` does not end with a trailing slash, it will be considered a
  regular file and the contents of `<src>` will be written at `<dest>`.

- If `<dest>` doesn't exist, it is created along with all missing directories
  in its path.

## ENTRYPOINT

ENTRYPOINT has two forms:

- `ENTRYPOINT ["executable", "param1", "param2"]`
  (*exec* form, preferred)
- `ENTRYPOINT command param1 param2`
  (*shell* form)

An `ENTRYPOINT` allows you to configure a container that will run as an executable.

For example, the following will start nginx with its default content, listening
on port 80:

    docker run -i -t --rm -p 80:80 nginx

Command line arguments to `docker run <image>` will be appended after all
elements in an *exec* form `ENTRYPOINT`, and will override all elements specified
using `CMD`.
This allows arguments to be passed to the entry point, i.e., `docker run <image> -d`
will pass the `-d` argument to the entry point.
You can override the `ENTRYPOINT` instruction using the `docker run --entrypoint`
flag.

The *shell* form prevents any `CMD` or `run` command line arguments from being
used, but has the disadvantage that your `ENTRYPOINT` will be started as a
subcommand of `/bin/sh -c`, which does not pass signals.
This means that the executable will not be the container's `PID 1` - and
will _not_ receive Unix signals - so your executable will not receive a
`SIGTERM` from `docker stop <container>`.

Only the last `ENTRYPOINT` instruction in the `Dockerfile` will have an effect.

### Exec form ENTRYPOINT example

You can use the *exec* form of `ENTRYPOINT` to set fairly stable default commands
and arguments and then use either form of `CMD` to set additional defaults that
are more likely to be changed.

    FROM ubuntu
    ENTRYPOINT ["top", "-b"]
    CMD ["-c"]

When you run the container, you can see that `top` is the only process:

    $ docker run -it --rm --name test  top -H
    top - 08:25:00 up  7:27,  0 users,  load average: 0.00, 0.01, 0.05
    Threads:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
    %Cpu(s):  0.1 us,  0.1 sy,  0.0 ni, 99.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
    KiB Mem:   2056668 total,  1616832 used,   439836 free,    99352 buffers
    KiB Swap:  1441840 total,        0 used,  1441840 free.  1324440 cached Mem

      PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
        1 root      20   0   19744   2336   2080 R  0.0  0.1   0:00.04 top

To examine the result further, you can use `docker exec`:

    $ docker exec -it test ps aux
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root         1  2.6  0.1  19752  2352 ?        Ss+  08:24   0:00 top -b -H
    root         7  0.0  0.1  15572  2164 ?        R+   08:25   0:00 ps aux

And you can gracefully request `top` to shut down using `docker stop test`.

The following `Dockerfile` shows using the `ENTRYPOINT` to run Apache in the
foreground (i.e., as `PID 1`):

```
FROM debian:stable
RUN apt-get update && apt-get install -y --force-yes apache2
EXPOSE 80 443
VOLUME ["/var/www", "/var/log/apache2", "/etc/apache2"]
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

If you need to write a starter script for a single executable, you can ensure that
the final executable receives the Unix signals by using `exec` and `gosu`
commands:

```bash
#!/bin/bash
set -e

if [ "$1" = 'postgres' ]; then
    chown -R postgres "$PGDATA"

    if [ -z "$(ls -A "$PGDATA")" ]; then
        gosu postgres initdb
    fi

    exec gosu postgres "$@"
fi

exec "$@"
```

Lastly, if you need to do some extra cleanup (or communicate with other containers)
on shutdown, or are co-ordinating more than one executable, you may need to ensure
that the `ENTRYPOINT` script receives the Unix signals, passes them on, and then
does some more work:

```
#!/bin/sh
# Note: I've written this using sh so it works in the busybox container too

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "echo TRAPed signal" HUP INT QUIT TERM

# start service in background here
/usr/sbin/apachectl start

echo "[hit enter key to exit] or run 'docker stop <container>'"
read

# stop service and clean up here
echo "stopping apache"
/usr/sbin/apachectl stop

echo "exited $0"
```

If you run this image with `docker run -it --rm -p 80:80 --name test apache`,
you can then examine the container's processes with `docker exec`, or `docker top`,
and then ask the script to stop Apache:

```bash
$ docker exec -it test ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.1  0.0   4448   692 ?        Ss+  00:42   0:00 /bin/sh /run.sh 123 cmd cmd2
root        19  0.0  0.2  71304  4440 ?        Ss   00:42   0:00 /usr/sbin/apache2 -k start
www-data    20  0.2  0.2 360468  6004 ?        Sl   00:42   0:00 /usr/sbin/apache2 -k start
www-data    21  0.2  0.2 360468  6000 ?        Sl   00:42   0:00 /usr/sbin/apache2 -k start
root        81  0.0  0.1  15572  2140 ?        R+   00:44   0:00 ps aux
$ docker top test
PID                 USER                COMMAND
10035               root                {run.sh} /bin/sh /run.sh 123 cmd cmd2
10054               root                /usr/sbin/apache2 -k start
10055               33                  /usr/sbin/apache2 -k start
10056               33                  /usr/sbin/apache2 -k start
$ /usr/bin/time docker stop test
test
real	0m 0.27s
user	0m 0.03s
sys	0m 0.03s
```

> **Note:** you can override the `ENTRYPOINT` setting using `--entrypoint`,
> but this can only set the binary to *exec* (no `sh -c` will be used).

> **Note**:
> The *exec* form is parsed as a JSON array, which means that
> you must use double-quotes (") around words not single-quotes (').

> **Note**:
> Unlike the *shell* form, the *exec* form does not invoke a command shell.
> This means that normal shell processing does not happen. For example,
> `ENTRYPOINT [ "echo", "$HOME" ]` will not do variable substitution on `$HOME`.
> If you want shell processing then either use the *shell* form or execute
> a shell directly, for example: `ENTRYPOINT [ "sh", "-c", "echo $HOME" ]`.
> When using the exec form and executing a shell directly, as in the case for
> the shell form, it is the shell that is doing the environment variable
> expansion, not docker.

### Shell form ENTRYPOINT example

You can specify a plain string for the `ENTRYPOINT` and it will execute in `/bin/sh -c`.
This form will use shell processing to substitute shell environment variables,
and will ignore any `CMD` or `docker run` command line arguments.
To ensure that `docker stop` will signal any long running `ENTRYPOINT` executable
correctly, you need to remember to start it with `exec`:

    FROM ubuntu
    ENTRYPOINT exec top -b

When you run this image, you'll see the single `PID 1` process:

    $ docker run -it --rm --name test top
    Mem: 1704520K used, 352148K free, 0K shrd, 0K buff, 140368121167873K cached
    CPU:   5% usr   0% sys   0% nic  94% idle   0% io   0% irq   0% sirq
    Load average: 0.08 0.03 0.05 2/98 6
      PID  PPID USER     STAT   VSZ %VSZ %CPU COMMAND
        1     0 root     R     3164   0%   0% top -b

Which will exit cleanly on `docker stop`:

    $ /usr/bin/time docker stop test
    test
    real	0m 0.20s
    user	0m 0.02s
    sys	0m 0.04s

If you forget to add `exec` to the beginning of your `ENTRYPOINT`:

    FROM ubuntu
    ENTRYPOINT top -b
    CMD --ignored-param1

You can then run it (giving it a name for the next step):

    $ docker run -it --name test top --ignored-param2
    Mem: 1704184K used, 352484K free, 0K shrd, 0K buff, 140621524238337K cached
    CPU:   9% usr   2% sys   0% nic  88% idle   0% io   0% irq   0% sirq
    Load average: 0.01 0.02 0.05 2/101 7
      PID  PPID USER     STAT   VSZ %VSZ %CPU COMMAND
        1     0 root     S     3168   0%   0% /bin/sh -c top -b cmd cmd2
        7     1 root     R     3164   0%   0% top -b

You can see from the output of `top` that the specified `ENTRYPOINT` is not `PID 1`.

If you then run `docker stop test`, the container will not exit cleanly - the
`stop` command will be forced to send a `SIGKILL` after the timeout:

    $ docker exec -it test ps aux
    PID   USER     COMMAND
        1 root     /bin/sh -c top -b cmd cmd2
        7 root     top -b
        8 root     ps aux
    $ /usr/bin/time docker stop test
    test
    real	0m 10.19s
    user	0m 0.04s
    sys	0m 0.03s

### Understand how CMD and ENTRYPOINT interact

Both `CMD` and `ENTRYPOINT` instructions define what command gets executed when running a container.
There are few rules that describe their co-operation.

1. Dockerfile should specify at least one of `CMD` or `ENTRYPOINT` commands.

2. `ENTRYPOINT` should be defined when using the container as an executable.

3. `CMD` should be used as a way of defining default arguments for an `ENTRYPOINT` command
or for executing an ad-hoc command in a container.

4. `CMD` will be overridden when running the container with alternative arguments.

The table below shows what command is executed for different `ENTRYPOINT` / `CMD` combinations:

|                                | No ENTRYPOINT              | ENTRYPOINT exec_entry p1_entry                            | ENTRYPOINT ["exec_entry", "p1_entry"]          |
|--------------------------------|----------------------------|-----------------------------------------------------------|------------------------------------------------|
| **No CMD**                     | *error, not allowed*       | /bin/sh -c exec_entry p1_entry                            | exec_entry p1_entry                            |
| **CMD ["exec_cmd", "p1_cmd"]** | exec_cmd p1_cmd            | /bin/sh -c exec_entry p1_entry exec_cmd p1_cmd            | exec_entry p1_entry exec_cmd p1_cmd            |
| **CMD ["p1_cmd", "p2_cmd"]**   | p1_cmd p2_cmd              | /bin/sh -c exec_entry p1_entry p1_cmd p2_cmd              | exec_entry p1_entry p1_cmd p2_cmd              |
| **CMD exec_cmd p1_cmd**        | /bin/sh -c exec_cmd p1_cmd | /bin/sh -c exec_entry p1_entry /bin/sh -c exec_cmd p1_cmd | exec_entry p1_entry /bin/sh -c exec_cmd p1_cmd |

## VOLUME

    VOLUME ["/data"]

The `VOLUME` instruction creates a mount point with the specified name
and marks it as holding externally mounted volumes from native host or other
containers. The value can be a JSON array, `VOLUME ["/var/log/"]`, or a plain
string with multiple arguments, such as `VOLUME /var/log` or `VOLUME /var/log
/var/db`. For more information/examples and mounting instructions via the
Docker client, refer to
[*Share Directories via Volumes*](../tutorials/dockervolumes.md#mount-a-host-directory-as-a-data-volume)
documentation.

The `docker run` command initializes the newly created volume with any data
that exists at the specified location within the base image. For example,
consider the following Dockerfile snippet:

    FROM ubuntu
    RUN mkdir /myvol
    RUN echo "hello world" > /myvol/greeting
    VOLUME /myvol

This Dockerfile results in an image that causes `docker run`, to
create a new mount point at `/myvol` and copy the  `greeting` file
into the newly created volume.

> **Note**:
> If any build steps change the data within the volume after it has been
> declared, those changes will be discarded.

> **Note**:
> The list is parsed as a JSON array, which means that
> you must use double-quotes (") around words not single-quotes (').

## USER

    USER daemon

The `USER` instruction sets the user name or UID to use when running the image
and for any `RUN`, `CMD` and `ENTRYPOINT` instructions that follow it in the
`Dockerfile`.

## WORKDIR

    WORKDIR /path/to/workdir

The `WORKDIR` instruction sets the working directory for any `RUN`, `CMD`,
`ENTRYPOINT`, `COPY` and `ADD` instructions that follow it in the `Dockerfile`.
If the `WORKDIR` doesn't exist, it will be created even if it's not used in any
subsequent `Dockerfile` instruction.

It can be used multiple times in the one `Dockerfile`. If a relative path
is provided, it will be relative to the path of the previous `WORKDIR`
instruction. For example:

    WORKDIR /a
    WORKDIR b
    WORKDIR c
    RUN pwd

The output of the final `pwd` command in this `Dockerfile` would be
`/a/b/c`.

The `WORKDIR` instruction can resolve environment variables previously set using
`ENV`. You can only use environment variables explicitly set in the `Dockerfile`.
For example:

    ENV DIRPATH /path
    WORKDIR $DIRPATH/$DIRNAME
    RUN pwd

The output of the final `pwd` command in this `Dockerfile` would be
`/path/$DIRNAME`

## ARG

    ARG <name>[=<default value>]

The `ARG` instruction defines a variable that users can pass at build-time to
the builder with the `docker build` command using the
`--build-arg <varname>=<value>` flag. If a user specifies a build argument
that was not defined in the Dockerfile, the build outputs an error.

```
One or more build-args were not consumed, failing build.
```

The Dockerfile author can define a single variable by specifying `ARG` once or many
variables by specifying `ARG` more than once. For example, a valid Dockerfile:

```
FROM busybox
ARG user1
ARG buildno
...
```

A Dockerfile author may optionally specify a default value for an `ARG` instruction:

```
FROM busybox
ARG user1=someuser
ARG buildno=1
...
```

If an `ARG` value has a default and if there is no value passed at build-time, the
builder uses the default.

An `ARG` variable definition comes into effect from the line on which it is
defined in the `Dockerfile` not from the argument's use on the command-line or
elsewhere.  For example, consider this Dockerfile:

```
1 FROM busybox
2 USER ${user:-some_user}
3 ARG user
4 USER $user
...
```
A user builds this file by calling:

```
$ docker build --build-arg user=what_user Dockerfile
```

The `USER` at line 2 evaluates to `some_user` as the `user` variable is defined on the
subsequent line 3. The `USER` at line 4 evaluates to `what_user` as `user` is
defined and the `what_user` value was passed on the command line. Prior to its definition by an
`ARG` instruction, any use of a variable results in an empty string.

> **Warning:** It is not recommended to use build-time variables for
>  passing secrets like github keys, user credentials etc. Build-time variable
>  values are visible to any user of the image with the `docker history` command.

You can use an `ARG` or an `ENV` instruction to specify variables that are
available to the `RUN` instruction. Environment variables defined using the
`ENV` instruction always override an `ARG` instruction of the same name. Consider
this Dockerfile with an `ENV` and `ARG` instruction.

```
1 FROM ubuntu
2 ARG CONT_IMG_VER
3 ENV CONT_IMG_VER v1.0.0
4 RUN echo $CONT_IMG_VER
```
Then, assume this image is built with this command:

```
$ docker build --build-arg CONT_IMG_VER=v2.0.1 Dockerfile
```

In this case, the `RUN` instruction uses `v1.0.0` instead of the `ARG` setting
passed by the user:`v2.0.1` This behavior is similar to a shell
script where a locally scoped variable overrides the variables passed as
arguments or inherited from environment, from its point of definition.

Using the example above but a different `ENV` specification you can create more
useful interactions between `ARG` and `ENV` instructions:

```
1 FROM ubuntu
2 ARG CONT_IMG_VER
3 ENV CONT_IMG_VER ${CONT_IMG_VER:-v1.0.0}
4 RUN echo $CONT_IMG_VER
```

Unlike an `ARG` instruction, `ENV` values are always persisted in the built
image. Consider a docker build without the --build-arg flag:

```
$ docker build Dockerfile
```

Using this Dockerfile example, `CONT_IMG_VER` is still persisted in the image but
its value would be `v1.0.0` as it is the default set in line 3 by the `ENV` instruction.

The variable expansion technique in this example allows you to pass arguments
from the command line and persist them in the final image by leveraging the
`ENV` instruction. Variable expansion is only supported for [a limited set of
Dockerfile instructions.](builder.md#environment-replacement)

Docker has a set of predefined `ARG` variables that you can use without a
corresponding `ARG` instruction in the Dockerfile.

* `HTTP_PROXY`
* `http_proxy`
* `HTTPS_PROXY`
* `https_proxy`
* `FTP_PROXY`
* `ftp_proxy`
* `NO_PROXY`
* `no_proxy`

To use these, simply pass them on the command line using the flag:

```
--build-arg <varname>=<value>
```

### Impact on build caching

`ARG` variables are not persisted into the built image as `ENV` variables are.
However, `ARG` variables do impact the build cache in similar ways. If a
Dockerfile defines an `ARG` variable whose value is different from a previous
build, then a "cache miss" occurs upon its first usage, not its definition. In
particular, all `RUN` instructions following an `ARG` instruction use the `ARG`
variable implicitly (as an environment variable), thus can cause a cache miss.

For example, consider these two Dockerfile:

```
1 FROM ubuntu
2 ARG CONT_IMG_VER
3 RUN echo $CONT_IMG_VER
```

```
1 FROM ubuntu
2 ARG CONT_IMG_VER
3 RUN echo hello
```

If you specify `--build-arg CONT_IMG_VER=<value>` on the command line, in both
cases, the specification on line 2 does not cause a cache miss; line 3 does
cause a cache miss.`ARG CONT_IMG_VER` causes the RUN line to be identified
as the same as running `CONT_IMG_VER=<value>` echo hello, so if the `<value>`
changes, we get a cache miss.

Consider another example under the same command line:

```
1 FROM ubuntu
2 ARG CONT_IMG_VER
3 ENV CONT_IMG_VER $CONT_IMG_VER
4 RUN echo $CONT_IMG_VER
```
In this example, the cache miss occurs on line 3. The miss happens because
the variable's value in the `ENV` references the `ARG` variable and that
variable is changed through the command line. In this example, the `ENV`
command causes the image to include the value.

If an `ENV` instruction overrides an `ARG` instruction of the same name, like
this Dockerfile:

```
1 FROM ubuntu
2 ARG CONT_IMG_VER
3 ENV CONT_IMG_VER hello
4 RUN echo $CONT_IMG_VER
```

Line 3 does not cause a cache miss because the value of `CONT_IMG_VER` is a
constant (`hello`). As a result, the environment variables and values used on
the `RUN` (line 4) doesn't change between builds.

## ONBUILD

    ONBUILD [INSTRUCTION]

The `ONBUILD` instruction adds to the image a *trigger* instruction to
be executed at a later time, when the image is used as the base for
another build. The trigger will be executed in the context of the
downstream build, as if it had been inserted immediately after the
`FROM` instruction in the downstream `Dockerfile`.

Any build instruction can be registered as a trigger.

This is useful if you are building an image which will be used as a base
to build other images, for example an application build environment or a
daemon which may be customized with user-specific configuration.

For example, if your image is a reusable Python application builder, it
will require application source code to be added in a particular
directory, and it might require a build script to be called *after*
that. You can't just call `ADD` and `RUN` now, because you don't yet
have access to the application source code, and it will be different for
each application build. You could simply provide application developers
with a boilerplate `Dockerfile` to copy-paste into their application, but
that is inefficient, error-prone and difficult to update because it
mixes with application-specific code.

The solution is to use `ONBUILD` to register advance instructions to
run later, during the next build stage.

Here's how it works:

1. When it encounters an `ONBUILD` instruction, the builder adds a
   trigger to the metadata of the image being built. The instruction
   does not otherwise affect the current build.
2. At the end of the build, a list of all triggers is stored in the
   image manifest, under the key `OnBuild`. They can be inspected with
   the `docker inspect` command.
3. Later the image may be used as a base for a new build, using the
   `FROM` instruction. As part of processing the `FROM` instruction,
   the downstream builder looks for `ONBUILD` triggers, and executes
   them in the same order they were registered. If any of the triggers
   fail, the `FROM` instruction is aborted which in turn causes the
   build to fail. If all triggers succeed, the `FROM` instruction
   completes and the build continues as usual.
4. Triggers are cleared from the final image after being executed. In
   other words they are not inherited by "grand-children" builds.

For example you might add something like this:

    [...]
    ONBUILD ADD . /app/src
    ONBUILD RUN /usr/local/bin/python-build --dir /app/src
    [...]

> **Warning**: Chaining `ONBUILD` instructions using `ONBUILD ONBUILD` isn't allowed.

> **Warning**: The `ONBUILD` instruction may not trigger `FROM` or `MAINTAINER` instructions.

## STOPSIGNAL

    STOPSIGNAL signal

The `STOPSIGNAL` instruction sets the system call signal that will be sent to the container to exit.
This signal can be a valid unsigned number that matches a position in the kernel's syscall table, for instance 9,
or a signal name in the format SIGNAME, for instance SIGKILL.

## HEALTHCHECK

The `HEALTHCHECK` instruction has two forms:

* `HEALTHCHECK [OPTIONS] CMD command` (check container health by running a command inside the container)
* `HEALTHCHECK NONE` (disable any healthcheck inherited from the base image)

The `HEALTHCHECK` instruction tells Docker how to test a container to check that
it is still working. This can detect cases such as a web server that is stuck in
an infinite loop and unable to handle new connections, even though the server
process is still running.

When a container has a healthcheck specified, it has a _health status_ in
addition to its normal status. This status is initially `starting`. Whenever a
health check passes, it becomes `healthy` (whatever state it was previously in).
After a certain number of consecutive failures, it becomes `unhealthy`.

The options that can appear before `CMD` are:

* `--interval=DURATION` (default: `30s`)
* `--timeout=DURATION` (default: `30s`)
* `--retries=N` (default: `3`)

The health check will first run **interval** seconds after the container is
started, and then again **interval** seconds after each previous check completes.

If a single run of the check takes longer than **timeout** seconds then the check
is considered to have failed.

It takes **retries** consecutive failures of the health check for the container
to be considered `unhealthy`.

There can only be one `HEALTHCHECK` instruction in a Dockerfile. If you list
more than one then only the last `HEALTHCHECK` will take effect.

The command after the `CMD` keyword can be either a shell command (e.g. `HEALTHCHECK
CMD /bin/check-running`) or an _exec_ array (as with other Dockerfile commands;
see e.g. `ENTRYPOINT` for details).

The command's exit status indicates the health status of the container.
The possible values are:

- 0: success - the container is healthy and ready for use
- 1: unhealthy - the container is not working correctly
- 2: reserved - do not use this exit code

For example, to check every five minutes or so that a web-server is able to
serve the site's main page within three seconds:

    HEALTHCHECK --interval=5m --timeout=3s \
      CMD curl -f http://localhost/ || exit 1

To help debug failing probes, any output text (UTF-8 encoded) that the command writes
on stdout or stderr will be stored in the health status and can be queried with
`docker inspect`. Such output should be kept short (only the first 4096 bytes
are stored currently).

When the health status of a container changes, a `health_status` event is
generated with the new status.

The `HEALTHCHECK` feature was added in Docker 1.12.


## SHELL

    SHELL ["executable", "parameters"]

The `SHELL` instruction allows the default shell used for the *shell* form of
commands to be overridden. The default shell on Linux is `["/bin/sh", "-c"]`, and on
Windows is `["cmd", "/S", "/C"]`. The `SHELL` instruction *must* be written in JSON
form in a Dockerfile.

The `SHELL` instruction is particularly useful on Windows where there are
two commonly used and quite different native shells: `cmd` and `powershell`, as
well as alternate shells available including `sh`.

The `SHELL` instruction can appear multiple times. Each `SHELL` instruction overrides
all previous `SHELL` instructions, and affects all subsequent instructions. For example:

    FROM windowsservercore

    # Executed as cmd /S /C echo default
    RUN echo default

    # Executed as cmd /S /C powershell -command Write-Host default
    RUN powershell -command Write-Host default

    # Executed as powershell -command Write-Host hello
    SHELL ["powershell", "-command"]
    RUN Write-Host hello

    # Executed as cmd /S /C echo hello
    SHELL ["cmd", "/S"", "/C"]
    RUN echo hello

The following instructions can be affected by the `SHELL` instruction when the
*shell* form of them is used in a Dockerfile: `RUN`, `CMD` and `ENTRYPOINT`.

The following example is a common pattern found on Windows which can be
streamlined by using the `SHELL` instruction:

    ...
    RUN powershell -command Execute-MyCmdlet -param1 "c:\foo.txt"
    ...

The command invoked by docker will be:

    cmd /S /C powershell -command Execute-MyCmdlet -param1 "c:\foo.txt"

 This is inefficient for two reasons. First, there is an un-necessary cmd.exe command
 processor (aka shell) being invoked. Second, each `RUN` instruction in the *shell*
 form requires an extra `powershell -command` prefixing the command.

To make this more efficient, one of two mechanisms can be employed. One is to
use the JSON form of the RUN command such as:

    ...
    RUN ["powershell", "-command", "Execute-MyCmdlet", "-param1 \"c:\\foo.txt\""]
    ...

While the JSON form is unambiguous and does not use the un-necessary cmd.exe,
it does require more verbosity through double-quoting and escaping. The alternate
mechanism is to use the `SHELL` instruction and the *shell* form,
making a more natural syntax for Windows users, especially when combined with
the `escape` parser directive:

    # escape=`

    FROM windowsservercore
    SHELL ["powershell","-command"]
    RUN New-Item -ItemType Directory C:\Example
    ADD Execute-MyCmdlet.ps1 c:\example\
    RUN c:\example\Execute-MyCmdlet -sample 'hello world'

Resulting in:

    PS E:\docker\build\shell> docker build -t shell .
    Sending build context to Docker daemon 3.584 kB
    Step 1 : FROM windowsservercore
     ---> 5bc36a335344
    Step 2 : SHELL powershell -command
     ---> Running in 87d7a64c9751
     ---> 4327358436c1
    Removing intermediate container 87d7a64c9751
    Step 3 : RUN New-Item -ItemType Directory C:\Example
     ---> Running in 3e6ba16b8df9


        Directory: C:\


    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    d-----         6/2/2016   2:59 PM                Example


     ---> 1f1dfdcec085
    Removing intermediate container 3e6ba16b8df9
    Step 4 : ADD Execute-MyCmdlet.ps1 c:\example\
     ---> 6770b4c17f29
    Removing intermediate container b139e34291dc
    Step 5 : RUN c:\example\Execute-MyCmdlet -sample 'hello world'
     ---> Running in abdcf50dfd1f
    Hello from Execute-MyCmdlet.ps1 - passed hello world
     ---> ba0e25255fda
    Removing intermediate container abdcf50dfd1f
    Successfully built ba0e25255fda
    PS E:\docker\build\shell>

The `SHELL` instruction could also be used to modify the way in which
a shell operates. For example, using `SHELL cmd /S /C /V:ON|OFF` on Windows, delayed
environment variable expansion semantics could be modified.

The `SHELL` instruction can also be used on Linux should an alternate shell be
required such as `zsh`, `csh`, `tcsh` and others.

The `SHELL` feature was added in Docker 1.12.

## Dockerfile examples

Below you can see some examples of Dockerfile syntax. If you're interested in
something more realistic, take a look at the list of [Dockerization examples](../examples/index.md).

```
# Nginx
#
# VERSION               0.0.1

FROM      ubuntu
MAINTAINER Victor Vieux <victor@docker.com>

LABEL Description="This image is used to start the foobar executable" Vendor="ACME Products" Version="1.0"
RUN apt-get update && apt-get install -y inotify-tools nginx apache2 openssh-server
```

```
# Firefox over VNC
#
# VERSION               0.3

FROM ubuntu

# Install vnc, xvfb in order to create a 'fake' display and firefox
RUN apt-get update && apt-get install -y x11vnc xvfb firefox
RUN mkdir ~/.vnc
# Setup a password
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd
# Autostart firefox (might not be the best way, but it does the trick)
RUN bash -c 'echo "firefox" >> /.bashrc'

EXPOSE 5900
CMD    ["x11vnc", "-forever", "-usepw", "-create"]
```

```
# Multiple images example
#
# VERSION               0.1

FROM ubuntu
RUN echo foo > bar
# Will output something like ===> 907ad6c2736f

FROM ubuntu
RUN echo moo > oink
# Will output something like ===> 695d7793cbe4

# You·æøll now have two images, 907ad6c2736f with /bar, and 695d7793cbe4 with
# /oink.
```
                           go/src/github.com/docker/docker/docs/reference/commandline/                                         0040755 0000000 0000000 00000000000 13101060260 022362  5                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        go/src/github.com/docker/docker/docs/reference/commandline/attach.md                                0100644 0000000 0000000 00000012530 13101060260 024146  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/attach/
description: The attach command description and usage
keywords:
- attach, running, container
title: docker attach
---

```markdown
Usage: docker attach [OPTIONS] CONTAINER

Attach to a running container

Options:
      --detach-keys string   Override the key sequence for detaching a container
      --help                 Print usage
      --no-stdin             Do not attach STDIN
      --sig-proxy            Proxy all received signals to the process (default true)
```

The `docker attach` command allows you to attach to a running container using
the container's ID or name, either to view its ongoing output or to control it
interactively. You can attach to the same contained process multiple times
simultaneously, screen sharing style, or quickly view the progress of your
detached  process.

To stop a container, use `CTRL-c`. This key sequence sends `SIGKILL` to the
container. If `--sig-proxy` is true (the default),`CTRL-c` sends a `SIGINT` to
the container. You can detach from a container and leave it running using the
 `CTRL-p CTRL-q` key sequence.

> **Note:**
> A process running as PID 1 inside a container is treated specially by
> Linux: it ignores any signal with the default action. So, the process
> will not terminate on `SIGINT` or `SIGTERM` unless it is coded to do
> so.

It is forbidden to redirect the standard input of a `docker attach` command
while attaching to a tty-enabled container (i.e.: launched with `-t`).

While a client is connected to container's stdio using `docker attach`, Docker
uses a ~1MB memory buffer to maximize the throughput of the application. If
this buffer is filled, the speed of the API connection will start to have an
effect on the process output writing speed. This is similar to other
applications like SSH. Because of this, it is not recommended to run
performance critical applications that generate a lot of output in the
foreground over a slow client connection. Instead, users should use the
`docker logs` command to get access to the logs.


## Override the detach sequence

If you want, you can configure an override the Docker key sequence for detach.
This is useful if the Docker default sequence conflicts with key sequence you
use for other applications. There are two ways to define your own detach key
sequence, as a per-container override or as a configuration property on  your
entire configuration.

To override the sequence for an individual container, use the
`--detach-keys="<sequence>"` flag with the `docker attach` command. The format of
the `<sequence>` is either a letter [a-Z], or the `ctrl-` combined with any of
the following:

* `a-z` (a single lowercase alpha character )
* `@` (at sign)
* `[` (left bracket)
* `\\` (two backward slashes)
*  `_` (underscore)
* `^` (caret)

These `a`, `ctrl-a`, `X`, or `ctrl-\\` values are all examples of valid key
sequences. To configure a different configuration default key sequence for all
containers, see [**Configuration file** section](cli.md#configuration-files).

#### Examples

    $ docker run -d --name topdemo ubuntu /usr/bin/top -b
    $ docker attach topdemo
    top - 02:05:52 up  3:05,  0 users,  load average: 0.01, 0.02, 0.05
    Tasks:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
    Cpu(s):  0.1%us,  0.2%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
    Mem:    373572k total,   355560k used,    18012k free,    27872k buffers
    Swap:   786428k total,        0k used,   786428k free,   221740k cached

    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
     1 root      20   0 17200 1116  912 R    0  0.3   0:00.03 top

     top - 02:05:55 up  3:05,  0 users,  load average: 0.01, 0.02, 0.05
     Tasks:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
     Cpu(s):  0.0%us,  0.2%sy,  0.0%ni, 99.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
     Mem:    373572k total,   355244k used,    18328k free,    27872k buffers
     Swap:   786428k total,        0k used,   786428k free,   221776k cached

       PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
           1 root      20   0 17208 1144  932 R    0  0.3   0:00.03 top


     top - 02:05:58 up  3:06,  0 users,  load average: 0.01, 0.02, 0.05
     Tasks:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
     Cpu(s):  0.2%us,  0.3%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
     Mem:    373572k total,   355780k used,    17792k free,    27880k buffers
     Swap:   786428k total,        0k used,   786428k free,   221776k cached

     PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
          1 root      20   0 17208 1144  932 R    0  0.3   0:00.03 top
    ^C$
    $ echo $?
    0
    $ docker ps -a | grep topdemo
    7998ac8581f9        ubuntu:14.04        "/usr/bin/top -b"   38 seconds ago      Exited (0) 21 seconds ago                          topdemo

And in this second example, you can see the exit code returned by the `bash`
process is returned by the `docker attach` command to its caller too:

    $ docker run --name test -d -it debian
    275c44472aebd77c926d4527885bb09f2f6db21d878c75f0a1c212c03d3bcfab
    $ docker attach test
    root@f38c87f2a42d:/# exit 13
    exit
    $ echo $?
    13
    $ docker ps -a | grep test
    275c44472aeb        debian:7            "/bin/bash"         26 seconds ago      Exited (13) 17 seconds ago                         test
                                                                                                                                                                        go/src/github.com/docker/docker/docs/reference/commandline/build.md                                 0100644 0000000 0000000 00000040540 13101060260 024003  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/build/
description: The build command description and usage
keywords:
- build, docker, image
title: docker build
---

```markdown
Usage:  docker build [OPTIONS] PATH | URL | -

Build an image from a Dockerfile

Options:
      --build-arg value         Set build-time variables (default [])
      --cgroup-parent string    Optional parent cgroup for the container
      --cpu-period int          Limit the CPU CFS (Completely Fair Scheduler) period
      --cpu-quota int           Limit the CPU CFS (Completely Fair Scheduler) quota
  -c, --cpu-shares int          CPU shares (relative weight)
      --cpuset-cpus string      CPUs in which to allow execution (0-3, 0,1)
      --cpuset-mems string      MEMs in which to allow execution (0-3, 0,1)
      --disable-content-trust   Skip image verification (default true)
  -f, --file string             Name of the Dockerfile (Default is 'PATH/Dockerfile')
      --force-rm                Always remove intermediate containers
      --help                    Print usage
      --isolation string        Container isolation technology
      --label value             Set metadata for an image (default [])
  -m, --memory string           Memory limit
      --memory-swap string      Swap limit equal to memory plus swap: '-1' to enable unlimited swap
      --no-cache                Do not use cache when building the image
      --pull                    Always attempt to pull a newer version of the image
  -q, --quiet                   Suppress the build output and print image ID on success
      --rm                      Remove intermediate containers after a successful build (default true)
      --shm-size string         Size of /dev/shm, default value is 64MB.
                                The format is `<number><unit>`. `number` must be greater than `0`.
                                Unit is optional and can be `b` (bytes), `k` (kilobytes), `m` (megabytes),
                                or `g` (gigabytes). If you omit the unit, the system uses bytes.
  -t, --tag value               Name and optionally a tag in the 'name:tag' format (default [])
      --ulimit value            Ulimit options (default [])
```

Builds Docker images from a Dockerfile and a "context". A build's context is
the files located in the specified `PATH` or `URL`. The build process can refer
to any of the files in the context. For example, your build can use an
[*ADD*](../builder.md#add) instruction to reference a file in the
context.

The `URL` parameter can refer to three kinds of resources: Git repositories,
pre-packaged tarball contexts and plain text files.

### Git repositories

When the `URL` parameter points to the location of a Git repository, the
repository acts as the build context. The system recursively clones the
repository and its submodules using a `git clone --depth 1 --recursive`
command. This command runs in a temporary directory on your local host. After
the command succeeds, the directory is sent to the Docker daemon as the
context. Local clones give you the ability to access private repositories using
local user credentials, VPN's, and so forth.

Git URLs accept context configuration in their fragment section, separated by a
colon `:`.  The first part represents the reference that Git will check out,
this can be either a branch, a tag, or a commit SHA. The second part represents
a subdirectory inside the repository that will be used as a build context.

For example, run this command to use a directory called `docker` in the branch
`container`:

```bash
$ docker build https://github.com/docker/rootfs.git#container:docker
```

The following table represents all the valid suffixes with their build
contexts:

Build Syntax Suffix             | Commit Used           | Build Context Used
--------------------------------|-----------------------|-------------------
`myrepo.git`                    | `refs/heads/master`   | `/`
`myrepo.git#mytag`              | `refs/tags/mytag`     | `/`
`myrepo.git#mybranch`           | `refs/heads/mybranch` | `/`
`myrepo.git#abcdef`             | `sha1 = abcdef`       | `/`
`myrepo.git#:myfolder`          | `refs/heads/master`   | `/myfolder`
`myrepo.git#master:myfolder`    | `refs/heads/master`   | `/myfolder`
`myrepo.git#mytag:myfolder`     | `refs/tags/mytag`     | `/myfolder`
`myrepo.git#mybranch:myfolder`  | `refs/heads/mybranch` | `/myfolder`
`myrepo.git#abcdef:myfolder`    | `sha1 = abcdef`       | `/myfolder`


### Tarball contexts

If you pass an URL to a remote tarball, the URL itself is sent to the daemon:

```bash
$ docker build http://server/context.tar.gz
```

The download operation will be performed on the host the Docker daemon is
running on, which is not necessarily the same host from which the build command
is being issued. The Docker daemon will fetch `context.tar.gz` and use it as the
build context. Tarball contexts must be tar archives conforming to the standard
`tar` UNIX format and can be compressed with any one of the 'xz', 'bzip2',
'gzip' or 'identity' (no compression) formats.

### Text files

Instead of specifying a context, you can pass a single `Dockerfile` in the
`URL` or pipe the file in via `STDIN`. To pipe a `Dockerfile` from `STDIN`:

```bash
$ docker build - < Dockerfile
```

With Powershell on Windows, you can run:

```powershell
Get-Content Dockerfile | docker build -
```

If you use `STDIN` or specify a `URL` pointing to a plain text file, the system
places the contents into a file called `Dockerfile`, and any `-f`, `--file`
option is ignored. In this scenario, there is no context.

By default the `docker build` command will look for a `Dockerfile` at the root
of the build context. The `-f`, `--file`, option lets you specify the path to
an alternative file to use instead. This is useful in cases where the same set
of files are used for multiple builds. The path must be to a file within the
build context. If a relative path is specified then it is interpreted as
relative to the root of the context.

In most cases, it's best to put each Dockerfile in an empty directory. Then,
add to that directory only the files needed for building the Dockerfile. To
increase the build's performance, you can exclude files and directories by
adding a `.dockerignore` file to that directory as well. For information on
creating one, see the [.dockerignore file](../builder.md#dockerignore-file).

If the Docker client loses connection to the daemon, the build is canceled.
This happens if you interrupt the Docker client with `CTRL-c` or if the Docker
client is killed for any reason. If the build initiated a pull which is still
running at the time the build is cancelled, the pull is cancelled as well.

## Return code

On a successful build, a return code of success `0` will be returned.  When the
build fails, a non-zero failure code will be returned.

There should be informational output of the reason for failure output to
`STDERR`:

```bash
$ docker build -t fail .

Sending build context to Docker daemon 2.048 kB
Sending build context to Docker daemon
Step 1 : FROM busybox
 ---> 4986bf8c1536
Step 2 : RUN exit 13
 ---> Running in e26670ec7a0a
INFO[0000] The command [/bin/sh -c exit 13] returned a non-zero code: 13
$ echo $?
1
```

See also:

[*Dockerfile Reference*](../builder.md).

## Examples

### Build with PATH

```bash
$ docker build .

Uploading context 10240 bytes
Step 1 : FROM busybox
Pulling repository busybox
 ---> e9aa60c60128MB/2.284 MB (100%) endpoint: https://cdn-registry-1.docker.io/v1/
Step 2 : RUN ls -lh /
 ---> Running in 9c9e81692ae9
total 24
drwxr-xr-x    2 root     root        4.0K Mar 12  2013 bin
drwxr-xr-x    5 root     root        4.0K Oct 19 00:19 dev
drwxr-xr-x    2 root     root        4.0K Oct 19 00:19 etc
drwxr-xr-x    2 root     root        4.0K Nov 15 23:34 lib
lrwxrwxrwx    1 root     root           3 Mar 12  2013 lib64 -> lib
dr-xr-xr-x  116 root     root           0 Nov 15 23:34 proc
lrwxrwxrwx    1 root     root           3 Mar 12  2013 sbin -> bin
dr-xr-xr-x   13 root     root           0 Nov 15 23:34 sys
drwxr-xr-x    2 root     root        4.0K Mar 12  2013 tmp
drwxr-xr-x    2 root     root        4.0K Nov 15 23:34 usr
 ---> b35f4035db3f
Step 3 : CMD echo Hello world
 ---> Running in 02071fceb21b
 ---> f52f38b7823e
Successfully built f52f38b7823e
Removing intermediate container 9c9e81692ae9
Removing intermediate container 02071fceb21b
```

This example specifies that the `PATH` is `.`, and so all the files in the
local directory get `tar`d and sent to the Docker daemon. The `PATH` specifies
where to find the files for the "context" of the build on the Docker daemon.
Remember that the daemon could be running on a remote machine and that no
parsing of the Dockerfile happens at the client side (where you're running
`docker build`). That means that *all* the files at `PATH` get sent, not just
the ones listed to [*ADD*](../builder.md#add) in the Dockerfile.

The transfer of context from the local machine to the Docker daemon is what the
`docker` client means when you see the "Sending build context" message.

If you wish to keep the intermediate containers after the build is complete,
you must use `--rm=false`. This does not affect the build cache.

### Build with URL

```bash
$ docker build github.com/creack/docker-firefox
```

This will clone the GitHub repository and use the cloned repository as context.
The Dockerfile at the root of the repository is used as Dockerfile. You can
specify an arbitrary Git repository by using the `git://` or `git@` scheme.

```bash
$ docker build -f ctx/Dockerfile http://server/ctx.tar.gz

Downloading context: http://server/ctx.tar.gz [===================>]    240 B/240 B
Step 1 : FROM busybox
 ---> 8c2e06607696
Step 2 : ADD ctx/container.cfg /
 ---> e7829950cee3
Removing intermediate container b35224abf821
Step 3 : CMD /bin/ls
 ---> Running in fbc63d321d73
 ---> 3286931702ad
Removing intermediate container fbc63d321d73
Successfully built 377c409b35e4
```

This sends the URL `http://server/ctx.tar.gz` to the Docker daemon, which
downloads and extracts the referenced tarball. The `-f ctx/Dockerfile`
parameter specifies a path inside `ctx.tar.gz` to the `Dockerfile` that is used
to build the image. Any `ADD` commands in that `Dockerfile` that refer to local
paths must be relative to the root of the contents inside `ctx.tar.gz`. In the
example above, the tarball contains a directory `ctx/`, so the `ADD
ctx/container.cfg /` operation works as expected.

### Build with -

```bash
$ docker build - < Dockerfile
```

This will read a Dockerfile from `STDIN` without context. Due to the lack of a
context, no contents of any local directory will be sent to the Docker daemon.
Since there is no context, a Dockerfile `ADD` only works if it refers to a
remote URL.

```bash
$ docker build - < context.tar.gz
```

This will build an image for a compressed context read from `STDIN`.  Supported
formats are: bzip2, gzip and xz.

### Usage of .dockerignore

```bash
$ docker build .

Uploading context 18.829 MB
Uploading context
Step 1 : FROM busybox
 ---> 769b9341d937
Step 2 : CMD echo Hello world
 ---> Using cache
 ---> 99cc1ad10469
Successfully built 99cc1ad10469
$ echo ".git" > .dockerignore
$ docker build .
Uploading context  6.76 MB
Uploading context
Step 1 : FROM busybox
 ---> 769b9341d937
Step 2 : CMD echo Hello world
 ---> Using cache
 ---> 99cc1ad10469
Successfully built 99cc1ad10469
```

This example shows the use of the `.dockerignore` file to exclude the `.git`
directory from the context. Its effect can be seen in the changed size of the
uploaded context. The builder reference contains detailed information on
[creating a .dockerignore file](../builder.md#dockerignore-file)

### Tag image (-t)

```bash
$ docker build -t vieux/apache:2.0 .
```

This will build like the previous example, but it will then tag the resulting
image. The repository name will be `vieux/apache` and the tag will be `2.0`.
[Read more about valid tags](tag.md).

You can apply multiple tags to an image. For example, you can apply the `latest`
tag to a newly built image and add another tag that references a specific
version.
For example, to tag an image both as `whenry/fedora-jboss:latest` and
`whenry/fedora-jboss:v2.1`, use the following:

```bash
$ docker build -t whenry/fedora-jboss:latest -t whenry/fedora-jboss:v2.1 .
```
### Specify Dockerfile (-f)

```bash
$ docker build -f Dockerfile.debug .
```

This will use a file called `Dockerfile.debug` for the build instructions
instead of `Dockerfile`.

```bash
$ docker build -f dockerfiles/Dockerfile.debug -t myapp_debug .
$ docker build -f dockerfiles/Dockerfile.prod  -t myapp_prod .
```

The above commands will build the current build context (as specified by the
`.`) twice, once using a debug version of a `Dockerfile` and once using a
production version.

```bash
$ cd /home/me/myapp/some/dir/really/deep
$ docker build -f /home/me/myapp/dockerfiles/debug /home/me/myapp
$ docker build -f ../../../../dockerfiles/debug /home/me/myapp
```

These two `docker build` commands do the exact same thing. They both use the
contents of the `debug` file instead of looking for a `Dockerfile` and will use
`/home/me/myapp` as the root of the build context. Note that `debug` is in the
directory structure of the build context, regardless of how you refer to it on
the command line.

> **Note:**
> `docker build` will return a `no such file or directory` error if the
> file or directory does not exist in the uploaded context. This may
> happen if there is no context, or if you specify a file that is
> elsewhere on the Host system. The context is limited to the current
> directory (and its children) for security reasons, and to ensure
> repeatable builds on remote Docker hosts. This is also the reason why
> `ADD ../file` will not work.

### Optional parent cgroup (--cgroup-parent)

When `docker build` is run with the `--cgroup-parent` option the containers
used in the build will be run with the [corresponding `docker run`
flag](../run.md#specifying-custom-cgroups).

### Set ulimits in container (--ulimit)

Using the `--ulimit` option with `docker build` will cause each build step's
container to be started using those [`--ulimit`
flag values](./run.md#set-ulimits-in-container-ulimit).

### Set build-time variables (--build-arg)

You can use `ENV` instructions in a Dockerfile to define variable
values. These values persist in the built image. However, often
persistence is not what you want. Users want to specify variables differently
depending on which host they build an image on.

A good example is `http_proxy` or source versions for pulling intermediate
files. The `ARG` instruction lets Dockerfile authors define values that users
can set at build-time using the  `--build-arg` flag:

```bash
$ docker build --build-arg HTTP_PROXY=http://10.20.30.2:1234 .
```

This flag allows you to pass the build-time variables that are
accessed like regular environment variables in the `RUN` instruction of the
Dockerfile. Also, these values don't persist in the intermediate or final images
like `ENV` values do.

Using this flag will not alter the output you see when the `ARG` lines from the
Dockerfile are echoed during the build process.

For detailed information on using `ARG` and `ENV` instructions, see the
[Dockerfile reference](../builder.md).

### Specify isolation technology for container (--isolation)

This option is useful in situations where you are running Docker containers on
Windows. The `--isolation=<value>` option sets a container's isolation
technology. On Linux, the only supported is the `default` option which uses
Linux namespaces. On Microsoft Windows, you can specify these values:


| Value     | Description                                                                                                                                                   |
|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `default` | Use the value specified by the Docker daemon's `--exec-opt` . If the `daemon` does not specify an isolation technology, Microsoft Windows uses `process` as its default value.  |
| `process` | Namespace isolation only.                                                                                                                                     |
| `hyperv`  | Hyper-V hypervisor partition-based isolation.                                                                                                                 |

Specifying the `--isolation` flag without a value is the same as setting `--isolation="default"`.
                                                                                                                                                                go/src/github.com/docker/docker/docs/reference/commandline/cli.md                                   0100644 0000000 0000000 00000020743 13101060260 023456  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/cli/
description: Docker's CLI command description and usage
keywords:
- Docker, Docker documentation, CLI,  command line
title: Use the Docker Engine command-line
---

To list available commands, either run `docker` with no parameters
or execute `docker help`:

```bash
$ docker
Usage: docker [OPTIONS] COMMAND [arg...]
       docker [ --help | -v | --version ]

A self-sufficient runtime for containers.

Options:

  --config=~/.docker              Location of client config files
  -D, --debug                     Enable debug mode
  -H, --host=[]                   Daemon socket(s) to connect to
  -h, --help                      Print usage
  -l, --log-level=info            Set the logging level
  --tls                           Use TLS; implied by --tlsverify
  --tlscacert=~/.docker/ca.pem    Trust certs signed only by this CA
  --tlscert=~/.docker/cert.pem    Path to TLS certificate file
  --tlskey=~/.docker/key.pem      Path to TLS key file
  --tlsverify                     Use TLS and verify the remote
  -v, --version                   Print version information and quit

Commands:
    attach    Attach to a running container
    # [‚Ä¶]
```

Depending on your Docker system configuration, you may be required to preface
each `docker` command with `sudo`. To avoid having to use `sudo` with the
`docker` command, your system administrator can create a Unix group called
`docker` and add users to it.

For more information about installing Docker or `sudo` configuration, refer to
the [installation](../../installation/index.md) instructions for your operating system.

## Environment variables

For easy reference, the following list of environment variables are supported
by the `docker` command line:

* `DOCKER_API_VERSION` The API version to use (e.g. `1.19`)
* `DOCKER_CONFIG` The location of your client configuration files.
* `DOCKER_CERT_PATH` The location of your authentication keys.
* `DOCKER_DRIVER` The graph driver to use.
* `DOCKER_HOST` Daemon socket to connect to.
* `DOCKER_NOWARN_KERNEL_VERSION` Prevent warnings that your Linux kernel is
  unsuitable for Docker.
* `DOCKER_RAMDISK` If set this will disable 'pivot_root'.
* `DOCKER_TLS_VERIFY` When set Docker uses TLS and verifies the remote.
* `DOCKER_CONTENT_TRUST` When set Docker uses notary to sign and verify images.
  Equates to `--disable-content-trust=false` for build, create, pull, push, run.
* `DOCKER_CONTENT_TRUST_SERVER` The URL of the Notary server to use. This defaults
  to the same URL as the registry.
* `DOCKER_TMPDIR` Location for temporary Docker files.

Because Docker is developed using 'Go', you can also use any environment
variables used by the 'Go' runtime. In particular, you may find these useful:

* `HTTP_PROXY`
* `HTTPS_PROXY`
* `NO_PROXY`

These Go environment variables are case-insensitive. See the
[Go specification](http://golang.org/pkg/net/http/) for details on these
variables.

## Configuration files

By default, the Docker command line stores its configuration files in a
directory called `.docker` within your `$HOME` directory. However, you can
specify a different location via the `DOCKER_CONFIG` environment variable
or the `--config` command line option. If both are specified, then the
`--config` option overrides the `DOCKER_CONFIG` environment variable.
For example:

    docker --config ~/testconfigs/ ps

Instructs Docker to use the configuration files in your `~/testconfigs/`
directory when running the `ps` command.

Docker manages most of the files in the configuration directory
and you should not modify them. However, you *can modify* the
`config.json` file to control certain aspects of how the `docker`
command behaves.

Currently, you can modify the `docker` command behavior using environment
variables or command-line options. You can also use options within
`config.json` to modify some of the same behavior. When using these
mechanisms, you must keep in mind the order of precedence among them. Command
line options override environment variables and environment variables override
properties you specify in a `config.json` file.

The `config.json` file stores a JSON encoding of several properties:

The property `HttpHeaders` specifies a set of headers to include in all messages
sent from the Docker client to the daemon. Docker does not try to interpret or
understand these header; it simply puts them into the messages. Docker does
not allow these headers to change any headers it sets for itself.

The property `psFormat` specifies the default format for `docker ps` output.
When the `--format` flag is not provided with the `docker ps` command,
Docker's client uses this property. If this property is not set, the client
falls back to the default table format. For a list of supported formatting
directives, see the
[**Formatting** section in the `docker ps` documentation](ps.md)

Once attached to a container, users detach from it and leave it running using
the using `CTRL-p CTRL-q` key sequence. This detach key sequence is customizable
using the `detachKeys` property. Specify a `<sequence>` value for the
property. The format of the `<sequence>` is a comma-separated list of either
a letter [a-Z], or the `ctrl-` combined with any of the following:

* `a-z` (a single lowercase alpha character )
* `@` (at sign)
* `[` (left bracket)
* `\\` (two backward slashes)
*  `_` (underscore)
* `^` (caret)

Your customization applies to all containers started in with your Docker client.
Users can override your custom or the default key sequence on a per-container
basis. To do this, the user specifies the `--detach-keys` flag with the `docker
attach`, `docker exec`, `docker run` or `docker start` command.

The property `imagesFormat` specifies the default format for `docker images` output.
When the `--format` flag is not provided with the `docker images` command,
Docker's client uses this property. If this property is not set, the client
falls back to the default table format. For a list of supported formatting
directives, see the [**Formatting** section in the `docker images` documentation](images.md)

Following is a sample `config.json` file:

    {% raw %}
    {
      "HttpHeaders": {
        "MyHeader": "MyValue"
      },
      "psFormat": "table {{.ID}}\\t{{.Image}}\\t{{.Command}}\\t{{.Labels}}",
      "imagesFormat": "table {{.ID}}\\t{{.Repository}}\\t{{.Tag}}\\t{{.CreatedAt}}",
      "detachKeys": "ctrl-e,e"
    }
    {% endraw %}

### Notary

If using your own notary server and a self-signed certificate or an internal
Certificate Authority, you need to place the certificate at
`tls/<registry_url>/ca.crt` in your docker config directory.

Alternatively you can trust the certificate globally by adding it to your system's
list of root Certificate Authorities.

## Help

To list the help on any command just execute the command, followed by the
`--help` option.

    $ docker run --help

    Usage: docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

    Run a command in a new container

      -a, --attach=[]            Attach to STDIN, STDOUT or STDERR
      --cpu-shares=0             CPU shares (relative weight)
    ...

## Option types

Single character command line options can be combined, so rather than
typing `docker run -i -t --name test busybox sh`,
you can write `docker run -it --name test busybox sh`.

### Boolean

Boolean options take the form `-d=false`. The value you see in the help text is
the default value which is set if you do **not** specify that flag. If you
specify a Boolean flag without a value, this will set the flag to `true`,
irrespective of the default value.

For example, running `docker run -d` will set the value to `true`, so your
container **will** run in "detached" mode, in the background.

Options which default to `true` (e.g., `docker build --rm=true`) can only be
set to the non-default value by explicitly setting them to `false`:

    $ docker build --rm=false .

### Multi

You can specify options like `-a=[]` multiple times in a single command line,
for example in these commands:

    $ docker run -a stdin -a stdout -i -t ubuntu /bin/bash
    $ docker run -a stdin -a stdout -a stderr ubuntu /bin/ls

Sometimes, multiple options can call for a more complex value string as for
`-v`:

    $ docker run -v /host:/container example/mysql

> **Note:**
> Do not use the `-t` and `-a stderr` options together due to
> limitations in the `pty` implementation. All `stderr` in `pty` mode
> simply goes to `stdout`.

### Strings and Integers

Options like `--name=""` expect a string, and they
can only be specified once. Options like `-c=0`
expect an integer, and they can only be specified once.
                             go/src/github.com/docker/docker/docs/reference/commandline/commit.md                                0100644 0000000 0000000 00000010004 13101060260 024164  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/commit/
description: The commit command description and usage
keywords:
- commit, file, changes
title: docker commit
---

```markdown
Usage:  docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]

Create a new image from a container's changes

Options:
  -a, --author string    Author (e.g., "John Hannibal Smith <hannibal@a-team.com>")
  -c, --change value     Apply Dockerfile instruction to the created image (default [])
      --help             Print usage
  -m, --message string   Commit message
  -p, --pause            Pause container during commit (default true)
```

It can be useful to commit a container's file changes or settings into a new
image. This allows you debug a container by running an interactive shell, or to
export a working dataset to another server. Generally, it is better to use
Dockerfiles to manage your images in a documented and maintainable way.
[Read more about valid image names and tags](tag.md).

The commit operation will not include any data contained in
volumes mounted inside the container.

By default, the container being committed and its processes will be paused
while the image is committed. This reduces the likelihood of encountering data
corruption during the process of creating the commit.  If this behavior is
undesired, set the `--pause` option to false.

The `--change` option will apply `Dockerfile` instructions to the image that is
created.  Supported `Dockerfile` instructions:
`CMD`|`ENTRYPOINT`|`ENV`|`EXPOSE`|`LABEL`|`ONBUILD`|`USER`|`VOLUME`|`WORKDIR`

## Commit a container

    $ docker ps
    ID                  IMAGE               COMMAND             CREATED             STATUS              PORTS
    c3f279d17e0a        ubuntu:12.04        /bin/bash           7 days ago          Up 25 hours
    197387f1b436        ubuntu:12.04        /bin/bash           7 days ago          Up 25 hours
    $ docker commit c3f279d17e0a  svendowideit/testimage:version3
    f5283438590d
    $ docker images
    REPOSITORY                        TAG                 ID                  CREATED             SIZE
    svendowideit/testimage            version3            f5283438590d        16 seconds ago      335.7 MB

## Commit a container with new configurations

    {% raw %}
    $ docker ps
    ID                  IMAGE               COMMAND             CREATED             STATUS              PORTS
    c3f279d17e0a        ubuntu:12.04        /bin/bash           7 days ago          Up 25 hours
    197387f1b436        ubuntu:12.04        /bin/bash           7 days ago          Up 25 hours
    $ docker inspect -f "{{ .Config.Env }}" c3f279d17e0a
    [HOME=/ PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin]
    $ docker commit --change "ENV DEBUG true" c3f279d17e0a  svendowideit/testimage:version3
    f5283438590d
    $ docker inspect -f "{{ .Config.Env }}" f5283438590d
    [HOME=/ PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin DEBUG=true]
    {% endraw %}

## Commit a container with new `CMD` and `EXPOSE` instructions

    $ docker ps
    ID                  IMAGE               COMMAND             CREATED             STATUS              PORTS
    c3f279d17e0a        ubuntu:12.04        /bin/bash           7 days ago          Up 25 hours
    197387f1b436        ubuntu:12.04        /bin/bash           7 days ago          Up 25 hours

    $ docker commit --change='CMD ["apachectl", "-DFOREGROUND"]' -c "EXPOSE 80" c3f279d17e0a  svendowideit/testimage:version4
    f5283438590d

    $ docker run -d svendowideit/testimage:version4
    89373736e2e7f00bc149bd783073ac43d0507da250e999f3f1036e0db60817c0

    $ docker ps
    ID                  IMAGE               COMMAND                 CREATED             STATUS              PORTS
    89373736e2e7        testimage:version4  "apachectl -DFOREGROU"  3 seconds ago       Up 2 seconds        80/tcp
    c3f279d17e0a        ubuntu:12.04        /bin/bash               7 days ago          Up 25 hours
    197387f1b436        ubuntu:12.04        /bin/bash               7 days ago          Up 25 hours
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            go/src/github.com/docker/docker/docs/reference/commandline/cp.md                                    0100644 0000000 0000000 00000011351 13101060260 023304  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/cp/
description: The cp command description and usage
keywords:
- copy, container, files, folders
title: docker cp
---

```markdown
Usage:  docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH|-
        docker cp [OPTIONS] SRC_PATH|- CONTAINER:DEST_PATH

Copy files/folders between a container and the local filesystem

Use '-' as the source to read a tar archive from stdin
and extract it to a directory destination in a container.
Use '-' as the destination to stream a tar archive of a
container source to stdout.

Options:
  -L, --follow-link   Always follow symbol link in SRC_PATH
      --help          Print usage
```

The `docker cp` utility copies the contents of `SRC_PATH` to the `DEST_PATH`.
You can copy from the container's file system to the local machine or the
reverse, from the local filesystem to the container. If `-` is specified for
either the `SRC_PATH` or `DEST_PATH`, you can also stream a tar archive from
`STDIN` or to `STDOUT`. The `CONTAINER` can be a running or stopped container.
The `SRC_PATH` or `DEST_PATH` can be a file or directory.

The `docker cp` command assumes container paths are relative to the container's
`/` (root) directory. This means supplying the initial forward slash is optional;
The command sees `compassionate_darwin:/tmp/foo/myfile.txt` and
`compassionate_darwin:tmp/foo/myfile.txt` as identical. Local machine paths can
be an absolute or relative value. The command interprets a local machine's
relative paths as relative to the current working directory where `docker cp` is
run.

The `cp` command behaves like the Unix `cp -a` command in that directories are
copied recursively with permissions preserved if possible. Ownership is set to
the user and primary group at the destination. For example, files copied to a
container are created with `UID:GID` of the root user. Files copied to the local
machine are created with the `UID:GID` of the user which invoked the `docker cp`
command.  If you specify the `-L` option, `docker cp` follows any symbolic link
in the `SRC_PATH`.  `docker cp` does *not* create parent directories for
`DEST_PATH` if they do not exist.

Assuming a path separator of `/`, a first argument of `SRC_PATH` and second
argument of `DEST_PATH`, the behavior is as follows:

- `SRC_PATH` specifies a file
    - `DEST_PATH` does not exist
        - the file is saved to a file created at `DEST_PATH`
    - `DEST_PATH` does not exist and ends with `/`
        - Error condition: the destination directory must exist.
    - `DEST_PATH` exists and is a file
        - the destination is overwritten with the source file's contents
    - `DEST_PATH` exists and is a directory
        - the file is copied into this directory using the basename from
          `SRC_PATH`
- `SRC_PATH` specifies a directory
    - `DEST_PATH` does not exist
        - `DEST_PATH` is created as a directory and the *contents* of the source
           directory are copied into this directory
    - `DEST_PATH` exists and is a file
        - Error condition: cannot copy a directory to a file
    - `DEST_PATH` exists and is a directory
        - `SRC_PATH` does not end with `/.`
            - the source directory is copied into this directory
        - `SRC_PATH` does end with `/.`
            - the *content* of the source directory is copied into this
              directory

The command requires `SRC_PATH` and `DEST_PATH` to exist according to the above
rules. If `SRC_PATH` is local and is a symbolic link, the symbolic link, not
the target, is copied by default. To copy the link target and not the link, specify
the `-L` option.

A colon (`:`) is used as a delimiter between `CONTAINER` and its path. You can
also use `:` when specifying paths to a `SRC_PATH` or `DEST_PATH` on a local
machine, for example  `file:name.txt`. If you use a `:` in a local machine path,
you must be explicit with a relative or absolute path, for example:

    `/path/to/file:name.txt` or `./file:name.txt`

It is not possible to copy certain system files such as resources under
`/proc`, `/sys`, `/dev`, [tmpfs](run.md#mount-tmpfs-tmpfs), and mounts created by
the user in the container. However, you can still copy such files by manually
running `tar` in `docker exec`. For example (consider `SRC_PATH` and `DEST_PATH`
are directories):

    $ docker exec foo tar Ccf $(dirname SRC_PATH) - $(basename SRC_PATH) | tar Cxf DEST_PATH -

or

    $ tar Ccf $(dirname SRC_PATH) - $(basename SRC_PATH) | docker exec -i foo tar Cxf DEST_PATH -


Using `-` as the `SRC_PATH` streams the contents of `STDIN` as a tar archive.
The command extracts the content of the tar to the `DEST_PATH` in container's
filesystem. In this case, `DEST_PATH` must specify a directory. Using `-` as
the `DEST_PATH` streams the contents of the resource as a tar archive to `STDOUT`.
                                                                                                                                                                                                                                                                                       go/src/github.com/docker/docker/docs/reference/commandline/create.md                                0100644 0000000 0000000 00000027370 13101060260 024155  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/create/
description: The create command description and usage
keywords:
- docker, create, container
title: docker create
---

Creates a new container.

```markdown
Usage:  docker create [OPTIONS] IMAGE [COMMAND] [ARG...]

Create a new container

Options:
      --add-host value              Add a custom host-to-IP mapping (host:ip) (default [])
  -a, --attach value                Attach to STDIN, STDOUT or STDERR (default [])
      --blkio-weight value          Block IO (relative weight), between 10 and 1000
      --blkio-weight-device value   Block IO weight (relative device weight) (default [])
      --cap-add value               Add Linux capabilities (default [])
      --cap-drop value              Drop Linux capabilities (default [])
      --cgroup-parent string        Optional parent cgroup for the container
      --cidfile string              Write the container ID to the file
      --cpu-percent int             CPU percent (Windows only)
      --cpu-period int              Limit CPU CFS (Completely Fair Scheduler) period
      --cpu-quota int               Limit CPU CFS (Completely Fair Scheduler) quota
  -c, --cpu-shares int              CPU shares (relative weight)
      --cpuset-cpus string          CPUs in which to allow execution (0-3, 0,1)
      --cpuset-mems string          MEMs in which to allow execution (0-3, 0,1)
      --device value                Add a host device to the container (default [])
      --device-read-bps value       Limit read rate (bytes per second) from a device (default [])
      --device-read-iops value      Limit read rate (IO per second) from a device (default [])
      --device-write-bps value      Limit write rate (bytes per second) to a device (default [])
      --device-write-iops value     Limit write rate (IO per second) to a device (default [])
      --disable-content-trust       Skip image verification (default true)
      --dns value                   Set custom DNS servers (default [])
      --dns-opt value               Set DNS options (default [])
      --dns-search value            Set custom DNS search domains (default [])
      --entrypoint string           Overwrite the default ENTRYPOINT of the image
  -e, --env value                   Set environment variables (default [])
      --env-file value              Read in a file of environment variables (default [])
      --expose value                Expose a port or a range of ports (default [])
      --group-add value             Add additional groups to join (default [])
      --health-cmd string           Command to run to check health
      --health-interval duration    Time between running the check
      --health-retries int          Consecutive failures needed to report unhealthy
      --health-timeout duration     Maximum time to allow one check to run
      --help                        Print usage
  -h, --hostname string             Container host name
  -i, --interactive                 Keep STDIN open even if not attached
      --io-maxbandwidth string      Maximum IO bandwidth limit for the system drive (Windows only)
      --io-maxiops uint             Maximum IOps limit for the system drive (Windows only)
      --ip string                   Container IPv4 address (e.g. 172.30.100.104)
      --ip6 string                  Container IPv6 address (e.g. 2001:db8::33)
      --ipc string                  IPC namespace to use
      --isolation string            Container isolation technology
      --kernel-memory string        Kernel memory limit
  -l, --label value                 Set meta data on a container (default [])
      --label-file value            Read in a line delimited file of labels (default [])
      --link value                  Add link to another container (default [])
      --link-local-ip value         Container IPv4/IPv6 link-local addresses (default [])
      --log-driver string           Logging driver for the container
      --log-opt value               Log driver options (default [])
      --mac-address string          Container MAC address (e.g. 92:d0:c6:0a:29:33)
  -m, --memory string               Memory limit
      --memory-reservation string   Memory soft limit
      --memory-swap string          Swap limit equal to memory plus swap: '-1' to enable unlimited swap
      --memory-swappiness int       Tune container memory swappiness (0 to 100) (default -1)
      --name string                 Assign a name to the container
      --network-alias value         Add network-scoped alias for the container (default [])
      --network string              Connect a container to a network (default "default")
                                    'bridge': create a network stack on the default Docker bridge
                                    'none': no networking
                                    'container:<name|id>': reuse another container's network stack
                                    'host': use the Docker host network stack
                                    '<network-name>|<network-id>': connect to a user-defined network
      --no-healthcheck              Disable any container-specified HEALTHCHECK
      --oom-kill-disable            Disable OOM Killer
      --oom-score-adj int           Tune host's OOM preferences (-1000 to 1000)
      --pid string                  PID namespace to use
      --pids-limit int              Tune container pids limit (set -1 for unlimited), kernel >= 4.3
      --privileged                  Give extended privileges to this container
  -p, --publish value               Publish a container's port(s) to the host (default [])
  -P, --publish-all                 Publish all exposed ports to random ports
      --read-only                   Mount the container's root filesystem as read only
      --restart string              Restart policy to apply when a container exits (default "no")
                                    Possible values are: no, on-failure[:max-retry], always, unless-stopped
      --runtime string              Runtime to use for this container
      --security-opt value          Security Options (default [])
      --shm-size string             Size of /dev/shm, default value is 64MB.
                                    The format is `<number><unit>`. `number` must be greater than `0`.
                                    Unit is optional and can be `b` (bytes), `k` (kilobytes), `m` (megabytes),
                                    or `g` (gigabytes). If you omit the unit, the system uses bytes.
      --stop-signal string          Signal to stop a container, SIGTERM by default (default "SIGTERM")
      --storage-opt value           Storage driver options for the container (default [])
      --sysctl value                Sysctl options (default map[])
      --tmpfs value                 Mount a tmpfs directory (default [])
  -t, --tty                         Allocate a pseudo-TTY
      --ulimit value                Ulimit options (default [])
  -u, --user string                 Username or UID (format: <name|uid>[:<group|gid>])
      --userns string               User namespace to use
                                    'host': Use the Docker host user namespace
                                    '': Use the Docker daemon user namespace specified by `--userns-remap` option.
      --uts string                  UTS namespace to use
  -v, --volume value                Bind mount a volume (default []). The format
                                    is `[host-src:]container-dest[:<options>]`.
                                    The comma-delimited `options` are [rw|ro],
                                    [z|Z], [[r]shared|[r]slave|[r]private], and
                                    [nocopy]. The 'host-src' is an absolute path
                                    or a name value.
      --volume-driver string        Optional volume driver for the container
      --volumes-from value          Mount volumes from the specified container(s) (default [])
  -w, --workdir string              Working directory inside the container
```

The `docker create` command creates a writeable container layer over the
specified image and prepares it for running the specified command.  The
container ID is then printed to `STDOUT`.  This is similar to `docker run -d`
except the container is never started.  You can then use the
`docker start <container_id>` command to start the container at any point.

This is useful when you want to set up a container configuration ahead of time
so that it is ready to start when you need it. The initial status of the
new container is `created`.

Please see the [run command](run.md) section and the [Docker run reference](../run.md) for more details.

## Examples

    $ docker create -t -i fedora bash
    6d8af538ec541dd581ebc2a24153a28329acb5268abe5ef868c1f1a261221752
    $ docker start -a -i 6d8af538ec5
    bash-4.2#

As of v1.4.0 container volumes are initialized during the `docker create` phase
(i.e., `docker run` too). For example, this allows you to `create` the `data`
volume container, and then use it from another container:

    $ docker create -v /data --name data ubuntu
    240633dfbb98128fa77473d3d9018f6123b99c454b3251427ae190a7d951ad57
    $ docker run --rm --volumes-from data ubuntu ls -la /data
    total 8
    drwxr-xr-x  2 root root 4096 Dec  5 04:10 .
    drwxr-xr-x 48 root root 4096 Dec  5 04:11 ..

Similarly, `create` a host directory bind mounted volume container, which can
then be used from the subsequent container:

    $ docker create -v /home/docker:/docker --name docker ubuntu
    9aa88c08f319cd1e4515c3c46b0de7cc9aa75e878357b1e96f91e2c773029f03
    $ docker run --rm --volumes-from docker ubuntu ls -la /docker
    total 20
    drwxr-sr-x  5 1000 staff  180 Dec  5 04:00 .
    drwxr-xr-x 48 root root  4096 Dec  5 04:13 ..
    -rw-rw-r--  1 1000 staff 3833 Dec  5 04:01 .ash_history
    -rw-r--r--  1 1000 staff  446 Nov 28 11:51 .ashrc
    -rw-r--r--  1 1000 staff   25 Dec  5 04:00 .gitconfig
    drwxr-sr-x  3 1000 staff   60 Dec  1 03:28 .local
    -rw-r--r--  1 1000 staff  920 Nov 28 11:51 .profile
    drwx--S---  2 1000 staff  460 Dec  5 00:51 .ssh
    drwxr-xr-x 32 1000 staff 1140 Dec  5 04:01 docker

Set storage driver options per container.

    $ docker create -it --storage-opt size=120G fedora /bin/bash

This (size) will allow to set the container rootfs size to 120G at creation time.
User cannot pass a size less than the Default BaseFS Size. This option is only
available for the `devicemapper`, `btrfs`, and `zfs` graph drivers.

### Specify isolation technology for container (--isolation)

This option is useful in situations where you are running Docker containers on
Windows. The `--isolation=<value>` option sets a container's isolation
technology. On Linux, the only supported is the `default` option which uses
Linux namespaces. On Microsoft Windows, you can specify these values:


| Value     | Description                                                                                                                                                   |
|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `default` | Use the value specified by the Docker daemon's `--exec-opt` . If the `daemon` does not specify an isolation technology, Microsoft Windows uses `process` as its default value if the
daemon is running on Windows server, or `hyperv` if running on Windows client.  |
| `process` | Namespace isolation only.                                                                                                                                     |
| `hyperv`   | Hyper-V hypervisor partition-based isolation.                                                                                                                  |

Specifying the `--isolation` flag without a value is the same as setting `--isolation="default"`.
                                                                                                                                                                                                                                                                        go/src/github.com/docker/docker/docs/reference/commandline/deploy.md                                0100644 0000000 0000000 00000004433 13101060260 024201  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/deploy/
advisory: experimental
description: The deploy command description and usage
keywords:
- stack, deploy
title: docker deploy
---

```markdown
Usage:  docker deploy [OPTIONS] STACK

Create and update a stack from a Distributed Application Bundle (DAB)

Options:
      --file   string        Path to a Distributed Application Bundle file (Default: STACK.dab)
      --help                 Print usage
      --with-registry-auth   Send registry authentication details to swarm agents
```

Create and update a stack from a `dab` file. This command has to be
run targeting a manager node.

```bash
$ docker deploy vossibility-stack
Loading bundle from vossibility-stack.dab
Creating service vossibility-stack_elasticsearch
Creating service vossibility-stack_kibana
Creating service vossibility-stack_logstash
Creating service vossibility-stack_lookupd
Creating service vossibility-stack_nsqd
Creating service vossibility-stack_vossibility-collector
```

You can verify that the services were correctly created:

```bash
$ docker service ls
ID            NAME                                     REPLICAS  IMAGE
COMMAND
29bv0vnlm903  vossibility-stack_lookupd                1 nsqio/nsq@sha256:eeba05599f31eba418e96e71e0984c3dc96963ceb66924dd37a47bf7ce18a662 /nsqlookupd
4awt47624qwh  vossibility-stack_nsqd                   1 nsqio/nsq@sha256:eeba05599f31eba418e96e71e0984c3dc96963ceb66924dd37a47bf7ce18a662 /nsqd --data-path=/data --lookupd-tcp-address=lookupd:4160
4tjx9biia6fs  vossibility-stack_elasticsearch          1 elasticsearch@sha256:12ac7c6af55d001f71800b83ba91a04f716e58d82e748fa6e5a7359eed2301aa
7563uuzr9eys  vossibility-stack_kibana                 1 kibana@sha256:6995a2d25709a62694a937b8a529ff36da92ebee74bafd7bf00e6caf6db2eb03
9gc5m4met4he  vossibility-stack_logstash               1 logstash@sha256:2dc8bddd1bb4a5a34e8ebaf73749f6413c101b2edef6617f2f7713926d2141fe logstash -f /etc/logstash/conf.d/logstash.conf
axqh55ipl40h  vossibility-stack_vossibility-collector  1 icecrime/vossibility-collector@sha256:f03f2977203ba6253988c18d04061c5ec7aab46bca9dfd89a9a1fa4500989fba --config /config/config.toml --debug
```

## Related information

* [stack config](stack_config.md)
* [stack deploy](stack_deploy.md)
* [stack rm](stack_rm.md)
* [stack tasks](stack_tasks.md)
                                                                                                                                                                                                                                     go/src/github.com/docker/docker/docs/reference/commandline/diff.md                                  0100644 0000000 0000000 00000001345 13101060260 023614  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/diff/
description: The diff command description and usage
keywords:
- list, changed, files, container
title: docker diff
---

```markdown
Usage:  docker diff CONTAINER

Inspect changes on a container's filesystem

Options:
      --help   Print usage
```

List the changed files and directories in a container·æøs filesystem
 There are 3 events that are listed in the `diff`:

1. `A` - Add
2. `D` - Delete
3. `C` - Change

For example:

    $ docker diff 7bb0e258aefe

    C /dev
    A /dev/kmsg
    C /etc
    A /etc/mtab
    A /go
    A /go/src
    A /go/src/github.com
    A /go/src/github.com/docker
    A /go/src/github.com/docker/docker
    A /go/src/github.com/docker/docker/.git
    ....
                                                                                                                                                                                                                                                                                           go/src/github.com/docker/docker/docs/reference/commandline/docker_images.gif                        0100644 0000000 0000000 00000105711 13101060260 025647  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        GIF89aQEÊ     		
!!###))+++!--%22222(66788+;;;;;/@@?@@1CCCCCGHH6JJKKK9MM<RRTTT@WWWXXZZZC[[F``cccIddMiikkkPmmSqqsssZ{{{{{^ÄÄaÑÑÑÑÑeääãããhççkííìììoòòrõõõõõv°°§§§y••}™™´´´ÄÆÆÉ≥≥≥≥≥á∏∏ªªªäººé¡¡√√√ë≈≈î  ÀÀÀòœœõ”””””üÿÿ€€€¢››•··„„„ÎÎÎÆÌÌÛÛÛ˛˛˛                                                                                                                                             !˘	  Q ,    QE ˇÄPÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü†°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛ˇ 
H∞†¡É*\»∞°√á#JúH±¢≈ã3j‹»±£«è CäI≤§…ì(S™\…≤•Àó0c úI≥¶Õõ8sÍ‹…≥ßœü@É
J¥®—£Hì*] ¥©”ßP£JùJµ™’´X≥j› µ´◊Ø`√äK∂¨Ÿ≥h”™]À∂≠€∑pˇ„ ùK∑Æ›ªxÛÍ›À∑ØﬂøÄL∏∞·√à+^Ã∏±„«ê#KûLπ≤ÂÀò3kﬁÃπ≥Áœ†CãM∫¥È”®S´^Õ∫µÎ◊∞cÀûMª∂Ì€∏sÎﬁÕª∑Ôﬂ¿ÉNº∏Ò„»ì+_ŒºπÛÁ–£KüNΩ∫u“Mx∏8¢ª˜Ô‡√ãOæº˘ÛË…üp¡£…uÜ9*  P¿
¯ÛÎﬂœøøˇˇ (‡Ä˝A‡@ÛUê√{ÒÄ  Ã†ÑVh·Öf®·ÜvË·á*1√  ¿É5± ‚ã0∆(„å° <Å¢?G P 4)‰êDZàC±„ˇ>D‡ EF)Âî"· D,âOP@Âó`~IIhYœ0∞Dòl∂‰,†£ôÚÑ0ÄnÊ©'àFùÒ¿{jhÜ3 †Ô<‡Â°êBJ¡å∂#ËëfZËäV∫Nh*™û¸Èi:†–·0ò dÜK‹PÖB®∞√™≤V®D´5¨È°+à™Æº˙Z·&†ÄÈØ≈j8√
7pàß¢ì Àj8ƒ8,1C∑^¯mNÿ8há„RDò¢ê û*qÄ ™∫Ï:·.ºNà  Ç ® ·∫Ìæ{·	¿‡!ßeV[N tH¡~ AˇÜêÎßÑvò1ÖÃJ!tÿ¬Ñ˙n»íLa#P®√  ∏∏!À#ó\·" :Ltòf≈˜^®¡rÏ·“NÏp.Ö"`ÀaÄœRw‹Ø’1WXµ◊v-∂’N‹ ¿/
@É–‰ƒ@@á(  ÉK‡µ/òP‘ ∑
¸:¡∑ﬂP√0µäØP°(úú·è*Óu„Ü	¿∞C¿0BZ^!ÊF¸#1¿=é‹"q  #P :ÖC0–É/ ¿t‡,@A ,[˚Ìπ3ùhÿQ√N·3 ë¡ >[8√¨Úæ ÄØ+\lD-8a=ˇÖR«¨8`Çá®´.Î k/î#ãÏDªsJq‡˜2`?˛N–⁄*Ñ ÑoÎ  Ö∑  ¡S‡ )T¿]é£–D@°xIÄ4†>  Ö9¡ÿ€P˚‹¯IÎ$, û§6,¿q*Z#ÄhX!¿©  ¿¡
†≤˚]@H<@“*¥{QËáAb-tX»¬vE!ÒVàXÖ^◊°≤–.‘&®8/5ë_6 ù0  ·ç=‹]‘L`ÁmO	rÙPƒ∏«>f`{¬0Ñ¸Mè»2$"!0 ë0z2„πë∆A ˇÅ_S
Ω«96q	£Ã#Üä  «-!`zA%/ƒ RH	0ÖLp1' ŒBµ§ ¿Ø∫Cö‹§6:â!pêÇ5´ ûÈÀ¸íB∏ò4©˘Àñ%†B–ÖdpÃ~ÌœB¯¶%Q¿!∞ím’ƒP:+‘É≈}åC…T&6òy°ÃmóÍ<Ä ne Å3°ÄP'î†m(ﬁ8†˙9°ˆ⁄L`ADO	–Â(jQ'PÄ£-h
.& Ñt¿|5“äZíÅ [ÜÚ©Ok≥ü	X¡.Äµ ± »¶?pÄò@5¬Qì
ÅÌä≥ˇ≥
Áì¿%Ñë&XÅ±ÆöU
›h>h	iB@	dÕP	4–Ç¿ü©KŒòêÑ#!AÅ`y¿Éñ∞Çlàp&4aNq˚ßáÑ¿N]≠Ió*Á-/[°ÿLCò‘’‰>˚"Ã¶ç¥B≠
Ûö&Å6àH‡D   ZwÀ€ﬁ˙ñ∑  ÅÑ‡,†A|p˜¯T≤£änòx™ö'Å4HA0– ›ÓV∏¿ÄH¿ƒ¿9‡¡bÀ«>≤Çx¬ö–Ñˆˆï>(,b‡Çê`h ¿[óº6úÒSÈ:xH‘çˇus¿D¿ªT@<∞û'æØh¬|@ÉŸn ÿ-*@ˆ4¨~∞åeaŒ¡)¿¿ÉÊcÄ
Ñ¿9 Çsã¡Ñ ‡ÿ¬ﬁÄ<¿û#∆3éÚájlô#–Ä pâ6êÇƒ–hBhpÇ
§ ¿@
⁄√(K˘Õôd-fûT@À à Êm4¡.¿é‡Å(ÈnÜ≥¢+DÂ∆‘Y> 0¿bê•ud'wFÛh‚X$z—än4bö`Ë÷ ‡t=à‡X'Åß°ÍZ_H‘Ñi ]z>8Å–Y∑‚”™U∏Fˇ5«c%+[*B`PR)A`ßìÛbrÄn¿}ÊG\4ì†“©@ˆÜÃ•SH· åïı¿∞}°ïaX∂Ö.0Àl3Ü	'–-rÓÄ0¡√n 
˛	uo»iER¬∞^d#‹àù0ìÕT[¿Ü¬‡NŸ;@ø_ÑkæaEp¡êBÑ7+Ö√5q"UïF(d'Úæ÷nLêB  eπD0ÇëÉ®‰y!Ç|*p¢â<¡¿	bﬁpZsË+PÿZ∞Çéqlp¬∫÷πﬁ1#8N(0°©ÅAÏx#˚-QPÌúã6Ñ7-t =Æ}	Eß±∂√Ñˇa ›±¡ÄY0
u'@cK¿Ω8’ªﬂE–	èßP‰Cuö	ï∞d J∞É	eoíùµ™Ci≥úzΩ*dÇ[>FHØã–ÄEqDn}’aîq-p˚„‘Ωä_°„£P õ JX!ÊÉÏ^ﬁ¬¨›=iÀŒ¬≤B†ü≤(t{Ü	YºFö‡ ú Í∂æé√ñµ^˛«7¶Yg9}µ„â≤}cEeÛ}ÿ1Jê;ctS¶~{N<@ @uò∆7y◊DGv¥vH!˙7B¸G}Ú"Ä¢H⁄tËÙMÄ50É  5†oÏ„ˇÄy¡`*$ë
† h	ÿ|hJ ∞&(ò2Ú%Ë!∏!*h8π¥!@ÄdEN·D`¿@D u(—– '	Í¶˝FòM˚gÑ"HLÀÛÑ=‘Ü x!S¯Ïd®%zÙJeE!%¿Ä9¯MÄj°d∂pÉ6âíÿtäPg¿ê(âëHâ¨ÊùFM¿xÜÄâàdÉ@öâ/ñ1@1WgÜ&
L†àõ†nä¨R 0!ú¢P•z∏∫8!uTT5xK{áP∑òãª∏1ÄÉ√T8'ïR*’KNP”'ÛãÑ!Ö(xAêˇÜïê0hNfΩÖã@Ï» @Î('‡Lp∞á∞‘B<–  ÄÅD  ¨µcªUi.PI
 |$÷• :ò	>  ∆ñ	Í'∫S@&ƒTNU¢ë¿ëπÚF0ñ@ıxBí&©0“§vH∞4√ØrVªe?"G+P+0öıç∏7ët— `°ÄJ“!  ¶≤> Y¿îäÄ¢XxU9W	Èd◊rëÇ@–èÇ–^ÌGuO–myÂ$b>Ä Ç¿ Pi4@ 1Œeó¬˜	Pµhuø≤!öï90rLï5íC≤ˇïµòEí{mA4°ÄäÉ¿ † ÇÄxJ9ÑÉ` ¢ñ†êP 1∆ÜôîI@g)@öÖ@ÇíW	¨)– è åWt)J…é°¿óö0s∂Ê`í…X
1◊ p1 òèàcA8B©)—_ºÁ_9“öÖö1ó1â∞(JÈÉPÑPpéÑpñ≤ÿ)Iò«	j…π€u
†y6ÇpN	¶ñIPë!¿XÜ0†É‡%í∞r)∞(‰IÊIL‡P†ûÍ∞ô êÑ P ê%‰X	Íπùï`ú˚9*˝©¬fˇ
"
fù9
G¢'¢û°9ö+'°ÒHuFèh9:˙°Îi$@u…õÑ–mM@ @â›%
◊ÇxD®ü3
g5öv9Å¢^Zñœ9•f_Tj4∞¶Çê@)&ä*2™§∞	Ï·¶Íg ∆VëAä¢MÄ[ E ù' É¶˚9¶ia Ô7
' £ÇP¨≈éj@*†rÜ “Âñ%?fX‹& À•°∞Iß®™é!êf
ÅÉp-&Íïö˘°1†g§ûÄ RZú`
©Q&©h!èøˆ	4ÄïÜ†îèdÈ¶æ
Œ:9'ò˘~` ‹uë∆®P∞ˇ§>–≠‹äfÇJI‡°ÉÄ ˙X!` -J	ú⁄¶_J¨∂f¨h°cûy	9@†Çó4†õÉ 1ÏJ≠Ú©Ö0∞ÑÄù´ßI*KZ jêö‚∏õAS∞@
v	∞˘âØµ¶Øg—
– ˝J	>– 1≤1r÷kÖ ê≈÷j
 ¡z¢.@I  yı™j{*XjØN™mA–©óI ACÔ:A ™°‡d»	2ä!±"táb-pN»âîvÅ≤I¬	c\C¶îü»º∂`A∞" nÉ†∂Ö‡
cöz{⁄.†[≠I[ıhGÎqÿrM
ˇ
Ú∏≥èZ$ÁwÜ‚-·4c&ãm	¥ß`]à@_å¿πá¿W£êCsGÛ:	Ï˜§ùêµBí+$j˜" N2ª0ÇªG'∂x!°ê¨ëÁXõè[$∞%()#Úß!…+#Õ{îÖqÚA+APn'ê∫j8¨‚µ+¿5+∞rº»2;p∑u]G@–7(`3;  7pær˜2^≥ºùÛ9‰øÚõY0Ä–W!Hø3‡"ÔøÕÜÜëÜ∏›v†2«Ωí(&T7Ø≤Ö¯Ò:xzõGÖ,¢"0 0!@‡ †Qòy©G!∫X}‚‘=>Npˇ¬)åP;@¿íœ§∞&@(6¨¬Êwf	 ê¶aÂÜƒ;|0“R&§6\3¥9 (á@◊KjÉCµ√Zº1À&‘AèÚ≈xS æBBò“ΩTÉ∆–´L .[ΩqáƒJ|!RL!TåM?W@¥ÑN∞wÂ≤zrå»"X‰Z¥;h¸ÄD" ªw£,RYr\ƒä—rª’iê¿xåµl!Åú6XlR?˜JãÑ»ä¨5‘»Qà!À€Hè‘A#?w!u$ j˜…$«ªÇâ›& ﬂ∂ Ûp,PnO\
˜ É,À" 1cˇÀ˚ÉÀ¿∆◊ß!Ú«KfE…√3ÇØ#0»ºªí°k› ¿◊,Mê‚Hlòä
7´∑Õsú}l∆∑Ã»‚î–Âú!÷˜NÈ<Œå≥zÜ>jœ
<OêÒ
A‡˘úŸq i«)–«™0s ìÊ"0«ªK∏å¬ÿåØƒM *@553¢å√(LXxåíÏRK S2µU3C†¢B0∞&%*-0AM‘†\¨»èd∏≤öD@!0lôI9 Õ¶0s0 øÄí#‡"ÔˆI  J2Ÿë∏X5pF@"Ä)R# ·ì◊I!ß∑ˇdP≤VmÂR;A·#Ø 	–P&p -0"–PÉmA…‹I`÷hmÅ'`¿õb≥)- ÜÀf∏ £¶ï5ô´¢K∂Ω*∞¢Ká!HÄY3é†ÒÄÊhùô\fBL‡ªjfÛ·⁄zñ⁄±› $+*óÀ®x:ÜV– p1¿ÕÆï.@p‹ºÁ,¿üËÆ{›zí›ëë<∞´Î≠e<v`…ïA–X⁄õ	Oê¯Öû⁄≈]Üf‡ù4†`…0ﬂÙÌ&ˆ}"Fb&Üb¸çVê≤Ä∆≈öÂe^≠∏¨ëòëH*˛≤.–_'@[`[∂ˇ‡ÛA ∆a@>·lR·°qèAÄ]. `πâ[πE µ·\¿≠√’ ‚»u^<@§ª=Ó„`‰∂q≠Û–Â^N%`^Cd^ÊRrÊ¥°éjn›læ'n>î9Êr>ÁyRÁ≤#äÁ3≤µs>*ŸÊ |,õÚ`úë;ÁâíwB¬Á±ëπ∫Ëy~±$∫´)πM#í' ßÒ £3M$œÀÊü˛! ÆcÙõæ&≈4ÂõY\æ‚õYgóv˚ã¿ﬁkÎR^„µ{⁄J>8Ämê#9Ú+Ä5Ÿ≤+–óÏùŒhánµÁ‚ˇ¡-¨¡∞À"b¡s$ù◊J z™2ƒEÓ)Û*/,>  êÓNî’»<Œ=ª¥>”3B0Hd
ÛI√ÔœZ;ïÌ≈ëèÙ`–!Kz6C"@¢Õ±¸|—G—G=≈±¸Àv#—ÉBls#†„"îY‰5 Np/-eA),Ç≤Ú
Ü Ã* üPë◊^ÒÖ<M/»±<Ç-«ÈN0L"Ó%@HFÑ…J4`ªÇ´á¬ÕV GîDyhmY‡∏†îNOŒÛw/=írÙ∞¸*#ËÑﬂÙı‡T2SØ+X!òH´ØPH	Ãˇ!ƒ÷≈— ï:
@MÖm_!ﬁ˜€<˜≥ƒÙ&∏ÕÇ˜@◊HHØDo@ˆ⁄LMJ0˙/"ï>
p´Ûê√Í–kO»À –w˙H/˜tHÇœ˚q˜Ñ$5—≤˜‡dª‰î V<Ó¥≥z&T@
SπBN*$˚”ërıÄôõåÃ8!•˛T‡”7"0≈àMEÛ5NΩ&/ÌáÂO‘2L—#ΩT5ÏÑQœ∏Q·#M 8 2NNB (ÑÑN7N- ;@&-ãóÑ0 LPùûü†°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥¨1µπ∫ª£!òóK 50N8ˇ& &ó0;#C÷ F3 –; ñN“‘÷ÿN	øÑ  "%KÊ ?ã& ˝–ôﬂº Ù#Ä8ú–0C≈?'¸¸ªT Øã3j‹»±£«éh|˘ëâÄ)IÈƒH z,Å-Åπàf w-m≤2—eÃñy∆!Ä…£Hì*] T# M£∆¢ ·œ´X≥b≈©µ´◊â8 àîJ∂¨Ÿ≥hu‡ë∂≠(Ä|ùKò :ÎÍDÄáNMÇ∏L∏∞·ëM ¯8Ï∂¬ }{#cù1 û\…ò®‡… OãM∫Ù(& õ&˚§ÇÄòcO\ˇ¢§∂Ï»5TÌ…ãWN\j GäG%±-ÔÌÁ–ª.˘Yìüy+ﬂŒΩ{." íxWöÉ¿ +£´_üR	ärîÚm ¯¯˚¯Ûá
≤I?…&)@/¸`Dm&®‡Ç6Ë‡ÉF(·ÉF¸BêBß4Å]⁄˘'‚à¬˘  á$zÙ|”œã0∆(„å4÷h„ç8Êò£ –‚)Â¿VäDI 9RA¯‡‰ìPF)ÂîTV	eX©Âñ\>ÑxØ4· †®‰ôh*eCíiä∏¡≈Ò`Äêm÷ißF4pg~o*'&ôfÓ)Ë†¨ƒ@ ˇ°ﬁıπùúÒ!ÍË£¢∏Ä § )∫›! ∞A†îvzg

x:ú•‹˘` Pâ™jö'4∞™i§r˜sıÍ≠#í¿Æ¢≈⁄ù† Î∞¯ÖÄ±á˘⁄›¨ ‘äÏ≥≈)≠Y“v!M´-i¸µmZ’.{ ÿ˙ÌπiU@∫gÖÎ]
ÄªÙí’¿	ıíÂÓx)êfæ •@
7µÔxDƒ;o¡oÑ +u}˝Foƒ◊b¿¬4Ò}D4 ÄóK∂&{Ù1~, Ar)«å S2s¥2~G4  …5˜
 Ú˘å—Õ˘µ‹ ÃB◊¸ÑbI_Dt~GD  ˇƒM«åöjUÁÚ¥~.– Yó|ÿa◊≤µ~IHMpŸ€¥úÌ_(@6‹ Ûg.ﬁÆ»Ì_ ∞6ﬂÙö»)·´¯-"›v#é.í?:ûä‚"2¯	ëK>lljû8úûÊâ ÷ûõgÈü´ Ÿ°Œ´°ÆO∫™æ˚´.p˚)îπzÎªw B®¡ì“ªëÙŸW<¢≠.? ÒFz àŒJB’áΩíAô˝ôMêpB
.D†Ä<¯@˙Ú€+˘gôﬂ+	^çﬁ≥?;≤r“ë–(@Ê∑köﬁw∏˝Â'S3ZWˆò&FÕÄ˛A“åÓÊ<¶	Sö* ª„ˇ"oÅ˜€ñ©ÑµA¸`'Fc!ΩòµÅΩïP9kä wg¡;ãÑ/‹Nb`dë¯’NÃrVï#µ≠ØÇ!§◊µP6ƒ·x¶ì⁄ﬂıÑqï´â¬9N?8¶¬Ü¡ãâX$˙°¡‚MëPUÙWU¡Ñ#·çpå£ÁH«:⁄Qéc¬¿˜»«>·.D◊ï0y≠ëMàAãtƒ»F:ÚëêåèbP∆g“Qªÿ!ô@Çid†;BFI RöÚî®L•*O©ÉU∫Úï∞•v–ÇLÉÅƒ’b¿À4†Ωå¡ÈUHûínhÅsÿ√ÃÁ,°0‰≥¯S£#ˇ¨e„X˜êfzìô¸¿¿0E’ø™d9Yô†ÄÏ‡õl¶5êKU1'Å13“ ÿ¿'Ò®zåp T≤S‘îë51ñ≥©Ö¬X’{Ä *–ä>«x ≤ #›ı¨kGÛÑ©º`M)tÜ  |´_1\Õ“&8(<°úL€í°“û Fıî€b¥œû1éu/"@=◊ 
¯Ù©±°Ä´Ü5∆E±iIPÄå∞;$]™`≠÷2¨ñΩà§I{Ge$Sœa açk] p,^i±öÙgT?…-m1Y¬∫πàÃ‡∞à-¬"∫qX8bˇ8@¡;1±h‡±A,b1´ò†:ŸÅ	P `Ã`úı,hS"XÖ%2 ¿8!•3 Lµi&™QQJá§Ù§8¿D £“ﬁÂE(u
 %î¿©Öu*
 [A	–
 P‡á¿ƒ¿SB`Wª‹∆D ÄÚ∂á¨Ø€b÷êZ£€Jé¬˝	Ú{	à †8hGK2`Ñ#a∏¿"
PÇEP @ôHv@tNÑQî8AïIÆF °,√ã`¿ÜÅa˜¶‰ h}’j≤&‰ÄU≈ßÊB W˝Úw=¿Ñ<Ï∏ÿ	‚ˇ¿¨	 ì@ò%•U. V"¿ÇΩ˙ rë`Â ` ó®Ú"∞¨^._=<SÉ¿ƒ ' Å6ÄÅ
4@ò0çéc{û–Ä
``_
bÄæ  ≤`6∆±å¯â'0Å>»\êÑ¿u6_ûO≈Ái¿®œÅ6¿†#`hÑÄ‰£A|@&Ã∂MP∞èë¸Ÿî`≤Jpë∫ ÄŒÄÀ¥¿^ÄY††æΩDV¨	+õ +pB¥√í#|’^Ñ&≤Mà ¢ ,÷f…ºïüKÁ‡Õ∆jÄ¸‹:áNÙ¯\‡Ç^“Ä6∞¡ˇø˛Ô^∫Äpñ3ù#pgúæH h B∞Ë‘]L∞A÷:µƒõ„7ÄXçËWßÄ˝ÊÂ¿mêÉúG∏ßÁ\ÛÕª£ßxxpÒ:Â˙*( ˆã`XcHXÅÓ ´PÄ∫ã
å ¸ πò20 #Ã«&≤8¥Là†öÄ¿“è∞G 6¡ñ`ò˘'ÎÊN`l¿D « ∞w<p»⁄—∂>ä•èMª‡®ÄéÄxÄ6çı"‰Ä!® ‡ÄÄ¡æ—Iÿ¸.ö¿§6?>ÚÿÇQÈC¿ãﬂ∫;?◊/ íˇ{Å™Y·V≤ ®NXBx	±Ç –E: ‹ , ≤ («% @nÍî(y˛ı	KÑ&·∆;ªKìÙ]dV≠ Ì3üÑ€óÂ	L‚{ËsÏµÀÛ Øv1†+g Úáy_bQÅA†PÄÍöÁπ0~ Ä|1Y¿ 	∞awó·•|OV  (x äp	/–cÑ†€Ä+0H7†'f|N@\/É3 Ô+ËCpw1ëwåÒA!  `Ä$> Ä‹ë>0Äÿ^®Ä›¡9ê∞V!‡<PT‹qˇ<‡!.b ê9∞T´QÅ,qÅ5°la6 ,Å·u˝ ∞AÇÑ† ÄY¡}îe&∞ugw	C†kÑ ~∏‘!¢ıà∂TãPÑÈñH8I@M®Ö@4^ËJH◊„"4@Ö÷‚∞V∞,¿vÿnÓ∑Ue ‡AExòz∏'q	" ä,—N0]"vl(eà…∑|Åàu	EÄmó†`Ô P”ıç·HnäF®nÎgG†HÂ'`∏h'I`'PDÄ1†Ü√) áÅá,‡Ø("O‡,Ä˝SÜ)êåÜ±ˇå—åN Ç:@Øet∞œW^#0~⁄Ë `N  ıCê òæeC–F∏t.	ìÑê ”G¢x•(Á˝Ûè»»+A‡x`¡ËL†Hﬂ` pã´rä¿QìÙîhaë¿∞_˚ÄÉQ' ò†⁄ß∞A#†ì;Ü |Ñ 	í@	⁄Ád¡¿@}Ñ@ï–-Ä=ˆ—W È∂z…ó«ñÑ0]"mîKq,†3∫·Ù,D‡Æa[, êmAôZ% ˘(*I
ô¢·ïò∞Õò0bπw1 CeN\-`ˇ<ıΩ«\0‡0éªá	ù≈ iâõ2íaΩ©µf⁄Ã	* ë∞∫˘U§èGë√ÛÑ!¿©*O¿ ≠yöL!ûZe $†<"D’ûIâWÒçÑPê©\^|˘ö|z"Ê	Í¸yÑ‡©"4 5pâ.Ap>b98z°”í°Uîñ∞)W*™~·ŸIÙô1>∑‰û—,¿Q–W√ÿa ,†zHë¢+Z§¿ ôAÿ° ¬‰3ª§Uêô%aR@*§ÙÇ£Ûv\IDj§^ÍHäIÄ¿£>√Å≥ˇ6öO êB=CÿíÁô]˙•E¶ªêF ¢2RÉ9ësßICsr¢Lqßx™¢zö¶b ä 6ÑZ!=ÇZ6i¥)R¡®çWèJ-C=~ï)1ˆ"'•aì0†™G·©ü
V°*´9©àì§…>@öuZ2O∞ö1˙™˙´_:´∞0ÜÆÍ8D á∫`".•9„¨#´ƒÍS∆Í
'@ †©9G@ œ*I@ iÊ9!@ kä‘∫*PÉ•àÂ6Zº9ÓJ~í5◊ 
&b¶∫∞ô.†I…ÆöûﬂÍ	G‡ˆÒØ…˙	M@t@ªÈy™ù∞ˇ")¿£©IÑ£Å$“ 
v¶+
Î	´Ø
O`h¯	A–wlQ≤˚qrÆjq†‡G	
-êQhKëÆ1w1äµSçﬂ’xõ≈mÀ’\œı˜∫
êDª ymd)ù¥V∆Ù	9êg°êÃ1Y€[+
	„ä.@O_∂P@ø!
IÄ ÊiÄ5ú…$
`MpN±ˆı
¸ë∞—µı	`+ù∑s[∑⁄√∑ûê
`®Dp,-Crõ≤å€	cª3° ”O{u•π rL™‡·ß·≥!ÇBKJ–ëYQ`w·[F ñú¿@ªEãˇ`î»`^µ©‡6Ç+‡a«±9‡R>–? Hå"K3À€	Õ˚6§† œ ≥°‡6©ÇWı	Á	~◊	HB6nª7rÍ∏€ö
„ª–ªΩ4·€	ÔÎ	È
&•ÜŸ	´ìfÔ;ΩPPΩ≥M ∞0¯Ê	⁄	úÉ"H¢∫Æ`yJ¡∫¿‡∫òuŸ¸‡[Z∆^ØK¸vJ∆d]!º® ;¡9¡ÅlÒ≠Ã1©ΩûpP·¬@C
¸ë*P¿RJ√ùÄÙ	¿UP–Ñù¿p$ÎP3,>Íã∑ ≥®2ú∏Û;ƒû`ƒKú≠\ã∏° §û`≈ùÄ≈6Li$¿ÛíˇØû °!zûê£{,0≈´7∞…L+`eÆ´/†>Q«w‹yLFêmBÄÂeF »…'»VÊ
Ω´mÉ(ªó¬WVlãpl¸ùª *Ò^√!iÅ¬±mÃ∞9øù–≤K3©úSP∞è'4T°√k≤0∞l"›*˘@-7â1Æ
ƒPEM|#`tL@	©∞¨Ï P–ÀÛ;Ã6ÖCP∞ÃZÏøP∏û∞ÑöBl¡Õ≈ü† ,L¨π˝¡¿7¨jü,x¢'IA≠Ï@K  +(Ç∞ ê!ê—œ…–Z+@ò#®	%∞ˇ+Å–ˇºÇöê¡öf∑LîÏ[Of‹à&|
π√ûÅ ) ?°‡∂ºë TqUgiR£√¯K º¡ôµå ∏∞&œ .5”LP”?å  ƒdct&⁄	‡!SÅì∆ÇŒa e€
Oú3Íy†@.”  ” 2‘Û€O ¿‘î6ëP@’TQªh kcÖ”ÛGP`÷h=
,Ìø±4Û¬:,ÎPc§Å”´¶Ä¬C:¨?ë∂ Ω«∑Çä}b+»È0~cï»ãΩÇK0:ë—ò¿à,ë—≈Çò#m
&≤•∞DÜÍ	∞0˜‚	Eê”	kb”ùˇ€¥≠@t®q[HÇ∑π˝√÷À:Cb÷‡¿Jå‹“≤ù@’Åõ
ÉóOÄ ºë)Ç1€ùP€‰+[∏=øu=FÕ]ŒTC’ô2˝‚RKÉVÃ≠Aºmø¬◊ù†3ü Î¬ﬁ” Õúë7¡àëMå}|ò5+q‡ñΩÇÈHpâôΩû‡£]…ópÉ?ë— XX!î*–Vºê6à˙‹"≈nh‹	Òãƒù¿Ω†¿Î«í3Q‰–Ü:#02Nø∑e"
zôb ú`"h’‚	‘ç)‡´ê'V:ÂÚI$‡Ω6–‚ﬂE?‰P`‰O»	M>ˇ›|´ﬂû†U°ﬂü ÊH
4ﬁCÇﬂP 51˝d ≤÷IªrMÕ”Z‡,q·ççY#  rAËç……Nﬁ^æŸ1⁄>)Ëô\…Çà}Õ)“#]sÆÆÄ Ú—RCAI∆ûa+1‹	/:√Ê]ÀoLΩ$– WEê)p´≠N≈›{[K'40UTq,«!SÊSƒ.–r9–"≥ñI†N≤†V
ƒ$∑PêÍ‚Eª^ÀÛÏù0Ï»ÆÏÃæ‡∏ôíl˛Ì¬ﬁ,†pÍ3 æ&!PácÚ	&4ªƒä‡!±µ`üÑ‘™Ëôàã∞x··ç˛Ëö-ŸìÆˇ·⁄VéWë—÷ÿ…∫ã⁄ùC¸Ô£`"ºÅœ*&!“2‰ƒ√ûÆ˛@"
´ﬁÓÒ(O≈AÉˆ’Ru>8Ã¡!~qœp2ÜsrsàO„≤Ä$∂*&
$/æ'ˇA«4†Û'Ùs2ïúë)∂“2úêÓ9Ô	;ﬂ∆†ëÙÅW-Û/k¢Ü«Ò¢¿9˙Í‘:·?òE=F˜·åÓËÊÈ~â˛ê)ìãµ†˚P…!π#ºL án
10œuÓ-òb&Lêú3Ì&ﬂ	ZÖ"Q?±!†˘IpcÅÕ˘˝A°OÛ?|[‡±0Ì&"8ñƒä˙ˇ‰∫∞Mo^r›Ø∞ÀmùÔÙ†"Æ≥Ô	µØø|À%ÔQ^ø¸‘kΩôÔ	õ_i1è:‹<†¿9I/ªj‚\jÈ°	0∞0P 9<•pËØ˛ÏøáÆXN@d©mé-Û0JN?;Nää  FãN&-î(ã%êçèã#	ã?ê§•äP™´¨≠ÆØ¨IM∞∂∑´I1™O9™)1ƒ,™
APLGP6 ™, $µ¬ƒ1∆PG OAOOΩµ™“‘P÷ÿP´)Ó!´,
™L¿Ph∏kuÇ ÆÉ∂öD0ê°CU$~=|ˇh Äã#96úK∂¨Ÿ≥h”™]´ÖO?ÇWy¿∞ ÄUﬂH¨*YÌ§ºa≈é±zÄó™'ü  “*ÄÊ 3©”É.òöÍd	 jd† C—á#Lh ≤»*V≠\w ¡» L(Ç  ¬#≥Y∑v≠†´"$+ ‡ÄCë àó5‡o‡¡Ö1Qha¬/US®û:d“¿ÄÕ∑|(·¢ÇOâüPï§ +#ƒ8ÁBÄÄ.ê Ç:5Ä’PBº¶ë\ì&4" ]U˚vÓ›P|4®¿"DäUOB(àCCòN∏8¡‰UA–°4(èñ5‡ÌYAÄXˇQ(≠_«û•9n›De∑]wﬂ±rûÅƒ∞™± .ù# wﬁ©“[jı“ìÅƒê¬K´ÇÎƒÁ 	 ∞`b|Q]6U!SuR
å.B"£"4B≤Dç..ë„eHàY*+æÚ	 ÑPbëLàP∫¬ûCÁ¥íÉìR¬Úƒî;±‰*_ôêp$T)Ê*<`ﬂôLp©
îPòπäõÿyôñZ⁄i‚óG!ßòD(@ gÇ÷¢êà&™Ë¢å6zYfÖ∂‚¯È•òfZh ô¶M<ùöñjÍ©¨0!ú:®B%ï£∞∆*Î¨BBZjn◊ÍÆº^˙D‰∏–*ˇ…úfØ»&ÎP'† ° ∫r(≠‘VkÌ¢∂ñ⁄D
ê©—Ü+.3) @
«ñJL·9Óªª&¬k·´◊Ê´ÔæßâÍ.T¥¥ˆå*‡¬üº⁄† 8À,Òô9T Ä <-øwk∂≠V ',3Ò…+Qƒ˙†n&£,sRAê@¿4üNº±«<˜\#»ª2±Ñ$‰<Û—°ëPë,Än.∏f@…HW]‘	·ñÆΩ;˚Ïı◊˝ä{D
∞†”VÃÑ@p5ê43è˝0ÿ∞u⁄‚6aÉ7+v’]É-∏«@+ÀD¿Ö@6†çwˇØLÿ}tË¯ƒIîÜX'¿„º>¡√	ÆÅ„Çª2ﬁ„rÓ˙"F¥†…£˛⁄ÎC
 f¿.¯	˙Æ‚∏∞AE DêÇ—ø«…	_LÇ®'f60_	ûˇÆ˙e0p¿ÎØ/1C∏X8ºO¯¿7_BA‹-ΩSM¡]Û`¿Çüœˇf$(*êÇ+˘/>I»A
*–æê ÚC⁄ˆ.CÅÔ— 2‡ÉßrÅÚ—Æj‘;uWÅ– ~|Rh B‚–K·CÇÁ˙ ‡6§·AÙdò∏ Äã~z◊?Ì·+Q§ïZ2Hä%∫(§ ˘ˇf÷Cx àπÕR@$°àH{B|@{1ã
 t(√¯àÉ$à@˚úÖÅƒÄG £Ãûpƒ‡¿‚»"@ÇÍQz€ª¡
∫≤Ñ¨`äH‚LPEƒnBp¬V∞ÇNaN
¸≤€º‡óÃ‰&;©à@≤,30A'!©HF:Úïä¿
P £OÜrîä(• Nπ]ÚrP4_Ìí«¸1êBY0–ÄA¯"˙í–†:h@˚n®Ä:∆¿ókc{Í«¬Rö‘àêNT1Å~LAwƒôgm¿Ñ(Tß-&ò .A àd(PˇA h@3Ëã"P Ä¬‹@0+¯  Ä' ¡ÿY"ÍäFfã"úñ∆8°†ä8hB´RÄD†¿É@F7⁄—èÜî,K®©näÃ(rpô2lr0DÄ]æÈT0‡§¿1 |@Ñ#$°M«1áúƒzú6%·Dr@É∏ $à•|# D¿‚…"(PP-µ©xÁ†Äl '`AVm∞’ x¨P2«NÃQ÷&ıI≠6h+NÇD@ŒHç≥*ÄWËïØ}UE(pôd*b3›ËNQ—PJ‘	7®≠L  ºvßà¢nõ€»ˇ¸ ä`¿b"ÈR◊:∂@êÄ ÄQÏ∂∑øÓ"":›Í*¬πS°@Rk1v”ä+>Kéh˙ÊΩçÔ	@ÿ©VuåÕÊ!…;.Û≤ı≠$ÿ@ÄÄ– ˜¿Ä0ùX’ƒ—/As‡R≈π–çÑÖùÄ à¿∂~)ÓDaóvp√±n!—·»8AÕçbÜC©à ‡ïÌåµã‚ﬂ¯ªF5≈24aß<°	L@kñÏµÆu].‡¡V}∞‰ tï	p*≤ñ¡‘$"Å…NŒ»r Â&/ŸÀ_EÌñü"ç÷ 8∂^ §íbEàx®$v¬L,\‚Æxˇ9^ƒéùÄ·ô:A	&@Aáe0‚NÏô«8JÙ¢ÅÏ" dlÕbj êáÈN?dÒÙ©í  ‰ö¢–ë‹∞0€Y∑Å÷3üQÏg 7tåë·" ◊C  £ÒÏËY+¬◊¿6•©≤ ÏP‘I·	ß°MmWÄ∫⁄ßR¿ÏL1ËÁ¬y?¿n∞[Í»ƒ˙—N8±"∆]ÓRD¥’ﬂui∑3Ã¨[Ÿƒˆä±ùPÔ{º•¯ÄM∞ûå‡á¬µé©‡GãÄA_ñ BD¬Çª}®"
`ó!¶£N äI(B ¬vƒq#xú£å–¯ Ä¬®≈•ˇá≈QàTT	(GA!DNÚHò‹	(W˘|é†s¥8∫)î∞ÜÉ ≥:¥Æı3=Å À-^–“, & AÎ€h@-#ÇZÿ‚∏»•Ÿ ∑⁄.Ä∑ Ó/ç‚n6 P¿•c◊ãz∞ñaÄ¡‹€Úñ∏hÚÜ‰f¸ú?Ã .A*E	 —ußX∫Ù’Ê:ÍW dÚETπëéµÑÕæFù∏ÄKq4€©ˆ∑“p-µzÑ‡“≈_≥Íìﬂû®öâà“=Ù_€ Ê;D ı≤˛ñóØ˝ß$a üæê ı¬¯Ÿ›ØT˜∑Íı?≈lˇçî–ƒÄ|ÿ¥˚o°∞˝Oò˚˛˜<  ‡{Ú7uJêÄ‡≥t pp»
 ,ÿW 8Å 
∏Å‡v 3∏
†"!ÿFXÇ∂¿    {>F–POÎÁ7((C'xÉ∞@ë3 q/Ë3J0>Á:»
úsÑ˛ìÉJË
6∞Ç#ì 0ÖTXÖVxÖXòÖZ»  [[¯Ö`ÜVò Ì3»wÑ·—Ñ“√Ñjÿ
M‡L)pr8átXávxáxòá"$ zÿá~¯áv8>†fHHm¯;lxà¬Ù†àS„Âàiìàí.'ïX0TïâUCˇâúà,+ÒâÔ≤H%ä„â¶ÿ*õòä—í¨x2®¯ä•íÜ≤ä,Qãã∏x)#∏ãº:·ã„¢ã¬(&ÍWåßG»(.ƒ∏åÒqzŒ®)óç “å‘¯“vçòB:⁄ÿ+÷ÿçAj˜ébB6‰ÿ*ﬂxé∏@Œ¶éE¬àÓh*ÈèØ ˚Eè∏‡çàèó2è¸∏
“èË0)˛(êúRêöëê
)&˘èÿêIA ëEÚê¸8ç˘6Pëâè°¯ëê$â!Iè´xí∑P,	)è¥¯í∞0Ä˜Hì¨ìÓÿã8Yè pì=©pÌî≠påDπˇ
Gà=©ìÍçGŸ  @ÉA…î‰òçO©
Ïà~OIï‡(éW	Ì¯ï∂¿ï›òïbIjp#ñØ@ñ⁄hèg	 „®ñ≠¿ñ◊hí_…  Çrπ
tIç˘ïö6mrŸó—ë_iï{ôìC˘îyòòòsπòG9íbâuê©ò{πí_ÈîóIòŒ8ìA˘_¶VLëYƒôûπå<Iî("_®)ôDiîA	Òuã{ôö∏∏%U¬ôAI<ÔuÜ_âõµ¯ àa.ÂÑXYwí)_@iëG– 
ù@X—Ÿ i˘í÷_’◊ì§ˆ^¡xï›_ZYêA _Ÿáìπ„ÁyïÕÛ^GìÓ’ˇOÕ˘è4^Jπë._ÿì _◊Aî<ëò(óx	_Râê˙î≤!{ôûzî·ô∞…íÂôJíı©ûOÈõà°óΩπ9ê©iæqü)âÒûDôù˚ôô©aõDYâú‹â„âì“£W)¢#cÅA¿û’ @§B:§DZ§Fz§Hö§@jJ⁄§N˙§PZGvÉÇäÛ©ê•Ûü˚«+s  %`b:¶dZ¶fz¶hö¶j∫¶& ¿¶pßr*ß#¿W1Íƒ9°/πúQÈ‹R (0[AX®≥≤2‡  P!8Äè˘ëHñ^fR∂V÷SvfDêˇf®7 JÜ™‘¢	Ä}…©ìM&eKÒeFeV∂©XVåÊÂM &`f`∂´tµ`ˆ`◊$a[∆`¢z¨‘¬[M—i‹ƒ6 `0`üº∫´
∆`§ı`˘U£⁄ßTLu—*X
VXáïXã’X≤äeë5VîÖd]¶™Œ™YúÂY†Â^£UZß•N≈±m»⁄Ø±¬•x@|îO·:N∫SX‘îXf9@eÈzë5YkV£ôôÂõ’ÏU
@ZÚîGÃ«N'‡N—D ”d1†Wö)˜î≤O„‰O E¢- ÊØ8+Õ∂¨…#ö6ê¿O≈Ÿ±(õˇ¬.˛ı≤Å5N&ÎBW⁄FoGsTNvÑGQ€_}ÙLÇD ÑdHU„·ó≥dÀ(|±ûHs6 Hæâ @Q≤†3∞.@Ûê •◊I^4dC8e‹˙;=ÙCg4Dæs2 
eª∏åR∞≤Ωr4 D'™F9∞∑}ÖV‘û4Äπ“” $@d@ÿñ@‘@D≥ô"÷≈∏∞ã(‡¢ˆí>µq	mD GÄªƒ?sª<Õ£ œ∏ÃZ=≈ã=Y{&¿Ø±Ωó—aª.=öû‡1PΩVG1‡ƒ,êßì9 úì=Ó':§Épˇ: RE'ΩÙK–y≥77c åπ’9¯02u√∫ö"7<•%®7|s1√+¿Z˙≤(∞d1+ ∂L#¿JBb¶J*¡MÑêkeqaßIÏÇS°K"l-◊ºÎDÁ˚æ†ÎG†9‡@úiQ!T”Ü*ì5.–√I1L˙‚¶N0†wT°†tahCï p3<u# ∂náÅK§¨EQê0>QÑVå≈.Ç JPú/J`ôºí˝i69 √´˜êú®‚2#C‰´Ü5s3 òg¬éÑj-|#ˆ¬ê–0BQ»5ØtˇPó‡"?@]]¨·∆ê@ '{‡AòS≈Í"Ä/ê¬÷≤ Zj*\z3¨«⁄««˝I2˛´√2¨(2£)mñ/Äqs«¶0øF‡zÎ	êB‚aê S!®S°‘»z&ÕÃÜkã``Ä’¢|Z$D ÿÀ»˙8‹[(Î“.ª(/uÖ∂Eªg-ÄqNP R700ïT
7†Ãê ,–]
‘n7¶/†ù∞ıwƒth/@I⁄l

]Õ+Äår2Q¢L- 0•B˝â©ª»πÉÒl"ƒ¬áF¨ÑÃ‚,»zˆñ/  æG;≤ˇó`‡ƒu .hê¬DÌFç‘N–†ÏP@  £‡¡,¯≥•R=‡/Ä§¿‘),¶e≥ë  ê–l˜g-"0†ó¬®QÖÃäA`1¿ŒÆ*I¬◊á®*”p”¨¿)IŒ…ÂR–≈«Küß’ê†?ÌP°¿ÿM’Üõ=Srv µ˝<Ÿï≠q5EêP¿÷˝…p-◊õ‚,äåã¢Qu+í&kRñÇ≤”Ëaÿ˘Ç5ÄrõlÖ ‡œ>F≈ñ¥⁄ëa‹°î‹§†Ÿ·f¬NpÖŸ¡¥b]÷Œ˝\–ÎtQÕ0ó/q)LP∞¢‘Xˇ¿◊Ô·é(BÇ&‚€˘“H" ·v8 5–›§‡s¶0\k◊ﬂˇ≠‹‘çÿ! @Uﬁ6&# 	>’om¨ùK P–◊rﬁã¨»˚ä≠a 3ç»⁄∏<€€=Õ1P ∂gõ·ã˚	G≠0nÓ⁄’Ω6∂#⁄}]∏$„¢Mn ¿‹x÷»≈Õ’¬·EfÉÀü¯†ö¡-≥›ñÁRﬂ+æ/|ÒJE  /†„¶†ƒ3 ≥Êc˛b;Nﬁ÷Mõ‰|Ò…D~hh˛R)∑]P}[!˜|M€ÒqâÙëh‚&‚Ω”
OPF;)¿‹€L¨@ˇ6êÈö^ IêUKÇÈöûÈœ÷È<Ï
=ÍÑÚË)¿€qÚ¨¨≈ÒÍaﬂ| ∏4\∞É7 >ÇØßπûKñÅzáÎ∫N ºn{H¿ŸUÌJ0 <\ü| êF`.dÅ√Æw|—∆8√ˆ	°∫ËË!¥{&> Ω9öéíNÈÆ‡¨ôæ0!‚ª‹a,P 5E„Üeî«´ê√wÌYÿØ0@˘ê‚ôF/ÃbõIÄ ûc3A<+ö”<kC©q•¡M
3ü#ÚA0ÚóŒ÷@ˇØó9† ¯,&J#√¥n-?#˘w /¿ˇv±⁄ Kæ˜∂Ò(¡?ÙuQ8p 2Úa1†| –∆;bWQ  Á‰ÜÙ†Ù‹v7¥Êä «î±AØ]$ÂBÿØ‡£Q≤é
7è+˙â·/‡öd™∑Òc Ë≥ùP(~B˜Âë®!£˝ﬁM‡-AërÔ
S’¿AM*1†9 >p3“U◊Äî$P ì¢
x4@ Â·´èî˚¯
ØØ
±?%˙”†o!∞›,7úi¶™‚˙"íSSG°'vã¬¬S‰§–¸• ˝‘üƒÊÆ_«ﬁbí@Ω  ﬂ9L∞m2´P0˙™P˙aˇË‘&U¬éÏAjü¬éo1∞÷`2
 ”Åïº	PÇIÇáàâäãåÇ.OçäÜíññ> <á)ëá!Ç'à$ 9â $áAâ$¶P§ÇO ,PØß≤å¥á∑πÇ¬P†¢µP9 4óŒŒœç1N◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰ÂÊÂ"°”í< MÎIà!á$4ëàΩP®™PL0Q¥Ãá &ö— ÄHﬁA Gt∞q (DR1jÄ@ü=xM>#„„3T-S≈b"î'(Byw®ùAD¨x2"
Ì<ƒÑãõ=¿õZRÑ)ì	ˇ&?VÀ*®⁄πØ`√äKVl:ÆàX @ª.¬Æó<X∞Hy–ËÕô 8•KSêMA)Ù"hL@Éw.<yB3t˝bPËRê %3ÊhB√ÖC('ò±ùÜ†ÿ%ÑG+rå(Æô ú®OH´Z-
Ç#Äà*0Lƒ˚êèDrhï¯!·PídB±IÏŸµVÿ`¿Äs’ãh@Îµ¨˘ÛË”´«vvÙâd‡1Ò–ÎâÉ,Ë;û|π†&1x`  lbnP¯pBzIsà  êÇ4·ÅEDx§å)]÷ãk¶d‰A@¿EPHBDÄb|â4¿èˇ%•¡àH√	íën÷A_âTPRnåê†[;¶9d?∫=—ë ! íà(˘“káÙ¯£(¢Aÿå0™Eû5ÎïiÊôh≤ß[.Ùf#">ƒ@%óΩsÑE/=	EîoÄKB!§"G(Ä•#z•Zé∂Ñê◊â êL;ôÕ©£§ëùDf£.L„¡ö62ÿñ,Ñ•ûB¡C%D
uS&¶Aó»}
`$	 `≠¡LZ™˛ôé?†!å¿jRyiF+Ì¥Ê¥«VFΩôH8—MQDÉÆFˆ*"M’Êó≥àÿ‘ å{hhå@XÑ‡éØdd‡ˇ,ÓPiŸo⁄BqÁãó∏Üp|¬©µ,4YC+íì"ApH¡ªÆh,	“± €r(ƒîM\Å»PB§mF}jE&µ8Á¨≥÷≤•ÄO#rßsM§pîK$_R®Wº	„	ÇÄ*M0à"Ωålêc)§pƒû¯ˆohG∏6d§ıh»œTP2x-}vYD|áJ_Mx∞Ï!√¥ 8ã@⁄˜¸}B‘âé»‡*SwEÔDIWK≠™÷ÄÉ\AªÛÊúØ◊3ZÀ‘\∞%%a¿&St∏3‘ñ˜ﬁËæõâ>…Çux0oåŸ•ˇB¯BC@Òπ¶Æ3ÑØˇBÁæ'∫%ÄCOÑ–ü	="ßü≤ñ «w?Ÿ ˆÛ˝ïˇ˚|Ùô»c¸!™M@ˆœﬁ‹˘˝¯õE*[VcêG¸ÊíÀêÔl!£IıÆG?A9ß)tiV)Â7E4 d˛:‘QêqLQ‡aÇÿıåLÄ…=ÔräB‡&Ä)àÅYÄπôcà;HÎB8A!á)ÄéêÉD¬*ˇ†·Ó=¬Ö´òŒü–‹%sˆãTÄl¨†⁄A˛∆¢Étqe<£Œ>áñ'pƒ\·ÅÙ¡Ç!içM@Öﬁ1†!1.àÅ><P 04åˇ	PtÑd$A CzÇ ˛°5≤ [U”–<∞ÅædD&M @∂é Ä]–Äm!D@`Á¿à6:bêÇsUO1r!Ω¯≤<– ≥!'p¡	<uvAN
x—1ìπLjmäë∏e.wπèƒ‡)6zÿÆà≈±A Ä6∞ÄlcÀ>êŒmÃ≥û;cc#`ÄÖ±E<ﬁ¬õΩ4`òÉ&ä.Ωº®óæîFÚRÅdj»?s¡†¿E Vº¬çíä°G8Å„Ì	'H¡≤%à#T¿hÄcVà`Ä∞Ú4çÊõıí#‘I¯ÈOˇÉ*ü ˝TO)#8"(†ü‡—úÒ…ÄÒ<Í‘®öç≠f’JPc9¬
}∂ÒBLãœOY…O5·7]D‡à=•Ì-L%
[è |≈ıM–⁄	˛¥¬ˆ∞âxBh:©~e òÅ7`ÑÛÏ† ;W±°ŸØvW5hÀ∫?à',E¨jWãÿc¢&>9ËYK€⁄éf\0)[õ#¨¿	B@Ågù∞† ë≈Ü${ç!0 8ÿ^PÇd„+8Æ6v≈.Ó@ x¡∞Q‹„*Åº“EÅuù`†@Ÿ‡nƒä]‡`ÎÌÏ5îÄˇ$\Cø–5neùê h‡nÔ{„€›k¯¿ÊÜYGì«ê@¶∂Õ∞Ü¡TpFOËƒ`6L‚3Ç@
k3o‹`  X¡(  `√XÇ ê\'º  ¿Ü
T¿ﬁ_Ä"ËhÆ1	Ä¿yù`u˛‡π@p¿ v Ñk¥Äƒ%n@c\   ÓÄ0à‡Uv¬ïoúc#¯™ Ü åœ%`N@fó†ÁÏ‡º;XsõﬂLe+?ó– 0Ùî%\ZÒ@®¶â7Mb&Nˇzìß@ær˙‘;ÕO¶1ÃÒ|√ ÄØÿy‰ˇ.·zfÆ ‰k0`Õ@ÆÅÑ`∏µ ´Åkl˘6v¬0{ç%‡ìv;ï†?+õû÷}v†Øq (˚{˛oüg†l œ  ˛›™uΩZÌ| ·Ù∏ù@Ôo|†ÜCÒú¸âÍÇø…Bö≠∂öêßÑ⁄‡M0ˇƒS≥• Æ* ¨Å\œ∂Æ/–k#$@π5æ1 Ü∞Äê_£ ÊvÇñ«ãçis6ÂÅéπ `lºÄ ": ôÄÊæv9d˘<\uU◊XAr˚˝Û†ã`ËEüyW7ª
ê∞`9`Pb`Òàõ› ¬QIkõ·‡ˇ¢;ª‹Ñà6àÂXºÅÇç_„wÇ >Ä»éº◊-Ë˘5åÄs'Ëy Ä'68Äo~ Ú˛ï6µØA …è¿Â<gO;∑ÑÀC Û |∞ôŒ ;A	&8. äﬁoå^•«¸5˙Ìç§±DpîSr¿‚πõ˝	E$r6ú˛â‰4˛‹}@Ç)Äyù‚5>`¿_ 'yÕ{Å./æÒ}7≤ççæ€	K@gŒksl¸† #òﬁøÛÌè  › 0;w{KÁt≠áOEP „Y¥áOˇÄÚw^ºóÄqgXO`éÒJ6Pv“∑iM`` 0ˇGúvŒ˜J4ê}HbI†Dyq}©µZ$–k‹˜wÅó &~◊@rØgÉÏ’x–NPy=xYÖ\ÍTÕÖCaﬂ∑}zZJ FIXOó◊nÈ\\«ÖY≈d‚Ä¸ÜOSàUËxµVO∏&ê;µ≈é·#,@p-XbD¿BÇ4‡Å∂≈1P"‚+XáÃGB ≥ƒjÖu'bï#  EpÿvÔ6l9'SÊÉ0 F(◊lÏ YåÊêU.wt<≥rCpk–? ¶ 0äN s* 3ê∑vä„•ÜJàW’1vW¶oƒ¯[ 8†ËÑˇ‹ Ñ◊e∂àã∫Ëº¯z“»o›@ ﬂ±a»«BàËtHà¿ÁÄh !@|»5(p≈géYÒ>¿–Q-íh[‡rÒs∞\y°x*  ¿ +0 "`~>H{ár&∞ Kvó57¿°E 0*†xê' W≈cæ$ 00î7  \ó~ÊÁë π}ÙîêÔF?@c–E5PO9	 ;È= s`Äíªyï%/ô 1˘ë!â<Pÿ~¿á™uﬂ§è/ïäHèY¡9ê, ‡M3HàA‡‹!¿<ï`…aq±rb ‡ˇ˝∏awZÂPïíOç»x6â€Ä_‹PïKêq#`?∞8 õóòÄ	ò‹6Ü~ô«õ©\⁄`ïπÄπx`wÜ(' C9êñsπDî˘(ÇËöØ	câB .¿∂yõG†/!éza ¨)ó÷	PW âŸxeë-yDv[ïôÒ‰ ®dvM‡l)' † ¿9ê!∑âT…¡`(nÈ>Äï∑ŸL±"ª˘' P6I0è%ˆI6ê*püP$A ü&êy`Q]ñ ©êUËQ ›V\Z»UùÒÙˇúg˜D@≤$û–,)@>–ü“†>@%p4ÄûÈ9(ö*û¢ îêL6¿¸…†l—*G òQêüÊÈ£`i0iÁ@cmü©ÿta! sÕi;¿c∞^ÒÙàñIï.êb'â ∞H™§J≈Zo5%6†Lz™P•$‡≠Èü?äL@<@K∫‘ ˜yí 
€·!êR,H2D4`6ê9`™§zH.¿)p!¿I@úQ«I"!C<@ ŸÇIÄ ∞¶È¡móOﬁ∞ƒj¨N ¶∫ˇ©3A©Fq©ô™®† P‡©$`4¢§j™®™™4¿™ÆJ±ä≥˙Tya´õäD¿§ŒäÅìÍ9`)`ÆÄÆÉ ›A Î^^&rÄ ÷ä≠⁄j44ê>¿´ê˙£M ·•¨ª3?∞ }Ûj	øsˆ⁄˘zÆÈÍØ ∞;∞‡∞›Å∞◊ö≠!∞≠.–∞>pL±ké–C94°· ˙v±B{&F@O¿Ç=#;õ¥LÀK€¥AC¬± Í5¥VkÌUÑSµáı¥\˚µœ‡µ`k#¡ó£p hõ∂jª∂l€∂n˚∂p∑r;∑t[∑võˇ∂Äê `Õ:∂‡!∂~∏à ∏ÇD≠*äª∏å€∏é˚∏êπí;πî[πñ{πr1≥AÄ≥Ö∂<€π~K∏†;∫§[∫Ç ∫¶À¥®õ∫¨€∫™˚πÆõ≥´ª¥[ª`9ª∂˚ö∏õªº€ª∑ªæ[á¿ºƒ[ºµ5º∆+w»õºÃ€ºJªŒ+}ÀΩ‘[ΩÎ0Ω÷kbÿõΩ‹€ΩßΩﬁ[p€æ‰Îº„[æ´uæËªææ´æÏ[XÓ˚æÚÎ∫Ò;ø6Røˆõø†ãø˙;¸€ø ¸µˇ¿&1¿|¿k¿<
º¿<ó¸¿í¡\¡“æ|øú¡,ª‹¡˛˚ˇ¡ <¬∫+¬$\¿&|¬*¸Å<¬-º¬0úæ)√Œ¬4|√c√¨√8‹√;√>º<ƒDå¬ElƒGúƒú6ƒÃƒJ¸ƒYƒJÏƒP\≈á@≈å≈V≈Zå¿]º≈I¸≈,∆`Lƒd¿g\∆=ú∆˙À∆jL√nløq¸∆+<«Úk«tL¬xæD ∞([∞ [éy<»å–«~º≤~,»Eå∂QΩJ»tÃ»ç¨èL√82…o…öºó‹»ô≈M1…¥…§ú°‹»£l≈!1…ÚZ ™<…Ó@«¬a´ Á ∂<ÀUÀ[|∂JE∂lÀºQæ∆∑`´ú˚ÀU\ÃuˇÃ7¨5æ$≈»∆Œ¨–Ï√À‡K}Õê|ÕzëÕVºÆ@§ÕÆŒö%7$Œ»lŒ Û∆ô  ãŒö‹ŒÔƒO–LpD@A>‡<¿ 1Iˇ‹œ˚úœ6€Ãœ\œ˜¨œ˚‹œˇ–90–>∞œA@ù–›[Ø9ÄH∞z®
Ä ÎÀ$]“'I .ªüZGÀ´
ùø J®.êØ˚˙1'ªÆ&ù”∂j"’Ÿ*≥I üm∫4j£∫§ 9ÍK(}9 ≥ﬁ:—}s≈MÄ–ã—.ãQ’mïe„œ˜ä∏˘∫n#“∂J 
‡Æ/£C˝“ÖÀÍ$p®âÍK=˝ˇ”)Hß +’mU’ã°IYmœÿÉœ^m`M5˝T;ÕßMÌ˚Y…`ã¢:*˜π®ÕÇ§5€ ;≤Ö⁄Làä”5Uû6Ä•lù∫I†/+B§õ⁄‘, Ø7Àiø≠,◊òJ•˙õH€¥D`≤tüUÍõÁ©Ÿ&÷…qßyJ◊;:⁄•∏±ióJÌ¢øí€s'6p£I=8)–ö∫ Ó9ûÂ˘®P[ßÏŸ›?äº‹ÙHπ‘ Îä 04⁄¬˝Åƒ]›Ω¢®ÊùûMêÔ°®e&:∂G¿€e))'∞ËMè˚Ω y—"¯@⁄†ã¢4@∆Ÿ"ﬂ¥µﬂ$‡û?‡º;ˇ‡k£
@û‡gß·4‡©ãö!>û$é·AÉÇy(#<∞÷Å˚<–ﬂr»‚&N[\s…6é„Ç´„<ﬁ )pﬁ¨E'ÍX‚÷ªﬂ‚àRJ˛„AsÇ $N‰Dù$‡‰!0œyó±° IŒæDêÜ"!“mÂ‡!–Q0DÚ{˚bñ!∞ó⁄b"!>ﬁΩG@Ê>2ÃnÆV.sŸ‘Àwé {dX◊Q†ÁÔUqÖG‡(pŒæGpÎüáSjÃpúr2nÂD‡@Ël8ÇU>,@j
˜¿„RöônI†5@È¬±méˇ	"ù \ ÊøÆÅ— ƒ˛¿A¿ﬁﬂ¯®`=0‹Q≤=—ŒÖ8lf]ÍDqP–ﬁ¡>@ Óå`Ä≠ﬁøMP"≤ﬁø˙Ó=êÏ	!øÁ√?÷Q\ﬁøOêßıÓ ·¢ƒ‘6äQ0å¡£“p}Ev^Ìâ¿pá∞Òñ†ïƒ$Óz…
‚nïÒä@.‡AÛF
Ô>¥;o£°∂€¶öÛü¡Ú.ﬂ.*öâ û¢√Û$G¶Í˙ÄÒ–∑Ú-ü=8üÛ6‡JEıIZ0MAÈÅÓÎ`:rÇ )a—Ä)—q!˘>¡"ìfﬂﬁSí†ˆïëâ!ˇéˇ"ˆ¬Õtœ|'ªnÂåS0øz„60P@§zq5†˜Ñ„ıÇˆÉ—≤TLä/4U	vOˆ•ê¯_C8Üè'óü¡ÏKNsøÁ”Z4PQ4d'-±üd(3±/WÖ‡µﬂÈ# ò”˙P˙óí≥Ó\ÒÂ~äÓÓ
?°@}ü'¡o27ë˙3±˙(#E≤ê¬ÔŒ¢‡mı⁄P‡˚¿Ô€oŒoﬂ#˛Rr∫>‡pˆl¡<íÄ-≥€D1ûÉpˇŸ¢Ò¥ 9PÑÖÑOÜãÜDÇåIÜ!ÖëÑL GÑ9 >ó <å¢£§ÜG D•™´¨ˇ≠ÆØ∞±≤≥¥µ§∂´Ö!PAã$'õùü°D6Öò
P>†Ö)äúûPò°ÿLêÃô∆◊Ÿ¡√≈Pñÿ‡P©ÖM M∫™î§4Ò§Üºå<πÑér4°·6,Æ⁄‰ÅB,t QOl§»°hù âE÷Ôî'¿s°†#>Q.æúI≥¶Õõ8pë
 ÀûX¶ì$JïPX*“Wà	 ›å:∫≤%°   êY≤’§Vãv£Bœ§J≈H{∂êãr(àÍ—C∞ÛÇH$§	sÄ]ºz	 @¢ÇÄÏé`–‰Å@$GáˇÛ≤ª‰¡\‹πÜ\hM·Å)N1⁄™^Õ∫u-\o6A ‡DÖAåÇ∞%$i”ÜﬁB¡ ¿P pìé.]»«âYÕ~¶´‹7Û‹ª…•n®BÏõ4í‚‰≤ßnóOB ê∏.@ ¿û$"Ä∞ …	ø˜&§I @7»‰H2Üı◊m	z•{õ)g—YO<‚⁄ÖfËö)ú5  G	ÅÖñ’wÖúE≈V¢Ñ(BqÑ»9∏^{ºù8
âÜ§wcÑÑ∏#bM)8C 8mA&äh¿x§–d â$`ÄÄM–Ö~NäÙ5b )Ä…]óÑDiH,>YˇìïD@√b…·d¶ÜxÊ©ÁK$4ô!‘g¿ô(téútä¢$î-r\rI Ê"O`§â~F:Á§¡˙&|å––ÀYº8
“ıtÇõãl–‚Åe“'#!∏ê√≠xÂ‡	¨ÑTtƒq©}≤˜0¬ÎñÍrJáå∏ZÉ4ê4U`“ûÿf´-)éxJM“ ¿µ¡à˜l¥”.≤j!4˙åÖ–B!-*¢êPl´ç∆;/êAò€¨ªÑTlN–Pªà#D·DC¬¢Ñ˜ﬁì¢5to!`±Ä `÷±cÇ! Ñì∑Pûb‚ªa‚YMcºÌÃ4„π¡|7E¿,ˇOôF¬«Õô¸…ÀÚ:cjMÀµëu© ‚-=Ù0@7ÏØºPı$üñ•+s<9ƒFí!??Lq/c‹D [ö{,£Vpiq¬_êÉº=™!M“à@«êuöw◊DÑ u÷¨¯‚6a π3"4‡¶‡tEPxÿ∆aí	Mb.R·›ÌLv‡ÉCI:ñìR∂ ~‚TÒê¢Tˆu->4√Ó1Ñ√,h"o!$¬/Ê¬90§Æ€@/¸êDÉë,Ü‡Éˇ//ÚP`CG,º“vîÑ ÊÄMD∞:„Ù◊ü”p=Sª±t;˚Å‹‰ˇéwΩKÕ	å$v¨Ø}ÉH	"”§ÛâxÑx ›gúâYpx'´ Or≤π¬`X<óï
†	O`QR;I ‡)ÿÄdƒ PãKP¡s∏CU ,¿@TòPÅË–Eà8‘!!Ï! ëç-Ü°ay|†ÄZ	Ã&6¿¸ÏG∆2‚8ì.“£Äﬁa¿ 'òΩ,∂ /ÏbêÜÕ—_\«z*ptã3¨as∫H∂≈±G2‘‚"‹Ò∑ó0!&|≈OBp2ú¿HùƒÜA9
&à®	CbB'i˜…RVrçıIúgIKZ0°xﬂLûp%ÅvˇLxe>\		5∂R¡≈/qLJë&9  7f°Ë≤ñÿîE,6∂lzÛõ•¿ ¡INW$Å8¶ìEC@‘Õr∫3–9A(ﬂIœY:$e=Ω…Ñß,JGpUºµœY˙†âR,®Bkô Fòµü/¯ß@ÛåËÃû Æq›N£ •ôh¥ÇÜ¥f>pïTHì#®Gr=)Üà@TÒô2ÕiÕ¸°@TßJhÉVy2,ÚNÅ∫ö#§Ä6∫£Sß∫ß$§`1pÅ>©⁄&∏ :H¡OoBÑ,ÊÜÌ‰jMÇp⁄‡KU´\ıƒd1¶s≠ˇR¿"hOOl•M˛h0÷º™"	4(°VNêV√:6O> ¡b‰GÉ≠>vL†Ae2Fì‚)	1¿K∆<@ÿÀV≥ã¿k⁄÷6êYA@hW◊‚4btñWø § 7¬ x UÆ6ÅI¥ÎcR–X€:WCO¡oÉ[&Àrï	<Hî´3dîqAp¡ì1l§∂ eûv…kÄ∏†πœçÔûà‡0à Ñ¥æ´—'(√6v’ä\Ä◊2ó7k°6–G"◊õMPFi€aWæÆ_∂Á
k'†A¨Àœ –‡VRÄ}‡r˙˜ƒ)Œä4ˇ7pÇ†ófl¬xÉl ó-D ài∞ﬂπñG–»∞<* $pÅFLK&¡.®ì≥"Ä˜Ω2›q¥‹‰¨‡.!†°Æàê˛⁄‰	I Çr¿«`†‰ÂÚìI`c0˘œ≥dÇh@ö‰ô=
®@g§ÃÉ AïÆy~%>ƒQn6≥ÊR@êxÆº4H∞Å8Ùé2F /Ê·Å‡ê.‡fÉ[Ÿ¿≥ÊùXêÇÑ¿∏à "2ÌBD`$`Aßè‡f@;€ùIB,ÌÅ
‡’fV@¨µ#.àufMk[„:◊1wØI ˇlT5@án·ô]»ÅµnBú≈ú‡g∏∞∂`1ÿT e∆#¬n1hõ€! F˘l¿6∑¯Ÿg™§)Mêu∑[ÿ/¯¡éº†·⁄é ´øÌ4˙—ÕŒxM6†?ô€¸Ê±†9Œ…®Ûù˚¸Á•Ë9–'Ù°˝ÁE?∫∂íÆÙ¶cúÈNœ‘£NuOΩÍ∫:÷∑nZ≠s]5^ˇ∫ÿ’ˆ±„§ÏfOªL—Æˆô∞ΩÌp/Ë€„nãπ”˝Ó‡¥;ﬁs^ÛΩ˚ùûzˇ{+/¯¬/éÜøEﬂœx3"æÒ≠Z<‰'x…SﬁèøºÊ¡n˘Õ´"ÛûΩM@?y“ˇã˛ÙÒ0}„Uè˙÷ÀÇıâáΩÎgœ
Ÿﬁˆ¥œΩ(pˇwﬁÎ˛˜P˝ﬁÖ|⁄ˇÓ«/~ÎìwÊ+_ÙŒo{Ùüø˘Èß›˙‘ß<ˆ«æ˝ÏØæÛπÔæ˜c~„ó¸Ë7Ñ¯πæ˛Ù˚Ω˝Xáø˚ë~◊À˛ÕØˇÚıèÍﬂﬂËGn
† 7Ä⁄Êg˝ó{hÄ8ÄÄÄóG7ÿ÷B¯ñÄ≠'Å 8yÜjOcÅŸ◊ÅwÙÅ≥'8B Ë}&àm(ò{ò0ÅüñÇ≠˜ÇÿÉö®∂72ò}8xG:®{‚Çj1≤É¿Ñw4ÑÆÁ®vqDÿzJxGLzƒ—Bê”Ñ≈7ˇÖYQÖπ7&-ƒRV|\ò^ò{“B1˜ÖßWÜYqÜ–ó¸áÜ°Á* Üû&— á‘gáFzíñG@A>‡<¿·>Ö8àÅHGêêÜáç◊áàÉXàáòâËãÿàèÿvL@¸6jpgGlxäßxr™Üﬁ6qgÉê¯güäÏFä`ä®òãw§äw—ä1@qD ãœï¢fg◊∂ã∆∆ä' k£+A¿fL`J®ÙÂAç®‘—gÇò∏∂kq7`ägÜ"”iãjEåaåÒF …ÿÃXköç“C’¯◊òçÄ8g›Ëo£hj‚àˇf ÊÁ»TI¿.ph∆∂h6@êlòpÊXG¶vGS+<PêË∏OôêyGYHŸf{2ëÈ)o†ëIOÿU_[∆ö√S&åŸbe6¿*`]6`<ÄìYeŸaMF 5yìÿ§ì<âIzîBIK«µ^fFH"Öµ‘&fÏe^6î‰4ïSï!X)ï[íÂU&gY?I`∫ï1√¬bTµaF^≤e/	ñÚñqŸ^	—ñÔdó„[!†óŸ‘pI^∞*Ç	R«ıfvòè…ó™°ò¸ìç˘ïèô8h îIFG¿8®3’ZæUö¡cˇôÿ2ö•…\Fñööπö5„TnÅqOêô©T¨â!∂ô1∏ëóµõΩôxô,±XßÈlÅ 
‡ï˘õØ–ÀâV?˜ú—9ùÒÆSMGSvµÕIù¥‡ùÏ1A·YSsXû6ë,r[óM‘ ◊dûµ ü  üXGüqü8a¥…	t.•càü≠ †!S†?w†Wb,íOû¯‡û
jï>◊OÅ°∞O±{9tI‡*$@ú¨)¢sX¢@w¢å°¢‹Bpû•v>` P`‘I4˙w7ö£¯FŒ#xO∞)î°£ §2ZuEz§∂ 8≤$x?¡6H
ˇ•ç7•˘9!ê'. jûúÄÑ~«•≥∞>ÈÙqkh *·n≤=ä1∞COÄ\§‡[, $†E¿¡Qe¬O–;' Ù5ãÄ∞á∫0.∫Éd⁄9!p∫TÇ∆Œ°U£®ã >∑fH^®·’\÷ŸYπQ>œÙßÆ∆ùØ†®≤pgäm◊"±1zäb´3º‘FS‰é;" ‰ÖÇÄm
06IÄ <ê–M‰È8ΩÊìVtDê?±§•pH:±Éé00∂:#)”' ã¿ôiTŸj
wD:…J 4‚Ö≥Qm†R€ä´aña≈‘
ßP£uÁ]"Ò9ˇL*Á/√ú†`BV"
9`>`Wë &ÏQAéÏ≤7é$«t£¬u	7äÜ˘J!ƒ,Kß`*IÄ(ë*T≤í‡i—Ë+/«·Ö1†?A'>ˆÒA“ ,êÜ√7Ô`ﬂO2U–„B@Ç[B6è l^&¸@~".⁄qÈ$¬—gãüG€$ ,3µARµ √≤í†?m sKj$∂Ô†ËÄ	¬#µT˚|{!i;xt8eq	'«OAú>>P>˙Ä£ÜéVÎæı>¶&,2Ü0ÄÑA1'Aƒ1ˇk™îU°A 8‡r$î∏M(|tV!¡bπœr5åA
#a∑ã∑“[\¡Q©[YAï‰n∑Ñé∆kïE@ëõ≥-πﬁ1E˚9^ı:ÓÚ(Ùa>¥·M§VÇW€ ã˛E&›—"bÔCÌBE÷øëA––!˚

ô°ŸõL¿∏˚ºB0LΩÀ¸2|¬KŒÅÉ©Çø®∞_òqö1œ“¿Ma˘[díAñë¸
£xôKDZä≈¿"ç–ª.¿,ò`OÒ$∏dµË√FıE`í8ƒ°"ÜP·™#]•5¡ä⁄¬9¡ˇ	Ã3w∏"ºk*Ã ÖC≈l
4R'Jº
B@“;‹‚1∆á` WlP¸
1@m!*M·.4Ú–a5Ú8T¢jÚBp4êˆ"¨j¡\<p7–ê8MTÄ"(t¡∆á≤)uR!NºK1ë°s,≠™¿¶T¡≥a É\»ãê»ã¿&—  L•'a)±RO¢&ò$ÇL» l|'mÅ`*
}„ 5HPP˛RG–.Ü Ò∆ùJD&áL¡\sNï ø"a$‡¬Ω&A…˙í.ú…/1«®öÇ¡|ër+‹29–
Õé K®ºÀíŒ∂∆Œgb/±l6Ωíˇ,—(ÔÕ˘—(ƒ≤‰)@  
ÓD©ÛLp4Öê4ò¨
¸””‡M‡Â!FóK:Ø/Ã∆RìÊP—8¡P¶‘ô–=
7z1ìU(ãp—ß¨≈ãÄ3}1Ïa”ãó¬∆%”I+s”–l<2m¡“.Ω
O† ?X€ú"êûCMBp.a‘π„'›b∆LL$‡ºÇí4ñ¿∆¢C8°,ŒÒaë°Q=’5Q≈¿{’Ö0œ|„7îÚ≈ãpD˚å&√°◊Ø”◊Ô√∆v”]™v-£I@ ‡…• Bã ≈¨CD@@
Ç>∞W)ˇeµŒõCCCª√f¡“∏ëXæ–?ó‚*˙†A'¡A2ÿ¯€µ®DXŸó-ëÑ©MµU>„3∫TZ≈DAÍ˜¬ﬁ”‡ÛAÈS®…ç€w¨=‹Ûf¡]G` idîƒ>±õƒ{‘GÜÄY±3Dk¿ë; (;”.®fG–òñFl‰Fëßv’∂ÃHÅÑû–‹3qI¿±8ﬁÂ}|=ﬂ◊a<ù”TdEQ¡,DHúz1P‡$EDD@ë§H Aﬂùj‚ó–D˚”lhn∑‘ªT[Ø4$º‰øíQí¥√KóLmq£”T≠ãê„˙zFA@ˇúgÈàÆ–âÌ–IAÓ
®dJN„'Ò!PŒ@◊ıë¢Lé`.Ê?GÊ1J>é-ÿv.‡éO^≠oN qÆvsé u>séò-szãy~Ê£Á,.vÉéÁ2-ÌÂ≤ò–êjnôM‡Ë) ÈG∆íNÈ´—G;áà:tû1,PÈ‘	Íã±£t•˛®Ó
˛˘V:
heµ¸iË∂0Î'PÎvÎ˚Ÿ¨!T4Çù8ßù>•Î3AÏÃπs».‹3±W4"?`ÌlL`õ≈!æÆÏØ ÌÏ·’h◊ûÌ)∞ÌÆë∞ù$–ŒÒ≈ÑLa"Ì‹~XÈÆ ÎÆÈÂÓ$ ˇÔÑJF—:±Â1`ÓE1`_Y— '¿ØÛiŒ¡"6èeËy2ß)‡	Ô;f©SZŸ;üÀeÇÒøFŸ≈Ò·Ò±ÆaØ˚\vD≈ZPIF¿efCFe0πïcâG@‰{ÚãSÛ7_^eâÔÿbe0F^èÙ7ûM…ì–d]Fc6Ê`da<Êc3ô0\Ú.Ù√é\vAıVc◊Úûä=∂dTﬂ _øëé%h'ˆcƒvf»¶lˆs¨±q“Ü§vå2÷ 4÷iH/ˆzB˜>dÚF¯…6»éfÂ2i?j?vh3bûfd°Üe§fj	áGñ÷“ˇj$ÄD·∂;≥vkÊÜn·∆k?3ä`◊sGulQˆêÃÜ¯:’˘YVjßf˚£_˙á˙‚∂˙µ∆çÁ∂;Øü±è*¥˙∑èlRÊªotîœÁk¿6˚à r%g˚wr8 –mÆn.˘º/_Ÿø˝ø∂ﬁOp∑8r‚org˛ËèC-˜ráPÇÉÑÖÜáàâäãåçéèêPëïñóòôöõúùûü†°¢£Üì§ß®©™ê¶´ÆØ∞±≤≥¥µñ≠∂π∫¥∏ªæø¿¡¬√õΩƒ«»ç∆…ÃÕŒœ–ïÀ—‘ø”’ÿŸ⁄€∞◊‹ﬂ©ﬁ‡„‰ÂÊÑ‚ÁÍóÈÎÓÔ¿ÌÒÙ•îıˇ¯˘˙ÆÛ˚Ò˝˛
hè`@Ä*¸woa=Ñ#J‰q"∂ä3jDÜq£≥éCä‰’p$8ê&S™Ör•µí.c T’r¶≠ö6sÍ,Ñsg7ò>É
e‘sh8†Fì&-™î%“¶Pu2ç˙i*’´≠b’§u´◊áOø∆Í*∂¨:≤f°MÀñbÿ∂®÷¬ùM.]ûoÔÍÖgwØ§º~óÎªó∞‡√µﬂUå∏Ò+∆s!;û|Jr[Àî3W¨˘ÊŒ†1}6;:¥iœúO'*≠∫5"÷_aªV˝$áÌ"‹ŒÒd∂≤‘æÉáÚ†∏Ò„>Ñ+í≠º≥Ä„«4_|∫ıK!†ˇq
‡	û ëÓË7◊ ˘u&Ïç3IOÌ“7àﬂ†æˇJ'hwBz1ƒ√:BÑvÁ°◊D|M$(·"g@}hW¡Ñ"í¬q)‘gÉv6th"!GwD}Oh◊€â0*Púˇmp\u0vÁBq.¸ó√q9‰#| Ã˜ﬂs H'dZMÿpD)ÂîTViÂïXJ9^ñ\vÈeîú`CÑWe wKäÑç 0¿¡&ƒ)Áút÷iÁùx∆)ÇyˆÈÁü&å¿≈mUÎπó&VI`  3,·ƒ§îVjÈ•òf™È¶úvÍ)ßKÃ  $a”M0qˇA¥ÍÉ<ê√x9ƒ˙j´AqMº∏®N4∞¿ükÏ±»&´È@√DO$6∏ê	`Åàﬂ∑‡Gû
DÄÅ$§‡Ç<ëÑØøND &(kÔΩ¯Ê;©	 ê ATK¬ Ä§q‰öãÆ∫1ÿP´∫&¡ØΩ>Ø≈®¶ D´¬öÉ1Xã≠∂‹B' l@¬∫AØ@6ﬁ†ÔÃ4◊úÈ ‡òM<∏@BXÿÄ ,–¿L¿õÀL¡,‹@Ö∆!P¡ <ò˙2=ÛkÛ◊`ÎªCøÁëC
]xêÇ>hΩM>ÿêÇˇ‹W§ê√ä[õC 2ám¯·»‚¸,7DƒBH"Ä¡€DêODÿçÅ⁄4BÆM‘ã¯È®sjÇ rC”D'Dú ê@JÙ4ê {íúêÉÂ¢?ÉA©'Øº•	`ÃÎ$»Ä!– ∏GG–ÇÙ
ê0|ÒÃ Àóü< äL)Ï@'êªIOpÇ˚§:¯¡l¿Ä˘ DtÊ
Ñ†Bﬁ¸fRÕ !Pˇt—"x ^ª‘nPÇJa ÑA·&µh`Ñó°
gÄ¬I	A‰≥‘;H©Æ ˜˙
V`ÑˇN¡  §EBpü∏‡zM9ÇˆCÄ®oÇµ¯ë8•Ñ@ôöA
P)gî˙úÄ dÍá–c•Ü  X–RZ‰‚§D'· -P÷4`!d T@êt—Õà.€
ñ ∏ÄxP|≈	–©  XÃî‰Ë#d¿†DB•(ÄÇIıSÿÅ§&Å7VJnƒ‘&'U L—	ËÀ`±~ ÄS ∫ƒ‘dã#ÑÄ<'@¢YépÒÑ@ôëL4)LjJ†î\i©îrS?®ly©! `≤Ã¶$†N'( j4ŒbhÑÒqˇJŒ£’ÄÌ≈˚¡¿˛¢yäd≤S÷¨î^`Ç`sRJ@kÿ \‡Ö[ÇL)Lµ@ï*!
–áNà2‘°Í,@;ùP Ñq(¿!•4 —U:A ò"
ê«)D`I∞Qûò dh≠#®(0Çj‘éËÅ^  u"aõ@ Ë96¸ åC† 50 0Z
/†î	>∞#å™§CàÍT´:© ¿¶£íTúúp…¶⁄Q¨N ´YW Äò@∑‹‘ ã5Ä®à	¬~B§‘Q0’©ïb Y∫“}Ä ∑\ æÈÑ§’	ºl·8EâÀªNÍáˇ%’,•T:G¬QäpB8ôÅˇïˆ¥©•acŸ©≈¬‚
 Ä?5c( öï›ƒe=ïP'å-ÜÅÌÏ§*ZÉIâˆõ8;e¶^ JA¿∑v<ßuÌ9©á:	  j–∆Ú.†éñ
/¶‚˙Ç˚òN±åuÖÄHf¶	¿r£ÀâÈ"Ù†ÑØ{-5Œo~wR( ß ∞J	 øÈEgÑ)5·%¥`õº,Âh/ï·L†ªH T8Ïäı®56fp'Ã©ÍÚ´§ŸÕ‘ 2∫b2≤SÔ/ xb'¸òƒ⁄u¬
 ©6±¯»5tm'∞ŸLWZ∞jFt kÇ«õ™ˇn-:·ê ¥EÆ%àï–]JΩ ΩNH  XkNtÆ ó™eIılV'¯ sÓnE≈À j“8‚+Û(ö@ø]¨“<HDT?$¬. Íl@ÍRgZî∂Ù!ö‡iB0°‘3ƒb@#•ö7Öxu©)äA÷Ãë@s¶∆	b'@ ƒ2Çxp®Ç<∂∑ŒNÄÂA  Ë`∞îHkh  “»"ò‚±ìΩÏê »µ, pLä⁄÷∆ˆ§ÃÈÏ% ⁄^0*¯v
"( OpÅåî»œ¯ıÇ L `’†Aû4àA'ü˛∏¿)à‰áP!ˇö∏,„8»ENä¥¬æº8 ú“Ñ*Ä( Å<“\#ò1j/PXH (ƒÎN zR*@õV0 ‡ÁÖ›yœ'ıÉ ÷R0ò›i;ôÙGâ	¯¿
∂Œ©/übDÖà	Öl
@Và'8J“õ;Ñπa bn¿æäÄ?Á>ªÇ¯∏ ò∞ÅâÒäI Ä
¡xA8~ÚïüòÅA1ø‹1/ñ$e”˜
AıâùÈÎ1≈tÖ≤ûRB¶•j—ÿS OteÚ9
Ò-w^Ái¿OÒ∏Bê “É¿ ç
AúSC!ËÕ˛ˇ!„˘ÉH	öI€ÕØÄó˜~(òﬂ ‡ÀS¿˙”ÃÌ§0¿çG1∏Âí
,  %Ú E9-x4¬>É4/.Û#º61pw˝Wq  i‰ájHRyÑ ã3(ˇ◊w¢‡rz¡ÊWˆ˜Ç6É£@ !(
#Bw‚3 M4'P»õóÄ—'9“ õÁ(Ñ >≠F∞8789()p(MP!`}Ú3¥sO(QxÖYò$÷G
«Ç-Élx˙F

@Y£ ˝!<pÅ®4@<!B(é¢5é¬˚A‚/#ˇ dBáÉpá≠VÖÑ!!t!I` 01Ô”àx8â Pâ®ê”ßÜ®ÁÇmòäzÙÜ£@uH
;‚=≥Í√!ê`$.pjàwØHæ I K(4∞|Çã≥ò>M–íH$w∏Ñ#" »Høç®– àhäç@™é¬G
"A¢¿>)pê}P@u88Œì∫a#90P2-≤!GƒÅPPí&Ü)êéÎ¯!‡∑ë`9`éV =}ìó3iêÏX≤¢@Âçâ é‚íñ"É,ë~™êür8/M‡í/˘Yêˇ˘8p(7#ÇDÇÇPÄíÇ0©â°xwÖ@ AzgR@âHI
O¿o˘ç®(íXâ)$)
M` ƒw
Pä–çƒëTΩXìﬁ—•7˜ÛxØhayœÖ@&Pä(YÉuWäÖuI
B9zU	óWôïÜ9)[)
G@ ÚÁO‡`94,¿óÇpñ'Ö˜p”7ïU©èê9zUË(¿kG  ÍC|˘òë9¶˘"©Ÿr ]ÉIò˘ÚBÿµŒF)Öπ)7_ô2Cô¢#Ä]Âìòä…6>ô	î¶}∑=éS*Ü–ã>`w∂(áPˇ$16	 Iù ˘Åírcyuê,`r®vå âû„◊ëù¿yÉõπY Ÿ)lD\•EI∏W^ü≤[úîE[Ñ)]†À…ä®¿ïüêIEOpÇâLÉ£w°Ü@°ë–GDó7 ∫j#J
9@ ú˚I˝Ÿ)∞ƒMñÇøÈ)≥tOZ)óD£ó‚£ü§#È†©!÷ôç ‹˘¢ä£ú“gö≤ º∑)S÷)mˆJz);∞£ü≤•≈E§©@–/.JL0/`üLz â:`h(t"ERødqE)H (0fïß{jVU™C@ÊN'5a5 ˇd3J)C #Pg;0E):`£âÂß|j]ê⁄BCJ9`0$P°t!~'SûköúÂE†"0 †µ/lÂVÍ5U–N*†µ í¢Ë§∫X%ı@GD˜Mq%UT’Nê[.D\k◊IêG@‡ ∞2ı3 0 ØÁ´ªäN”Z≠2ïo∂`2rxz·6¢ ¶W™äP≈Ü)è2)8#3Ë≥J∞e^Ìƒ f’ZË‰Øì∞ìÚN˜n*[ìB[\óAâjlôtjtú¥¶SOc$∞N@∞N@±ùÚFY<‡(¿†∫I¿AÉgËÆç‡Ÿñˇf¯EoNp^ä:´´NF¿d:  _7)=˚≥ÎRCª^ÿu•∏G\F0EB∞ Í‰±{{"?A{Pª)∞yªê)P!‡e:ã4¶ê'Î≤ä¿\j)àfJ êGv≥@vÍ‘ƒ9I‚Jz+ ÆÙD+e.5bÌe—†8 (5)P˚NöÍ}ÎJY´)Påª`@E§?PAÌÛY§∂ó >¡Á∂¯UOy¥dtK)vÀJ„:)8`W§ı∫E∏îBªOV∏ôÚ∞&@†ÓµÜ)≤˚Mìª_ÈC>@¢yµÊL@p@	∫ë@ ƒy)oªey§ˇg|Ü≥´´+ÂJ¿E‚+G¥[¥Üªòí®øtZΩÀI	J)2`ÂÀ∏m[)& y«†D“H’£üë=!†6†	¿‘˚)@ ö"Z¿u Ä´3‡mÜI∑¥∫åZ)%C-@Iº]Jfƒ∏!<nùTnN éÊ=  K∞;@ ∞K–FC0&÷&÷jy‘¡N∞¡µu√≠W)∞§»>êøC ì√c;L¿)Ä˜A;)ÄxÏ	L  ¶AmD 7`D∑ ·uSWu2µ∫ UjÖG3`uNÊ∆p<  #*u‹TXßs<Ál	 Gb @>{ˇ /PK†c# Œ∆/≈a:& «2µ»7Z)*∞âÿ@.‡jC  &∏3ª„$†7‡.†¶Yº	ÿ7•ù2•<áKòÇCLÀ™w{ü2ƒﬁ5ƒ≥'NCL√ôb`ƒ’–íõ,=ç&4–2Ô 04$j3=®Ï∫ ûÄ ™/ á˘5∞ Ípv≥
Ä$† ∞26¿Ã‘ 0#}Ê¨ }clÕ°∞ö‹|/%ÄC	Äo›ú/Ä[œ‡¿>PixC5k£ ‡'∞.Ì≤+A$ï™2-’rpózS–6)@>ƒˆ|
wà™ü¬¿mˇå/z€≤˙ -9‡ˇ]S√‰bwÒá.'†.¶Ik4@§Fè6–”4!c-'Ä-Ä2]2⁄a v«–
È.!-#“¿)É^‘Æ
¡4G0-4`‘H≠-aâ /	„q0I2‡Òí†  w”„ß.F=’–‡∞ ≠{’À0 ”ÎÃa◊'9¶ ‡ |6F  iªÉMÿ™@r6óÿÜCøDg zπç)Ÿ⁄`˝ *u ¶}⁄®ù⁄™Ω⁄¨›⁄Æ˝⁄∞€®] R †’FŸ†Ω
O_Õ¿‹¬=‹ƒ]‹∆}‹»ù‹ Ω‹√ÌÀ—π˝Ÿª=›«†€‘}›Ï ˇ›ÿΩ›∫`›‹˝›ã‡›‡=ﬁAﬁÊÕ⁄}ﬁÍÌÎ›ﬁ/·ﬁù‚ﬂÿ=ﬂÙM›ˆ}ﬂªùﬂ˙-Ÿ¸›ﬂv˝ﬂ “>‡÷\‡û≈û‡‘ª‡Æ∂˛‡Ó·æ¶^·/z·ûõæ·UŸ·Óç ‚j8‚$~z&~‚¿ñ‚*Æc,ﬁ‚—ı‚0ÆT2>„—T„6.:¨‹
† ¬]Õ9Nﬂ‚Û-ø‰ û—–°øFn‡¬t∑‰æ Ï° PNﬂç0U˛‡ƒúÂ˜ù"–!–^æﬁ»<=cŒ‡;b°yÊ˙M$≈“l~ﬁc⁄ÿqû‡Úâu‡¢àyID¿xÛ%Ç>ˇËÑæ%Ñ~Ëàn%m√TﬁÁQ¡jR R[ÄRÈñnÈ# 'óæÈú^'% ä, ‰é>.0 PΩåŸá)%ÄÍYÍJ¡@/∫ÃÍáπ¸Ú p.Î+Ò	∞Í∏Œ◊Bê Ê·ÎC@∑>Ï)Ω¿ö»Ó´˘mŒÓÏ  b>Ì1ïŸ|ÌŒ&…Ì2AD¨ÓŒéMDÓ1!>˛åÓ∏^KEŒÓﬂÔ·éåÙ.¢{¯ŒÍc”Ë˚Ó$`∏»Ç(‡Ô|’/¿{3 tÆ´B‹VB'DB#¿CªßB"T)Ø{:ÑÒò2+ÄB8 ÒÜs ›8Å ◊õˇ,H†nJPÒQ@S K7jN∆ë¬bdddîv˜°ú^d}
Û2_){‘Gî_	@£:_)¸5&êô*Ø¢ú 1ÀRõeıïÌq[)∞†ƒt§dJCPRˆñÕûtˆÁÆı≥ECº‰K¿ú ÏRfˆ†t8ËCÍU?‚Éÿ]j[˚ ´ƒ –Ï"∞¬øâsSÍMäJˆ÷æMZj¯NÜ¯N0OpC83vø« ÑO3ı4ÔÅüwÿÏ≈“F‚¡Ë§∑BZ- ZøÈ»ÍFQ©gÂ5ı‚≈˙î‚˙ìÇS:≈S¬‹∂∂Ô£ì⁄æß,¢≈“ßØwò/ R+Vˇ ò Bg‘D˚îÇ%0*Û⁄I]ıU§õuUYµUìR˝YˆMÑeX?˚C∞IÜ˛„Øtdü≠€
BNÉÑÖÜáÖ <Påçéèêëíìîïñóòôöõúùûü†°¢£§•¶•< à´¨™Ñ? "F JNCFÉHNK -á@ (É¡»Ö:∆ á& ∑ÆÖ±"Ñ+  0Ñ›É“#Ü≈«É+&É¥¨ÓáäßÚÛÙıˆ˜¯˘˙˚¸ù©Ô ù@x5(ä ‘öë–…ä…Ñ≠*ê ‚2CF\·8‘@Åù4Ñ¡ùX#d≈A.àòyÄA@ÄÒ˙È‹ˇ…≥ßœü@É¢
yÛêÜê8<Óê∏@Üí5¢  °/C"X\%$e!$ÁéJ˙—IÅèH ¯!p@!pÇ∞jU b—õ9ÖÍ›À∑ØﬂøÄ˝ªãÄ!Ñ°ı!—á"G †¿FC-lù8Ï– àÜ/<ÏdÈí¶%úÄ p’â·÷Ñ2;GÁ¢¿∏sÎﬁÕª˜£¡µ—Ú6hÑf'Œ”C*[•$ÄËB;‹N»¯†é≠@Î`!Eáôûêÿ¡ù‰ıMøæ˝˚¯Gè_º‚†l9!Ñ ;ÚÇrt6Ñ@"ÑM Bƒπ÷ô
ù9°AˇYNå‡ü íƒ‘îıA;0ô∑`ÉBËDGÏ Ñ	Ú'ﬂm˘Â®„é<“∑üç%P–Ç	:Dt(P ﬂ L˝   îp— P ßΩ Ä †P`/  ¬‰êE‚ê¿+@Pc	¥ê¡=ÂE‚p„ïç7ˆËÁüÄ∫”è|˛Çà∑‹¥ÿMÜÇD\´4ä—uÜPJ“íÑ@ 'ì8
ÍÈß†Üö	°õñjÍ©®∆7ü®¨∂Í*†§¶*Î¨¥û∫Í´∏Ê™În±÷ÍÎØ¿∫sÎÆƒklOΩ´Ï≤µ{Ï≥–FkJ≤ÃVk-üŒJ´Ì∂‹VBÌµ‡ÜP∂›ñkÆˇ∂ﬂä´Ó∫Ñê{ÓªÍö.ªÙÇÎnº¯Ê˚ÈºÓ°¬e’ÿ!∞C®%+K‹êöÄ§√ [{ØæW¨#ø´,ÿúJ«9¡ØFà∞Ò*3DÜÀQÊπÛ8EV;±≈0«Ã∆\çl
œ \Àà†WPy aÛ!JD\œt*Û“LœLTpÃ•å»ò¶ ›; ã‘¨tÖt!n÷ômMómv`‘‚†É3†@È(†êî‘FH]“5+†¿bAy|√
ﬁ,—¬
\ˇê7ã√)É€Ö(ÒÇ	5d˝Ûé´–ZR{Ω#pò¡3/\•Œâ:Åƒ‚3 ∂√ñ/ÿµ Àg«.˚ˇ=Ω*qîà0 5‚|∞Ñ•¸B :°Ç
Ñò†é–‰t®¡@$ A¢	¥G¢ã 	 9åA0⁄ëƒ@Nº Ä÷œ,@A XÄ[◊¶F0Ã0 P¬∑|0Ä î∞Ä”h¿<@p¿ d$,•ÕÓÅºá P:D@iÅHRN„Ñ¸I≈cÄhj–'d¿&0 ôñp"!!NH?™`∞.É`¿¬ÃÇæ∆à ˙¡¡4¢l8·(ö¸¬é}Ã	EHŸJH ¯ ÇXÃ‚<é  M¡√áÃ\5B\ AF¯–|X¢  8M^ˇ°5Ç+hJó0…˝–uj©`¸÷q!, AJÑâLhb<£ÇS|GWé†≈JZ2@cÖk8.-'ìGD–ê⁄Ö'&=qXã	·F˘î≤ÜyÑ•CXsÙπn ÿ[¶6ÜDë·†ãÎ
ÅKT(íÓ`»%ó…ÃLDÄçÙ!-ÜÄïqgˆƒCË¢°YÂ ZŸMå  ñxtÇ4§Ê«X∏n,MD?&r:à¿Å1ñÅLV| Õ®@!·¯ΩNöI  uÕP:A	≈sÇBØcû*ïÈ”ÄA[9—ƒ»Rñ5êP/lI
úRû·( Ë§!ˇ`«dÓ1BÖ –û~Æb .®N⁄ÑïÆ"¯ÚíÅAFâ &Á
“+·‡2¿ÖHù@ ‚‰K0xﬂ-ö
ÉßF5
öB@ ˙È¢A± é¿"¥–	‰…cW ∞ÑÄo	K†KcÄ #—»	%∏ålú ≤!!ûÖ0_v XfíÄäÑXÇ»p#TilQA Ä∏1±(õ _!RHññ¶ #∏2¥µ††ÄUü$ :·sÿÅé"#®• 0ig>pÄò@{´^A(PãçÄ„ /ÈÙ@^HÉ
1¡Z0b)»LH–ÿÚZˇí	ÿ·]0eR'çòBô«ä™QÁ4à]aÚ_Cx—t˘≈Î*J  &ò˜¿Y§ ∆'
Ä†^&ÃRhÄ‡
Gp∞aJ–†p(¬ f≈∞õxvOh@4\Êr‡ï!é1I
–Ä'ú¯∆gkB¿`˚òOvm¿bqL‰¶=¥˘±íÉcÿ∏»Pfö⁄%[9 5 kN£ÃÂ•%aÁ3ÅhØLf∏ö¿  ÿ@∫ÃÊ•·hûÜ@Á:€˘ŒxŒ≥û˜ÃÁ>˚˘œÄ¥ùÄ ‡îl≥¢ΩúÉ∏Äêé¥§'MÈJ[˙“òŒ¥¶7ÕÈNK⁄&1»¡öMÍRõ˙‘®Nµ™WÕÍVª˙’∞éµ¨gMÎZ€˙÷∏ﬁG   ;                                                       go/src/github.com/docker/docker/docs/reference/commandline/dockerd.md                               0100644 0000000 0000000 00000152102 13101060260 024315  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
- /reference/commandline/dockerd/
- /reference/commandline/daemon/
- /engine/reference/commandline/daemon/
description: The daemon command description and usage
keywords:
- container, daemon, runtime
title: dockerd
---

```markdown
Usage: dockerd [OPTIONS]

A self-sufficient runtime for containers.

Options:

      --add-runtime=[]                       Register an additional OCI compatible runtime
      --api-cors-header                      Set CORS headers in the remote API
      --authorization-plugin=[]              Authorization plugins to load
      -b, --bridge                           Attach containers to a network bridge
      --bip                                  Specify network bridge IP
      --cgroup-parent                        Set parent cgroup for all containers
      --cluster-advertise                    Address or interface name to advertise
      --cluster-store                        URL of the distributed storage backend
      --cluster-store-opt=map[]              Set cluster store options
      --config-file=/etc/docker/daemon.json  Daemon configuration file
      --containerd                           Path to containerd socket
      -D, --debug                            Enable debug mode
      --default-gateway                      Container default gateway IPv4 address
      --default-gateway-v6                   Container default gateway IPv6 address
      --default-runtime=runc                 Default OCI runtime for containers
      --default-ulimit=[]                    Default ulimits for containers
      --disable-legacy-registry              Disable contacting legacy registries
      --dns=[]                               DNS server to use
      --dns-opt=[]                           DNS options to use
      --dns-search=[]                        DNS search domains to use
      --exec-opt=[]                          Runtime execution options
      --exec-root=/var/run/docker            Root directory for execution state files
      --fixed-cidr                           IPv4 subnet for fixed IPs
      --fixed-cidr-v6                        IPv6 subnet for fixed IPs
      -G, --group=docker                     Group for the unix socket
      -g, --graph=/var/lib/docker            Root of the Docker runtime
      -H, --host=[]                          Daemon socket(s) to connect to
      --help                                 Print usage
      --icc=true                             Enable inter-container communication
      --insecure-registry=[]                 Enable insecure registry communication
      --ip=0.0.0.0                           Default IP when binding container ports
      --ip-forward=true                      Enable net.ipv4.ip_forward
      --ip-masq=true                         Enable IP masquerading
      --iptables=true                        Enable addition of iptables rules
      --ipv6                                 Enable IPv6 networking
      -l, --log-level=info                   Set the logging level
      --label=[]                             Set key=value labels to the daemon
      --live-restore                         Enables keeping containers alive during daemon downtime
      --log-driver=json-file                 Default driver for container logs
      --log-opt=map[]                        Default log driver options for containers
      --max-concurrent-downloads=3           Set the max concurrent downloads for each pull
      --max-concurrent-uploads=5             Set the max concurrent uploads for each push
      --mtu                                  Set the containers network MTU
      --oom-score-adjust=-500                Set the oom_score_adj for the daemon
      -p, --pidfile=/var/run/docker.pid      Path to use for daemon PID file
      --raw-logs                             Full timestamps without ANSI coloring
      --registry-mirror=[]                   Preferred Docker registry mirror
      -s, --storage-driver                   Storage driver to use
      --selinux-enabled                      Enable selinux support
      --storage-opt=[]                       Storage driver options
      --swarm-default-advertise-addr         Set default address or interface for swarm advertised address
      --tls                                  Use TLS; implied by --tlsverify
      --tlscacert=~/.docker/ca.pem           Trust certs signed only by this CA
      --tlscert=~/.docker/cert.pem           Path to TLS certificate file
      --tlskey=~/.docker/key.pem             Path to TLS key file
      --tlsverify                            Use TLS and verify the remote
      --userland-proxy=true                  Use userland proxy for loopback traffic
      --userns-remap                         User/Group setting for user namespaces
      -v, --version                          Print version information and quit
```

Options with [] may be specified multiple times.

dockerd is the persistent process that manages containers. Docker
uses different binaries for the daemon and client. To run the daemon you
type `dockerd`.

To run the daemon with debug output, use `dockerd -D`.

## Daemon socket option

The Docker daemon can listen for [Docker Remote API](../api/docker_remote_api.md)
requests via three different types of Socket: `unix`, `tcp`, and `fd`.

By default, a `unix` domain socket (or IPC socket) is created at
`/var/run/docker.sock`, requiring either `root` permission, or `docker` group
membership.

If you need to access the Docker daemon remotely, you need to enable the `tcp`
Socket. Beware that the default setup provides un-encrypted and
un-authenticated direct access to the Docker daemon - and should be secured
either using the [built in HTTPS encrypted socket](../../security/https.md), or by
putting a secure web proxy in front of it. You can listen on port `2375` on all
network interfaces with `-H tcp://0.0.0.0:2375`, or on a particular network
interface using its IP address: `-H tcp://192.168.59.103:2375`. It is
conventional to use port `2375` for un-encrypted, and port `2376` for encrypted
communication with the daemon.

> **Note:**
> If you're using an HTTPS encrypted socket, keep in mind that only
> TLS1.0 and greater are supported. Protocols SSLv3 and under are not
> supported anymore for security reasons.

On Systemd based systems, you can communicate with the daemon via
[Systemd socket activation](http://0pointer.de/blog/projects/socket-activation.html),
use `dockerd -H fd://`. Using `fd://` will work perfectly for most setups but
you can also specify individual sockets: `dockerd -H fd://3`. If the
specified socket activated files aren't found, then Docker will exit. You can
find examples of using Systemd socket activation with Docker and Systemd in the
[Docker source tree](https://github.com/docker/docker/tree/master/contrib/init/systemd/).

You can configure the Docker daemon to listen to multiple sockets at the same
time using multiple `-H` options:

```bash
# listen using the default unix socket, and on 2 specific IP addresses on this host.
$ sudo dockerd -H unix:///var/run/docker.sock -H tcp://192.168.59.106 -H tcp://10.10.10.2
```

The Docker client will honor the `DOCKER_HOST` environment variable to set the
`-H` flag for the client.

```bash
$ docker -H tcp://0.0.0.0:2375 ps
# or
$ export DOCKER_HOST="tcp://0.0.0.0:2375"
$ docker ps
# both are equal
```

Setting the `DOCKER_TLS_VERIFY` environment variable to any value other than
the empty string is equivalent to setting the `--tlsverify` flag. The following
are equivalent:

```bash
$ docker --tlsverify ps
# or
$ export DOCKER_TLS_VERIFY=1
$ docker ps
```

The Docker client will honor the `HTTP_PROXY`, `HTTPS_PROXY`, and `NO_PROXY`
environment variables (or the lowercase versions thereof). `HTTPS_PROXY` takes
precedence over `HTTP_PROXY`.

### Bind Docker to another host/port or a Unix socket

> **Warning**:
> Changing the default `docker` daemon binding to a
> TCP port or Unix *docker* user group will increase your security risks
> by allowing non-root users to gain *root* access on the host. Make sure
> you control access to `docker`. If you are binding
> to a TCP port, anyone with access to that port has full Docker access;
> so it is not advisable on an open network.

With `-H` it is possible to make the Docker daemon to listen on a
specific IP and port. By default, it will listen on
`unix:///var/run/docker.sock` to allow only local connections by the
*root* user. You *could* set it to `0.0.0.0:2375` or a specific host IP
to give access to everybody, but that is **not recommended** because
then it is trivial for someone to gain root access to the host where the
daemon is running.

Similarly, the Docker client can use `-H` to connect to a custom port.
The Docker client will default to connecting to `unix:///var/run/docker.sock`
on Linux, and `tcp://127.0.0.1:2376` on Windows.

`-H` accepts host and port assignment in the following format:

    tcp://[host]:[port][path] or unix://path

For example:

-   `tcp://` -> TCP connection to `127.0.0.1` on either port `2376` when TLS encryption
    is on, or port `2375` when communication is in plain text.
-   `tcp://host:2375` -> TCP connection on
    host:2375
-   `tcp://host:2375/path` -> TCP connection on
    host:2375 and prepend path to all requests
-   `unix://path/to/socket` -> Unix socket located
    at `path/to/socket`

`-H`, when empty, will default to the same value as
when no `-H` was passed in.

`-H` also accepts short form for TCP bindings: `host:` or `host:port` or `:port`

Run Docker in daemon mode:

```bash
$ sudo <path to>/dockerd -H 0.0.0.0:5555 &
```

Download an `ubuntu` image:

```bash
$ docker -H :5555 pull ubuntu
```

You can use multiple `-H`, for example, if you want to listen on both
TCP and a Unix socket

```bash
# Run docker in daemon mode
$ sudo <path to>/dockerd -H tcp://127.0.0.1:2375 -H unix:///var/run/docker.sock &
# Download an ubuntu image, use default Unix socket
$ docker pull ubuntu
# OR use the TCP port
$ docker -H tcp://127.0.0.1:2375 pull ubuntu
```

### Daemon storage-driver option

The Docker daemon has support for several different image layer storage
drivers: `aufs`, `devicemapper`, `btrfs`, `zfs`, `overlay` and `overlay2`.

The `aufs` driver is the oldest, but is based on a Linux kernel patch-set that
is unlikely to be merged into the main kernel. These are also known to cause
some serious kernel crashes. However, `aufs` allows containers to share
executable and shared library memory, so is a useful choice when running
thousands of containers with the same program or libraries.

The `devicemapper` driver uses thin provisioning and Copy on Write (CoW)
snapshots. For each devicemapper graph location ‚Äì typically
`/var/lib/docker/devicemapper` ‚Äì a thin pool is created based on two block
devices, one for data and one for metadata. By default, these block devices
are created automatically by using loopback mounts of automatically created
sparse files. Refer to [Storage driver options](dockerd.md#storage-driver-options) below
for a way how to customize this setup.
[~jpetazzo/Resizing Docker containers with the Device Mapper plugin](http://jpetazzo.github.io/2014/01/29/docker-device-mapper-resize/)
article explains how to tune your existing setup without the use of options.

The `btrfs` driver is very fast for `docker build` - but like `devicemapper`
does not share executable memory between devices. Use
`dockerd -s btrfs -g /mnt/btrfs_partition`.

The `zfs` driver is probably not as fast as `btrfs` but has a longer track record
on stability. Thanks to `Single Copy ARC` shared blocks between clones will be
cached only once. Use `dockerd -s zfs`. To select a different zfs filesystem
set `zfs.fsname` option as described in [Storage driver options](dockerd.md#storage-driver-options).

The `overlay` is a very fast union filesystem. It is now merged in the main
Linux kernel as of [3.18.0](https://lkml.org/lkml/2014/10/26/137). `overlay`
also supports page cache sharing, this means multiple containers accessing
the same file can share a single page cache entry (or entries), it makes
`overlay` as efficient with memory as `aufs` driver. Call
`dockerd -s overlay` to use it.

> **Note:**
> As promising as `overlay` is, the feature is still quite young and should not
> be used in production. Most notably, using `overlay` can cause excessive
> inode consumption (especially as the number of images grows), as well as
> being incompatible with the use of RPMs.

The `overlay2` uses the same fast union filesystem but takes advantage of
[additional features](https://lkml.org/lkml/2015/2/11/106) added in Linux
kernel 4.0 to avoid excessive inode consumption. Call `dockerd -s overlay2`
to use it.

> **Note:**
> Both `overlay` and `overlay2` are currently unsupported on `btrfs` or any
> Copy on Write filesystem and should only be used over `ext4` partitions.

### Storage driver options

Particular storage-driver can be configured with options specified with
`--storage-opt` flags. Options for `devicemapper` are prefixed with `dm`,
options for `zfs` start with `zfs` and options for `btrfs` start with `btrfs`.

#### Devicemapper options

*   `dm.thinpooldev`

    Specifies a custom block storage device to use for the thin pool.

    If using a block device for device mapper storage, it is best to use `lvm`
    to create and manage the thin-pool volume. This volume is then handed to Docker
    to exclusively create snapshot volumes needed for images and containers.

    Managing the thin-pool outside of Engine makes for the most feature-rich
    method of having Docker utilize device mapper thin provisioning as the
    backing storage for Docker containers. The highlights of the lvm-based
    thin-pool management feature include: automatic or interactive thin-pool
    resize support, dynamically changing thin-pool features, automatic thinp
    metadata checking when lvm activates the thin-pool, etc.

    As a fallback if no thin pool is provided, loopback files are
    created. Loopback is very slow, but can be used without any
    pre-configuration of storage. It is strongly recommended that you do
    not use loopback in production. Ensure your Engine daemon has a
    `--storage-opt dm.thinpooldev` argument provided.

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.thinpooldev=/dev/mapper/thin-pool
    ```

*   `dm.basesize`

    Specifies the size to use when creating the base device, which limits the
    size of images and containers. The default value is 10G. Note, thin devices
    are inherently "sparse", so a 10G device which is mostly empty doesn't use
    10 GB of space on the pool. However, the filesystem will use more space for
    the empty case the larger the device is.

    The base device size can be increased at daemon restart which will allow
    all future images and containers (based on those new images) to be of the
    new base device size.

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.basesize=50G
    ```

    This will increase the base device size to 50G. The Docker daemon will throw an
    error if existing base device size is larger than 50G. A user can use
    this option to expand the base device size however shrinking is not permitted.

    This value affects the system-wide "base" empty filesystem
    that may already be initialized and inherited by pulled images. Typically,
    a change to this value requires additional steps to take effect:

     ```bash
    $ sudo service docker stop
    $ sudo rm -rf /var/lib/docker
    $ sudo service docker start
    ```

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.basesize=20G
    ```

*   `dm.loopdatasize`

    > **Note**:
    > This option configures devicemapper loopback, which should not
    > be used in production.

    Specifies the size to use when creating the loopback file for the
    "data" device which is used for the thin pool. The default size is
    100G. The file is sparse, so it will not initially take up this
    much space.

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.loopdatasize=200G
    ```

*   `dm.loopmetadatasize`

    > **Note**:
    > This option configures devicemapper loopback, which should not
    > be used in production.

    Specifies the size to use when creating the loopback file for the
    "metadata" device which is used for the thin pool. The default size
    is 2G. The file is sparse, so it will not initially take up
    this much space.

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.loopmetadatasize=4G
    ```

*   `dm.fs`

    Specifies the filesystem type to use for the base device. The supported
    options are "ext4" and "xfs". The default is "xfs"

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.fs=ext4
    ```

*   `dm.mkfsarg`

    Specifies extra mkfs arguments to be used when creating the base device.

    Example use:

    ```bash
    $ sudo dockerd --storage-opt "dm.mkfsarg=-O ^has_journal"
    ```

*   `dm.mountopt`

    Specifies extra mount options used when mounting the thin devices.

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.mountopt=nodiscard
    ```

*   `dm.datadev`

    (Deprecated, use `dm.thinpooldev`)

    Specifies a custom blockdevice to use for data for the thin pool.

    If using a block device for device mapper storage, ideally both datadev and
    metadatadev should be specified to completely avoid using the loopback
    device.

    Example use:

    ```bash
    $ sudo dockerd \
          --storage-opt dm.datadev=/dev/sdb1 \
          --storage-opt dm.metadatadev=/dev/sdc1
    ```

*   `dm.metadatadev`

    (Deprecated, use `dm.thinpooldev`)

    Specifies a custom blockdevice to use for metadata for the thin pool.

    For best performance the metadata should be on a different spindle than the
    data, or even better on an SSD.

    If setting up a new metadata pool it is required to be valid. This can be
    achieved by zeroing the first 4k to indicate empty metadata, like this:

    ```bash
    $ dd if=/dev/zero of=$metadata_dev bs=4096 count=1
    ```

    Example use:

    ```bash
    $ sudo dockerd \
          --storage-opt dm.datadev=/dev/sdb1 \
          --storage-opt dm.metadatadev=/dev/sdc1
    ```

*   `dm.blocksize`

    Specifies a custom blocksize to use for the thin pool. The default
    blocksize is 64K.

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.blocksize=512K
    ```

*   `dm.blkdiscard`

    Enables or disables the use of blkdiscard when removing devicemapper
    devices. This is enabled by default (only) if using loopback devices and is
    required to resparsify the loopback file on image/container removal.

    Disabling this on loopback can lead to *much* faster container removal
    times, but will make the space used in `/var/lib/docker` directory not be
    returned to the system for other use when containers are removed.

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.blkdiscard=false
    ```

*   `dm.override_udev_sync_check`

    Overrides the `udev` synchronization checks between `devicemapper` and `udev`.
    `udev` is the device manager for the Linux kernel.

    To view the `udev` sync support of a Docker daemon that is using the
    `devicemapper` driver, run:

    ```bash
    $ docker info
    [...]
    Udev Sync Supported: true
    [...]
    ```

    When `udev` sync support is `true`, then `devicemapper` and udev can
    coordinate the activation and deactivation of devices for containers.

    When `udev` sync support is `false`, a race condition occurs between
    the`devicemapper` and `udev` during create and cleanup. The race condition
    results in errors and failures. (For information on these failures, see
    [docker#4036](https://github.com/docker/docker/issues/4036))

    To allow the `docker` daemon to start, regardless of `udev` sync not being
    supported, set `dm.override_udev_sync_check` to true:

    ```bash
    $ sudo dockerd --storage-opt dm.override_udev_sync_check=true
    ```

    When this value is `true`, the  `devicemapper` continues and simply warns
    you the errors are happening.

    > **Note:**
    > The ideal is to pursue a `docker` daemon and environment that does
    > support synchronizing with `udev`. For further discussion on this
    > topic, see [docker#4036](https://github.com/docker/docker/issues/4036).
    > Otherwise, set this flag for migrating existing Docker daemons to
    > a daemon with a supported environment.

*   `dm.use_deferred_removal`

    Enables use of deferred device removal if `libdm` and the kernel driver
    support the mechanism.

    Deferred device removal means that if device is busy when devices are
    being removed/deactivated, then a deferred removal is scheduled on
    device. And devices automatically go away when last user of the device
    exits.

    For example, when a container exits, its associated thin device is removed.
    If that device has leaked into some other mount namespace and can't be
    removed, the container exit still succeeds and this option causes the
    system to schedule the device for deferred removal. It does not wait in a
    loop trying to remove a busy device.

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.use_deferred_removal=true
    ```

*   `dm.use_deferred_deletion`

    Enables use of deferred device deletion for thin pool devices. By default,
    thin pool device deletion is synchronous. Before a container is deleted,
    the Docker daemon removes any associated devices. If the storage driver
    can not remove a device, the container deletion fails and daemon returns.

        Error deleting container: Error response from daemon: Cannot destroy container

    To avoid this failure, enable both deferred device deletion and deferred
    device removal on the daemon.

    ```bash
    $ sudo dockerd \
          --storage-opt dm.use_deferred_deletion=true \
          --storage-opt dm.use_deferred_removal=true
    ```

    With these two options enabled, if a device is busy when the driver is
    deleting a container, the driver marks the device as deleted. Later, when
    the device isn't in use, the driver deletes it.

    In general it should be safe to enable this option by default. It will help
    when unintentional leaking of mount point happens across multiple mount
    namespaces.

*   `dm.min_free_space`

    Specifies the min free space percent in a thin pool require for new device
    creation to succeed. This check applies to both free data space as well
    as free metadata space. Valid values are from 0% - 99%. Value 0% disables
    free space checking logic. If user does not specify a value for this option,
    the Engine uses a default value of 10%.

    Whenever a new a thin pool device is created (during `docker pull` or during
    container creation), the Engine checks if the minimum free space is
    available. If sufficient space is unavailable, then device creation fails
    and any relevant `docker` operation fails.

    To recover from this error, you must create more free space in the thin pool
    to recover from the error. You can create free space by deleting some images
    and containers from the thin pool. You can also add more storage to the thin
    pool.

    To add more space to a LVM (logical volume management) thin pool, just add
    more storage to the volume group container thin pool; this should automatically
    resolve any errors. If your configuration uses loop devices, then stop the
    Engine daemon, grow the size of loop files and restart the daemon to resolve
    the issue.

    Example use:

    ```bash
    $ sudo dockerd --storage-opt dm.min_free_space=10%
    ```

#### ZFS options

*   `zfs.fsname`

    Set zfs filesystem under which docker will create its own datasets.
    By default docker will pick up the zfs filesystem where docker graph
    (`/var/lib/docker`) is located.

    Example use:

    ```bash
    $ sudo dockerd -s zfs --storage-opt zfs.fsname=zroot/docker
    ```

#### Btrfs options

*   `btrfs.min_space`

    Specifies the minimum size to use when creating the subvolume which is used
    for containers. If user uses disk quota for btrfs when creating or running
    a container with **--storage-opt size** option, docker should ensure the
    **size** cannot be smaller than **btrfs.min_space**.

    Example use:

    ```bash
    $ sudo dockerd -s btrfs --storage-opt btrfs.min_space=10G
    ```

#### Overlay2 options

*   `overlay2.override_kernel_check`

    Overrides the Linux kernel version check allowing overlay2. Support for
    specifying multiple lower directories needed by overlay2 was added to the
    Linux kernel in 4.0.0. However some older kernel versions may be patched
    to add multiple lower directory support for OverlayFS. This option should
    only be used after verifying this support exists in the kernel. Applying
    this option on a kernel without this support will cause failures on mount.

## Docker runtime execution options

The Docker daemon relies on a
[OCI](https://github.com/opencontainers/specs) compliant runtime
(invoked via the `containerd` daemon) as its interface to the Linux
kernel `namespaces`, `cgroups`, and `SELinux`.

By default, the Docker daemon automatically starts `containerd`. If you want to
control `containerd` startup, manually start `containerd` and pass the path to
the `containerd` socket using the `--containerd` flag. For example:

```bash
$ sudo dockerd --containerd /var/run/dev/docker-containerd.sock
```

Runtimes can be registered with the daemon either via the
configuration file or using the `--add-runtime` command line argument.

The following is an example adding 2 runtimes via the configuration:

```json
"default-runtime": "runc",
"runtimes": {
	"runc": {
		"path": "runc"
	},
	"custom": {
		"path": "/usr/local/bin/my-runc-replacement",
		"runtimeArgs": [
			"--debug"
		]
	}
}
```

This is the same example via the command line:

```bash
$ sudo dockerd --add-runtime runc=runc --add-runtime custom=/usr/local/bin/my-runc-replacement
```

> **Note**: defining runtime arguments via the command line is not supported.

## Options for the runtime

You can configure the runtime using options specified
with the `--exec-opt` flag. All the flag's options have the `native` prefix. A
single `native.cgroupdriver` option is available.

The `native.cgroupdriver` option specifies the management of the container's
cgroups. You can specify only specify `cgroupfs` or `systemd`. If you specify
`systemd` and it is not available, the system errors out. If you omit the
`native.cgroupdriver` option,` cgroupfs` is used.

This example sets the `cgroupdriver` to `systemd`:

```bash
$ sudo dockerd --exec-opt native.cgroupdriver=systemd
```

Setting this option applies to all containers the daemon launches.

Also Windows Container makes use of `--exec-opt` for special purpose. Docker user
can specify default container isolation technology with this, for example:

```bash
$ sudo dockerd --exec-opt isolation=hyperv
```

Will make `hyperv` the default isolation technology on Windows. If no isolation
value is specified on daemon start, on Windows client, the default is
`hyperv`, and on Windows server, the default is `process`.

## Daemon DNS options

To set the DNS server for all Docker containers, use:

```bash
$ sudo dockerd --dns 8.8.8.8
```


To set the DNS search domain for all Docker containers, use:

```bash
$ sudo dockerd --dns-search example.com
```


## Insecure registries

Docker considers a private registry either secure or insecure. In the rest of
this section, *registry* is used for *private registry*, and `myregistry:5000`
is a placeholder example for a private registry.

A secure registry uses TLS and a copy of its CA certificate is placed on the
Docker host at `/etc/docker/certs.d/myregistry:5000/ca.crt`. An insecure
registry is either not using TLS (i.e., listening on plain text HTTP), or is
using TLS with a CA certificate not known by the Docker daemon. The latter can
happen when the certificate was not found under
`/etc/docker/certs.d/myregistry:5000/`, or if the certificate verification
failed (i.e., wrong CA).

By default, Docker assumes all, but local (see local registries below),
registries are secure. Communicating with an insecure registry is not possible
if Docker assumes that registry is secure. In order to communicate with an
insecure registry, the Docker daemon requires `--insecure-registry` in one of
the following two forms:

* `--insecure-registry myregistry:5000` tells the Docker daemon that
  myregistry:5000 should be considered insecure.
* `--insecure-registry 10.1.0.0/16` tells the Docker daemon that all registries
  whose domain resolve to an IP address is part of the subnet described by the
  CIDR syntax, should be considered insecure.

The flag can be used multiple times to allow multiple registries to be marked
as insecure.

If an insecure registry is not marked as insecure, `docker pull`,
`docker push`, and `docker search` will result in an error message prompting
the user to either secure or pass the `--insecure-registry` flag to the Docker
daemon as described above.

Local registries, whose IP address falls in the 127.0.0.0/8 range, are
automatically marked as insecure as of Docker 1.3.2. It is not recommended to
rely on this, as it may change in the future.

Enabling `--insecure-registry`, i.e., allowing un-encrypted and/or untrusted
communication, can be useful when running a local registry.  However,
because its use creates security vulnerabilities it should ONLY be enabled for
testing purposes.  For increased security, users should add their CA to their
system's list of trusted CAs instead of enabling `--insecure-registry`.

## Legacy Registries

Enabling `--disable-legacy-registry` forces a docker daemon to only interact with registries which support the V2 protocol.  Specifically, the daemon will not attempt `push`, `pull` and `login` to v1 registries.  The exception to this is `search` which can still be performed on v1 registries.

## Running a Docker daemon behind an HTTPS_PROXY

When running inside a LAN that uses an `HTTPS` proxy, the Docker Hub
certificates will be replaced by the proxy's certificates. These certificates
need to be added to your Docker host's configuration:

1. Install the `ca-certificates` package for your distribution
2. Ask your network admin for the proxy's CA certificate and append them to
   `/etc/pki/tls/certs/ca-bundle.crt`
3. Then start your Docker daemon with `HTTPS_PROXY=http://username:password@proxy:port/ dockerd`.
   The `username:` and `password@` are optional - and are only needed if your
   proxy is set up to require authentication.

This will only add the proxy and authentication to the Docker daemon's requests -
your `docker build`s and running containers will need extra configuration to
use the proxy

## Default Ulimits

`--default-ulimit` allows you to set the default `ulimit` options to use for
all containers. It takes the same options as `--ulimit` for `docker run`. If
these defaults are not set, `ulimit` settings will be inherited, if not set on
`docker run`, from the Docker daemon. Any `--ulimit` options passed to
`docker run` will overwrite these defaults.

Be careful setting `nproc` with the `ulimit` flag as `nproc` is designed by Linux to
set the maximum number of processes available to a user, not to a container. For details
please check the [run](run.md) reference.

## Nodes discovery

The `--cluster-advertise` option specifies the `host:port` or `interface:port`
combination that this particular daemon instance should use when advertising
itself to the cluster. The daemon is reached by remote hosts through this value.
If you  specify an interface, make sure it includes the IP address of the actual
Docker host. For Engine installation created through `docker-machine`, the
interface is typically `eth1`.

The daemon uses [libkv](https://github.com/docker/libkv/) to advertise
the node within the cluster. Some key-value backends support mutual
TLS. To configure the client TLS settings used by the daemon can be configured
using the `--cluster-store-opt` flag, specifying the paths to PEM encoded
files. For example:

```bash
$ sudo dockerd \
    --cluster-advertise 192.168.1.2:2376 \
    --cluster-store etcd://192.168.1.2:2379 \
    --cluster-store-opt kv.cacertfile=/path/to/ca.pem \
    --cluster-store-opt kv.certfile=/path/to/cert.pem \
    --cluster-store-opt kv.keyfile=/path/to/key.pem
```

The currently supported cluster store options are:

*   `discovery.heartbeat`

    Specifies the heartbeat timer in seconds which is used by the daemon as a
    keepalive mechanism to make sure discovery module treats the node as alive
    in the cluster. If not configured, the default value is 20 seconds.

*   `discovery.ttl`

    Specifies the ttl (time-to-live) in seconds which is used by the discovery
    module to timeout a node if a valid heartbeat is not received within the
    configured ttl value. If not configured, the default value is 60 seconds.

*   `kv.cacertfile`

    Specifies the path to a local file with PEM encoded CA certificates to trust

*   `kv.certfile`

    Specifies the path to a local file with a PEM encoded certificate.  This
    certificate is used as the client cert for communication with the
    Key/Value store.

*   `kv.keyfile`

    Specifies the path to a local file with a PEM encoded private key.  This
    private key is used as the client key for communication with the
    Key/Value store.

*   `kv.path`

    Specifies the path in the Key/Value store. If not configured, the default value is 'docker/nodes'.

## Access authorization

Docker's access authorization can be extended by authorization plugins that your
organization can purchase or build themselves. You can install one or more
authorization plugins when you start the Docker `daemon` using the
`--authorization-plugin=PLUGIN_ID` option.

```bash
$ sudo dockerd --authorization-plugin=plugin1 --authorization-plugin=plugin2,...
```

The `PLUGIN_ID` value is either the plugin's name or a path to its specification
file. The plugin's implementation determines whether you can specify a name or
path. Consult with your Docker administrator to get information about the
plugins available to you.

Once a plugin is installed, requests made to the `daemon` through the command
line or Docker's remote API are allowed or denied by the plugin.  If you have
multiple plugins installed, at least one must allow the request for it to
complete.

For information about how to create an authorization plugin, see [authorization
plugin](../../extend/plugins_authorization.md) section in the Docker extend section of this documentation.


## Daemon user namespace options

The Linux kernel [user namespace support](http://man7.org/linux/man-pages/man7/user_namespaces.7.html) provides additional security by enabling
a process, and therefore a container, to have a unique range of user and
group IDs which are outside the traditional user and group range utilized by
the host system. Potentially the most important security improvement is that,
by default, container processes running as the `root` user will have expected
administrative privilege (with some restrictions) inside the container but will
effectively be mapped to an unprivileged `uid` on the host.

When user namespace support is enabled, Docker creates a single daemon-wide mapping
for all containers running on the same engine instance. The mappings will
utilize the existing subordinate user and group ID feature available on all modern
Linux distributions.
The [`/etc/subuid`](http://man7.org/linux/man-pages/man5/subuid.5.html) and
[`/etc/subgid`](http://man7.org/linux/man-pages/man5/subgid.5.html) files will be
read for the user, and optional group, specified to the `--userns-remap`
parameter.  If you do not wish to specify your own user and/or group, you can
provide `default` as the value to this flag, and a user will be created on your behalf
and provided subordinate uid and gid ranges. This default user will be named
`dockremap`, and entries will be created for it in `/etc/passwd` and
`/etc/group` using your distro's standard user and group creation tools.

> **Note**: The single mapping per-daemon restriction is in place for now
> because Docker shares image layers from its local cache across all
> containers running on the engine instance.  Since file ownership must be
> the same for all containers sharing the same layer content, the decision
> was made to map the file ownership on `docker pull` to the daemon's user and
> group mappings so that there is no delay for running containers once the
> content is downloaded. This design preserves the same performance for `docker
> pull`, `docker push`, and container startup as users expect with
> user namespaces disabled.

### Starting the daemon with user namespaces enabled

To enable user namespace support, start the daemon with the
`--userns-remap` flag, which accepts values in the following formats:

 - uid
 - uid:gid
 - username
 - username:groupname

If numeric IDs are provided, translation back to valid user or group names
will occur so that the subordinate uid and gid information can be read, given
these resources are name-based, not id-based.  If the numeric ID information
provided does not exist as entries in `/etc/passwd` or `/etc/group`, daemon
startup will fail with an error message.

> **Note:** On Fedora 22, you have to `touch` the `/etc/subuid` and `/etc/subgid`
> files to have ranges assigned when users are created.  This must be done
> *before* the `--userns-remap` option is enabled. Once these files exist, the
> daemon can be (re)started and range assignment on user creation works properly.

**Example: starting with default Docker user management:**

```bash
$ sudo dockerd --userns-remap=default
```

When `default` is provided, Docker will create - or find the existing - user and group
named `dockremap`. If the user is created, and the Linux distribution has
appropriate support, the `/etc/subuid` and `/etc/subgid` files will be populated
with a contiguous 65536 length range of subordinate user and group IDs, starting
at an offset based on prior entries in those files.  For example, Ubuntu will
create the following range, based on an existing user named `user1` already owning
the first 65536 range:

```bash
$ cat /etc/subuid
user1:100000:65536
dockremap:165536:65536
```

If you have a preferred/self-managed user with subordinate ID mappings already
configured, you can provide that username or uid to the `--userns-remap` flag.
If you have a group that doesn't match the username, you may provide the `gid`
or group name as well; otherwise the username will be used as the group name
when querying the system for the subordinate group ID range.

### Detailed information on `subuid`/`subgid` ranges

Given potential advanced use of the subordinate ID ranges by power users, the
following paragraphs define how the Docker daemon currently uses the range entries
found within the subordinate range files.

The simplest case is that only one contiguous range is defined for the
provided user or group. In this case, Docker will use that entire contiguous
range for the mapping of host uids and gids to the container process.  This
means that the first ID in the range will be the remapped root user, and the
IDs above that initial ID will map host ID 1 through the end of the range.

From the example `/etc/subuid` content shown above, the remapped root
user would be uid 165536.

If the system administrator has set up multiple ranges for a single user or
group, the Docker daemon will read all the available ranges and use the
following algorithm to create the mapping ranges:

1. The range segments found for the particular user will be sorted by *start ID* ascending.
2. Map segments will be created from each range in increasing value with a length matching the length of each segment. Therefore the range segment with the lowest numeric starting value will be equal to the remapped root, and continue up through host uid/gid equal to the range segment length. As an example, if the lowest segment starts at ID 1000 and has a length of 100, then a map of 1000 -> 0 (the remapped root) up through 1100 -> 100 will be created from this segment. If the next segment starts at ID 10000, then the next map will start with mapping 10000 -> 101 up to the length of this second segment. This will continue until no more segments are found in the subordinate files for this user.
3. If more than five range segments exist for a single user, only the first five will be utilized, matching the kernel's limitation of only five entries in `/proc/self/uid_map` and `proc/self/gid_map`.

### Disable user namespace for a container

If you enable user namespaces on the daemon, all containers are started
with user namespaces enabled. In some situations you might want to disable
this feature for a container, for example, to start a privileged container (see
[user namespace known restrictions](dockerd.md#user-namespace-known-restrictions)).
To enable those advanced features for a specific container use `--userns=host`
in the `run/exec/create` command.
This option will completely disable user namespace mapping for the container's user.

### User namespace known restrictions

The following standard Docker features are currently incompatible when
running a Docker daemon with user namespaces enabled:

 - sharing PID or NET namespaces with the host (`--pid=host` or `--network=host`)
 - A `--read-only` container filesystem (this is a Linux kernel restriction against remounting with modified flags of a currently mounted filesystem when inside a user namespace)
 - external (volume or graph) drivers which are unaware/incapable of using daemon user mappings
 - Using `--privileged` mode flag on `docker run` (unless also specifying `--userns=host`)

In general, user namespaces are an advanced feature and will require
coordination with other capabilities. For example, if volumes are mounted from
the host, file ownership will have to be pre-arranged if the user or
administrator wishes the containers to have expected access to the volume
contents.

Finally, while the `root` user inside a user namespaced container process has
many of the expected admin privileges that go along with being the superuser, the
Linux kernel has restrictions based on internal knowledge that this is a user namespaced
process. The most notable restriction that we are aware of at this time is the
inability to use `mknod`. Permission will be denied for device creation even as
container `root` inside a user namespace.

## Miscellaneous options

IP masquerading uses address translation to allow containers without a public
IP to talk to other machines on the Internet. This may interfere with some
network topologies and can be disabled with `--ip-masq=false`.

Docker supports softlinks for the Docker data directory (`/var/lib/docker`) and
for `/var/lib/docker/tmp`. The `DOCKER_TMPDIR` and the data directory can be
set like this:

    DOCKER_TMPDIR=/mnt/disk2/tmp /usr/local/bin/dockerd -D -g /var/lib/docker -H unix:// > /var/lib/docker-machine/docker.log 2>&1
    # or
    export DOCKER_TMPDIR=/mnt/disk2/tmp
    /usr/local/bin/dockerd -D -g /var/lib/docker -H unix:// > /var/lib/docker-machine/docker.log 2>&1

## Default cgroup parent

The `--cgroup-parent` option allows you to set the default cgroup parent
to use for containers. If this option is not set, it defaults to `/docker` for
fs cgroup driver and `system.slice` for systemd cgroup driver.

If the cgroup has a leading forward slash (`/`), the cgroup is created
under the root cgroup, otherwise the cgroup is created under the daemon
cgroup.

Assuming the daemon is running in cgroup `daemoncgroup`,
`--cgroup-parent=/foobar` creates a cgroup in
`/sys/fs/cgroup/memory/foobar`, whereas using `--cgroup-parent=foobar`
creates the cgroup in `/sys/fs/cgroup/memory/daemoncgroup/foobar`

The systemd cgroup driver has different rules for `--cgroup-parent`. Systemd
represents hierarchy by slice and the name of the slice encodes the location in
the tree. So `--cgroup-parent` for systemd cgroups should be a slice name. A
name can consist of a dash-separated series of names, which describes the path
to the slice from the root slice. For example, `--cgroup-parent=user-a-b.slice`
means the memory cgroup for the container is created in
`/sys/fs/cgroup/memory/user.slice/user-a.slice/user-a-b.slice/docker-<id>.scope`.

This setting can also be set per container, using the `--cgroup-parent`
option on `docker create` and `docker run`, and takes precedence over
the `--cgroup-parent` option on the daemon.

## Daemon configuration file

The `--config-file` option allows you to set any configuration option
for the daemon in a JSON format. This file uses the same flag names as keys,
except for flags that allow several entries, where it uses the plural
of the flag name, e.g., `labels` for the `label` flag.

The options set in the configuration file must not conflict with options set
via flags. The docker daemon fails to start if an option is duplicated between
the file and the flags, regardless their value. We do this to avoid
silently ignore changes introduced in configuration reloads.
For example, the daemon fails to start if you set daemon labels
in the configuration file and also set daemon labels via the `--label` flag.
Options that are not present in the file are ignored when the daemon starts.

### Linux configuration file

The default location of the configuration file on Linux is
`/etc/docker/daemon.json`. The `--config-file` flag can be used to specify a
 non-default location.

This is a full example of the allowed configuration options on Linux:

```json
{
    "api-cors-header": "",
    "authorization-plugins": [],
    "bip": "",
    "bridge": "",
    "cgroup-parent": "",
    "cluster-store": "",
    "cluster-store-opts": {},
    "cluster-advertise": "",
    "debug": true,
    "default-gateway": "",
    "default-gateway-v6": "",
    "default-runtime": "runc",
    "default-ulimits": {},
    "disable-legacy-registry": false,
    "dns": [],
    "dns-opts": [],
    "dns-search": [],
    "exec-opts": [],
    "exec-root": "",
    "fixed-cidr": "",
    "fixed-cidr-v6": "",
    "graph": "",
    "group": "",
    "hosts": [],
    "icc": false,
    "insecure-registries": [],
    "ip": "0.0.0.0",
    "iptables": false,
    "ipv6": false,
    "ip-forward": false,
    "ip-masq": false,
    "labels": [],
    "live-restore": true,
    "log-driver": "",
    "log-level": "",
    "log-opts": {},
    "max-concurrent-downloads": 3,
    "max-concurrent-uploads": 5,
    "mtu": 0,
    "oom-score-adjust": -500,
    "pidfile": "",
    "raw-logs": false,
    "registry-mirrors": [],
    "runtimes": {
        "runc": {
            "path": "runc"
        },
        "custom": {
            "path": "/usr/local/bin/my-runc-replacement",
            "runtimeArgs": [
                "--debug"
            ]
        }
    },
    "selinux-enabled": false,
    "storage-driver": "",
    "storage-opts": [],
    "swarm-default-advertise-addr": "",
    "tls": true,
    "tlscacert": "",
    "tlscert": "",
    "tlskey": "",
    "tlsverify": true,
    "userland-proxy": false,
    "userns-remap": ""
}
```

### Windows configuration file

The default location of the configuration file on Windows is
 `%programdata%\docker\config\daemon.json`. The `--config-file` flag can be
 used to specify a non-default location.

This is a full example of the allowed configuration options on Windows:

```json
{
    "authorization-plugins": [],
    "bridge": "",
    "cluster-advertise": "",
    "cluster-store": "",
    "debug": true,
    "default-ulimits": {},
    "disable-legacy-registry": false,
    "dns": [],
    "dns-opts": [],
    "dns-search": [],
    "exec-opts": [],
    "fixed-cidr": "",
    "graph": "",
    "group": "",
    "hosts": [],
    "insecure-registries": [],
    "labels": [],
    "live-restore": true,
    "log-driver": "",
    "log-level": "",
    "mtu": 0,
    "pidfile": "",
    "raw-logs": false,
    "registry-mirrors": [],
    "storage-driver": "",
    "storage-opts": [],
    "swarm-default-advertise-addr": "",
    "tlscacert": "",
    "tlscert": "",
    "tlskey": "",
    "tlsverify": true
}
```

### Configuration reloading

Some options can be reconfigured when the daemon is running without requiring
to restart the process. We use the `SIGHUP` signal in Linux to reload, and a global event
in Windows with the key `Global\docker-daemon-config-$PID`. The options can
be modified in the configuration file but still will check for conflicts with
the provided flags. The daemon fails to reconfigure itself
if there are conflicts, but it won't stop execution.

The list of currently supported options that can be reconfigured is this:

- `debug`: it changes the daemon to debug mode when set to true.
- `cluster-store`: it reloads the discovery store with the new address.
- `cluster-store-opts`: it uses the new options to reload the discovery store.
- `cluster-advertise`: it modifies the address advertised after reloading.
- `labels`: it replaces the daemon labels with a new set of labels.
- `live-restore`: Enables [keeping containers alive during daemon downtime](../../admin/live-restore.md).
- `max-concurrent-downloads`: it updates the max concurrent downloads for each pull.
- `max-concurrent-uploads`: it updates the max concurrent uploads for each push.
- `default-runtime`: it updates the runtime to be used if not is
  specified at container creation. It defaults to "default" which is
  the runtime shipped with the official docker packages.
- `runtimes`: it updates the list of available OCI runtimes that can
  be used to run containers

Updating and reloading the cluster configurations such as `--cluster-store`,
`--cluster-advertise` and `--cluster-store-opts` will take effect only if
these configurations were not previously configured. If `--cluster-store`
has been provided in flags and `cluster-advertise` not, `cluster-advertise`
can be added in the configuration file without accompanied by `--cluster-store`
Configuration reload will log a warning message if it detects a change in
previously configured cluster configurations.


## Running multiple daemons

> **Note:** Running multiple daemons on a single host is considered as "experimental". The user should be aware of
> unsolved problems. This solution may not work properly in some cases. Solutions are currently under development
> and will be delivered in the near future.

This section describes how to run multiple Docker daemons on a single host. To
run multiple daemons, you must configure each daemon so that it does not
conflict with other daemons on the same host. You can set these options either
by providing them as flags, or by using a [daemon configuration file](dockerd.md#daemon-configuration-file).

The following daemon options must be configured for each daemon:

```bash
-b, --bridge=                          Attach containers to a network bridge
--exec-root=/var/run/docker            Root of the Docker execdriver
-g, --graph=/var/lib/docker            Root of the Docker runtime
-p, --pidfile=/var/run/docker.pid      Path to use for daemon PID file
-H, --host=[]                          Daemon socket(s) to connect to
--iptables=true                        Enable addition of iptables rules
--config-file=/etc/docker/daemon.json  Daemon configuration file
--tlscacert="~/.docker/ca.pem"         Trust certs signed only by this CA
--tlscert="~/.docker/cert.pem"         Path to TLS certificate file
--tlskey="~/.docker/key.pem"           Path to TLS key file
```

When your daemons use different values for these flags, you can run them on the same host without any problems.
It is very important to properly understand the meaning of those options and to use them correctly.

- The `-b, --bridge=` flag is set to `docker0` as default bridge network. It is created automatically when you install Docker.
If you are not using the default, you must create and configure the bridge manually or just set it to 'none': `--bridge=none`
- `--exec-root` is the path where the container state is stored. The default value is `/var/run/docker`. Specify the path for
your running daemon here.
- `--graph` is the path where images are stored. The default value is `/var/lib/docker`. To avoid any conflict with other daemons
set this parameter separately for each daemon.
- `-p, --pidfile=/var/run/docker.pid` is the path where the process ID of the daemon is stored. Specify the path for your
pid file here.
- `--host=[]` specifies where the Docker daemon will listen for client connections. If unspecified, it defaults to `/var/run/docker.sock`.
-  `--iptables=false` prevents the Docker daemon from adding iptables rules. If
multiple daemons manage iptables rules, they may overwrite rules set by another
daemon. Be aware that disabling this option requires you to manually add
iptables rules to expose container ports. If you prevent Docker from adding
iptables rules, Docker will also not add IP masquerading rules, even if you set
`--ip-masq` to `true`. Without IP masquerading rules, Docker containers will not be
able to connect to external hosts or the internet when using network other than
default bridge.
- `--config-file=/etc/docker/daemon.json` is the path where configuration file is stored. You can use it instead of
daemon flags. Specify the path for each daemon.
- `--tls*` Docker daemon supports `--tlsverify` mode that enforces encrypted and authenticated remote connections.
The `--tls*` options enable use of specific certificates for individual daemons.

Example script for a separate ‚Äúbootstrap‚Äù instance of the Docker daemon without network:

```bash
$ sudo dockerd \
        -H unix:///var/run/docker-bootstrap.sock \
        -p /var/run/docker-bootstrap.pid \
        --iptables=false \
        --ip-masq=false \
        --bridge=none \
        --graph=/var/lib/docker-bootstrap \
        --exec-root=/var/run/docker-bootstrap
```
                                                                                                                                                                                                                                                                                                                                                                                                                                                              go/src/github.com/docker/docker/docs/reference/commandline/events.md                                0100644 0000000 0000000 00000021331 13101060260 024205  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/events/
description: The events command description and usage
keywords:
- events, container, report
title: docker events
---

```markdown
Usage:  docker events [OPTIONS]

Get real time events from the server

Options:
  -f, --filter value   Filter output based on conditions provided (default [])
      --help           Print usage
      --since string   Show all events created since timestamp
      --until string   Stream events until this timestamp
```

Docker containers report the following events:

    attach, commit, copy, create, destroy, detach, die, exec_create, exec_detach, exec_start, export, health_status, kill, oom, pause, rename, resize, restart, start, stop, top, unpause, update

Docker images report the following events:

    delete, import, load, pull, push, save, tag, untag

Docker plugins(experimental) report the following events:

    install, enable, disable, remove

Docker volumes report the following events:

    create, mount, unmount, destroy

Docker networks report the following events:

    create, connect, disconnect, destroy

Docker daemon report the following events:

    reload

The `--since` and `--until` parameters can be Unix timestamps, date formatted
timestamps, or Go duration strings (e.g. `10m`, `1h30m`) computed
relative to the client machine‚Äôs time. If you do not provide the `--since` option,
the command returns only new and/or live events.  Supported formats for date
formatted time stamps include RFC3339Nano, RFC3339, `2006-01-02T15:04:05`,
`2006-01-02T15:04:05.999999999`, `2006-01-02Z07:00`, and `2006-01-02`. The local
timezone on the client will be used if you do not provide either a `Z` or a
`+-00:00` timezone offset at the end of the timestamp.  When providing Unix
timestamps enter seconds[.nanoseconds], where seconds is the number of seconds
that have elapsed since January 1, 1970 (midnight UTC/GMT), not counting leap
seconds (aka Unix epoch or Unix time), and the optional .nanoseconds field is a
fraction of a second no more than nine digits long.

## Filtering

The filtering flag (`-f` or `--filter`) format is of "key=value". If you would
like to use multiple filters, pass multiple flags (e.g.,
`--filter "foo=bar" --filter "bif=baz"`)

Using the same filter multiple times will be handled as a *OR*; for example
`--filter container=588a23dac085 --filter container=a8f7720b8c22` will display
events for container 588a23dac085 *OR* container a8f7720b8c22

Using multiple filters will be handled as a *AND*; for example
`--filter container=588a23dac085 --filter event=start` will display events for
container container 588a23dac085 *AND* the event type is *start*

The currently supported filters are:

* container (`container=<name or id>`)
* event (`event=<event action>`)
* image (`image=<tag or id>`)
* plugin (experimental) (`plugin=<name or id>`)
* label (`label=<key>` or `label=<key>=<value>`)
* type (`type=<container or image or volume or network or daemon>`)
* volume (`volume=<name or id>`)
* network (`network=<name or id>`)
* daemon (`daemon=<name or id>`)

## Examples

You'll need two shells for this example.

**Shell 1: Listening for events:**

    $ docker events

**Shell 2: Start and Stop containers:**

    $ docker start 4386fb97867d
    $ docker stop 4386fb97867d
    $ docker stop 7805c1d35632

**Shell 1: (Again .. now showing events):**

    2015-05-12T11:51:30.999999999Z07:00 container start 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T11:51:30.999999999Z07:00 container die 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T15:52:12.999999999Z07:00 container stop 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T15:53:45.999999999Z07:00 container die 7805c1d35632 (image=redis:2.8)
    2015-05-12T15:54:03.999999999Z07:00 container stop 7805c1d35632 (image=redis:2.8)

**Show events in the past from a specified time:**

    $ docker events --since 1378216169
    2015-05-12T11:51:30.999999999Z07:00 container die 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T15:52:12.999999999Z07:00 container stop 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T15:53:45.999999999Z07:00 container die 7805c1d35632 (image=redis:2.8)
    2015-05-12T15:54:03.999999999Z07:00 container stop 7805c1d35632 (image=redis:2.8)

    $ docker events --since '2013-09-03'
    2015-05-12T11:51:30.999999999Z07:00 container start 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T11:51:30.999999999Z07:00 container die 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T15:52:12.999999999Z07:00 container stop 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T15:53:45.999999999Z07:00 container die 7805c1d35632 (image=redis:2.8)
    2015-05-12T15:54:03.999999999Z07:00 container stop 7805c1d35632 (image=redis:2.8)

    $ docker events --since '2013-09-03T15:49:29'
    2015-05-12T11:51:30.999999999Z07:00 container die 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T15:52:12.999999999Z07:00 container stop 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T15:53:45.999999999Z07:00 container die 7805c1d35632 (image=redis:2.8)
    2015-05-12T15:54:03.999999999Z07:00 container stop 7805c1d35632 (image=redis:2.8)

This example outputs all events that were generated in the last 3 minutes,
relative to the current time on the client machine:

    $ docker events --since '3m'
    2015-05-12T11:51:30.999999999Z07:00 container die 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T15:52:12.999999999Z07:00 container stop 4386fb97867d (image=ubuntu-1:14.04)
    2015-05-12T15:53:45.999999999Z07:00 container die 7805c1d35632 (image=redis:2.8)
    2015-05-12T15:54:03.999999999Z07:00 container stop 7805c1d35632 (image=redis:2.8)

**Filter events:**

    $ docker events --filter 'event=stop'
    2014-05-10T17:42:14.999999999Z07:00 container stop 4386fb97867d (image=ubuntu-1:14.04)
    2014-09-03T17:42:14.999999999Z07:00 container stop 7805c1d35632 (image=redis:2.8)

    $ docker events --filter 'image=ubuntu-1:14.04'
    2014-05-10T17:42:14.999999999Z07:00 container start 4386fb97867d (image=ubuntu-1:14.04)
    2014-05-10T17:42:14.999999999Z07:00 container die 4386fb97867d (image=ubuntu-1:14.04)
    2014-05-10T17:42:14.999999999Z07:00 container stop 4386fb97867d (image=ubuntu-1:14.04)

    $ docker events --filter 'container=7805c1d35632'
    2014-05-10T17:42:14.999999999Z07:00 container die 7805c1d35632 (image=redis:2.8)
    2014-09-03T15:49:29.999999999Z07:00 container stop 7805c1d35632 (image= redis:2.8)

    $ docker events --filter 'container=7805c1d35632' --filter 'container=4386fb97867d'
    2014-09-03T15:49:29.999999999Z07:00 container die 4386fb97867d (image=ubuntu-1:14.04)
    2014-05-10T17:42:14.999999999Z07:00 container stop 4386fb97867d (image=ubuntu-1:14.04)
    2014-05-10T17:42:14.999999999Z07:00 container die 7805c1d35632 (image=redis:2.8)
    2014-09-03T15:49:29.999999999Z07:00 container stop 7805c1d35632 (image=redis:2.8)

    $ docker events --filter 'container=7805c1d35632' --filter 'event=stop'
    2014-09-03T15:49:29.999999999Z07:00 container stop 7805c1d35632 (image=redis:2.8)

    $ docker events --filter 'container=container_1' --filter 'container=container_2'
    2014-09-03T15:49:29.999999999Z07:00 container die 4386fb97867d (image=ubuntu-1:14.04)
    2014-05-10T17:42:14.999999999Z07:00 container stop 4386fb97867d (image=ubuntu-1:14.04)
    2014-05-10T17:42:14.999999999Z07:00 container die 7805c1d35632 (imager=redis:2.8)
    2014-09-03T15:49:29.999999999Z07:00 container stop 7805c1d35632 (image=redis:2.8)

    $ docker events --filter 'type=volume'
    2015-12-23T21:05:28.136212689Z volume create test-event-volume-local (driver=local)
    2015-12-23T21:05:28.383462717Z volume mount test-event-volume-local (read/write=true, container=562fe10671e9273da25eed36cdce26159085ac7ee6707105fd534866340a5025, destination=/foo, driver=local, propagation=rprivate)
    2015-12-23T21:05:28.650314265Z volume unmount test-event-volume-local (container=562fe10671e9273da25eed36cdce26159085ac7ee6707105fd534866340a5025, driver=local)
    2015-12-23T21:05:28.716218405Z volume destroy test-event-volume-local (driver=local)

    $ docker events --filter 'type=network'
    2015-12-23T21:38:24.705709133Z network create 8b111217944ba0ba844a65b13efcd57dc494932ee2527577758f939315ba2c5b (name=test-event-network-local, type=bridge)
    2015-12-23T21:38:25.119625123Z network connect 8b111217944ba0ba844a65b13efcd57dc494932ee2527577758f939315ba2c5b (name=test-event-network-local, container=b4be644031a3d90b400f88ab3d4bdf4dc23adb250e696b6328b85441abe2c54e, type=bridge)

    $ docker events --filter 'type=plugin' (experimental)
    2016-07-25T17:30:14.825557616Z plugin pull ec7b87f2ce84330fe076e666f17dfc049d2d7ae0b8190763de94e1f2d105993f (name=tiborvass/no-remove:latest)
    2016-07-25T17:30:14.888127370Z plugin enable ec7b87f2ce84330fe076e666f17dfc049d2d7ae0b8190763de94e1f2d105993f (name=tiborvass/no-remove:latest)
                                                                                                                                                                                                                                                                                                       go/src/github.com/docker/docker/docs/reference/commandline/exec.md                                  0100644 0000000 0000000 00000003574 13101060260 023636  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/exec/
description: The exec command description and usage
keywords:
- command, container, run, execute
title: docker exec
---

```markdown
Usage:  docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

Run a command in a running container

  -d, --detach         Detached mode: run command in the background
  --detach-keys        Override the key sequence for detaching a container
  --help               Print usage
  -i, --interactive    Keep STDIN open even if not attached
  --privileged         Give extended privileges to the command
  -t, --tty            Allocate a pseudo-TTY
  -u, --user           Username or UID (format: <name|uid>[:<group|gid>])
```

The `docker exec` command runs a new command in a running container.

The command started using `docker exec` only runs while the container's primary
process (`PID 1`) is running, and it is not restarted if the container is
restarted.

If the container is paused, then the `docker exec` command will fail with an error:

    $ docker pause test
    test
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                   PORTS               NAMES
    1ae3b36715d2        ubuntu:latest       "bash"              17 seconds ago      Up 16 seconds (Paused)                       test
    $ docker exec test ls
    FATA[0000] Error response from daemon: Container test is paused, unpause the container before exec
    $ echo $?
    1

## Examples

    $ docker run --name ubuntu_bash --rm -i -t ubuntu bash

This will create a container named `ubuntu_bash` and start a Bash session.

    $ docker exec -d ubuntu_bash touch /tmp/execWorks

This will create a new file `/tmp/execWorks` inside the running container
`ubuntu_bash`, in the background.

    $ docker exec -it ubuntu_bash bash

This will create a new Bash session in the container `ubuntu_bash`.
                                                                                                                                    go/src/github.com/docker/docker/docs/reference/commandline/export.md                                0100644 0000000 0000000 00000001712 13101060260 024223  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/export/
description: The export command description and usage
keywords:
- export, file, system, container
title: docker export
---

```markdown
Usage:  docker export [OPTIONS] CONTAINER

Export a container's filesystem as a tar archive

Options:
      --help            Print usage
  -o, --output string   Write to a file, instead of STDOUT
```

The `docker export` command does not export the contents of volumes associated
with the container. If a volume is mounted on top of an existing directory in
the container, `docker export` will export the contents of the *underlying*
directory, not the contents of the volume.

Refer to [Backup, restore, or migrate data
volumes](../../tutorials/dockervolumes.md#backup-restore-or-migrate-data-volumes) in
the user guide for examples on exporting data in a volume.

## Examples

    $ docker export red_panda > latest.tar

Or

    $ docker export --output="latest.tar" red_panda
                                                      go/src/github.com/docker/docker/docs/reference/commandline/history.md                               0100644 0000000 0000000 00000003675 13101060260 024415  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/history/
description: The history command description and usage
keywords:
- docker, image, history
title: docker history
---

```markdown
Usage:  docker history [OPTIONS] IMAGE

Show the history of an image

Options:
      --help       Print usage
  -H, --human      Print sizes and dates in human readable format (default true)
      --no-trunc   Don't truncate output
  -q, --quiet      Only show numeric IDs
```

To see how the `docker:latest` image was built:

    $ docker history docker
    IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
    3e23a5875458        8 days ago          /bin/sh -c #(nop) ENV LC_ALL=C.UTF-8            0 B
    8578938dd170        8 days ago          /bin/sh -c dpkg-reconfigure locales &&    loc   1.245 MB
    be51b77efb42        8 days ago          /bin/sh -c apt-get update && apt-get install    338.3 MB
    4b137612be55        6 weeks ago         /bin/sh -c #(nop) ADD jessie.tar.xz in /        121 MB
    750d58736b4b        6 weeks ago         /bin/sh -c #(nop) MAINTAINER Tianon Gravi <ad   0 B
    511136ea3c5a        9 months ago                                                        0 B                 Imported from -

To see how the `docker:apache` image was added to a container's base image:

    $ docker history docker:scm
    IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
    2ac9d1098bf1        3 months ago        /bin/bash                                       241.4 MB            Added Apache to Fedora base image
    88b42ffd1f7c        5 months ago        /bin/sh -c #(nop) ADD file:1fd8d7f9f6557cafc7   373.7 MB
    c69cab00d6ef        5 months ago        /bin/sh -c #(nop) MAINTAINER Lokesh Mandvekar   0 B
    511136ea3c5a        19 months ago                                                       0 B                 Imported from -
                                                                   go/src/github.com/docker/docker/docs/reference/commandline/images.md                                0100644 0000000 0000000 00000032105 13101060260 024147  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/images/
description: The images command description and usage
keywords:
- list, docker, images
title: docker images
---

```markdown
Usage:  docker images [OPTIONS] [REPOSITORY[:TAG]]

List images

Options:
  -a, --all             Show all images (default hides intermediate images)
      --digests         Show digests
  -f, --filter value    Filter output based on conditions provided (default [])
                        - dangling=(true|false)
                        - label=<key> or label=<key>=<value>
                        - before=(<image-name>[:tag]|<image-id>|<image@digest>)
                        - since=(<image-name>[:tag]|<image-id>|<image@digest>)
      --format string   Pretty-print images using a Go template
      --help            Print usage
      --no-trunc        Don't truncate output
  -q, --quiet           Only show numeric IDs
```

The default `docker images` will show all top level
images, their repository and tags, and their size.

Docker images have intermediate layers that increase reusability,
decrease disk usage, and speed up `docker build` by
allowing each step to be cached. These intermediate layers are not shown
by default.

The `SIZE` is the cumulative space taken up by the image and all
its parent images. This is also the disk space used by the contents of the
Tar file created when you `docker save` an image.

An image will be listed more than once if it has multiple repository names
or tags. This single image (identifiable by its matching `IMAGE ID`)
uses up the `SIZE` listed only once.

### Listing the most recently created images

    $ docker images
    REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
    <none>                    <none>              77af4d6b9913        19 hours ago        1.089 GB
    committ                   latest              b6fa739cedf5        19 hours ago        1.089 GB
    <none>                    <none>              78a85c484f71        19 hours ago        1.089 GB
    docker                    latest              30557a29d5ab        20 hours ago        1.089 GB
    <none>                    <none>              5ed6274db6ce        24 hours ago        1.089 GB
    postgres                  9                   746b819f315e        4 days ago          213.4 MB
    postgres                  9.3                 746b819f315e        4 days ago          213.4 MB
    postgres                  9.3.5               746b819f315e        4 days ago          213.4 MB
    postgres                  latest              746b819f315e        4 days ago          213.4 MB

### Listing images by name and tag

The `docker images` command takes an optional `[REPOSITORY[:TAG]]` argument
that restricts the list to images that match the argument. If you specify
`REPOSITORY`but no `TAG`, the `docker images` command lists all images in the
given repository.

For example, to list all images in the "java" repository, run this command :

    $ docker images java
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    java                8                   308e519aac60        6 days ago          824.5 MB
    java                7                   493d82594c15        3 months ago        656.3 MB
    java                latest              2711b1d6f3aa        5 months ago        603.9 MB

The `[REPOSITORY[:TAG]]` value must be an "exact match". This means that, for example,
`docker images jav` does not match the image `java`.

If both `REPOSITORY` and `TAG` are provided, only images matching that
repository and tag are listed.  To find all local images in the "java"
repository with tag "8" you can use:

    $ docker images java:8
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    java                8                   308e519aac60        6 days ago          824.5 MB

If nothing matches `REPOSITORY[:TAG]`, the list is empty.

    $ docker images java:0
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE

## Listing the full length image IDs

    $ docker images --no-trunc
    REPOSITORY                    TAG                 IMAGE ID                                                                  CREATED             SIZE
    <none>                        <none>              sha256:77af4d6b9913e693e8d0b4b294fa62ade6054e6b2f1ffb617ac955dd63fb0182   19 hours ago        1.089 GB
    committest                    latest              sha256:b6fa739cedf5ea12a620a439402b6004d057da800f91c7524b5086a5e4749c9f   19 hours ago        1.089 GB
    <none>                        <none>              sha256:78a85c484f71509adeaace20e72e941f6bdd2b25b4c75da8693efd9f61a37921   19 hours ago        1.089 GB
    docker                        latest              sha256:30557a29d5abc51e5f1d5b472e79b7e296f595abcf19fe6b9199dbbc809c6ff4   20 hours ago        1.089 GB
    <none>                        <none>              sha256:0124422dd9f9cf7ef15c0617cda3931ee68346455441d66ab8bdc5b05e9fdce5   20 hours ago        1.089 GB
    <none>                        <none>              sha256:18ad6fad340262ac2a636efd98a6d1f0ea775ae3d45240d3418466495a19a81b   22 hours ago        1.082 GB
    <none>                        <none>              sha256:f9f1e26352f0a3ba6a0ff68167559f64f3e21ff7ada60366e2d44a04befd1d3a   23 hours ago        1.089 GB
    tryout                        latest              sha256:2629d1fa0b81b222fca63371ca16cbf6a0772d07759ff80e8d1369b926940074   23 hours ago        131.5 MB
    <none>                        <none>              sha256:5ed6274db6ceb2397844896966ea239290555e74ef307030ebb01ff91b1914df   24 hours ago        1.089 GB

## Listing image digests

Images that use the v2 or later format have a content-addressable identifier
called a `digest`. As long as the input used to generate the image is
unchanged, the digest value is predictable. To list image digest values, use
the `--digests` flag:

    $ docker images --digests
    REPOSITORY                         TAG                 DIGEST                                                                    IMAGE ID            CREATED             SIZE
    localhost:5000/test/busybox        <none>              sha256:cbbf2f9a99b47fc460d422812b6a5adff7dfee951d8fa2e4a98caa0382cfbdbf   4986bf8c1536        9 weeks ago         2.43 MB

When pushing or pulling to a 2.0 registry, the `push` or `pull` command
output includes the image digest. You can `pull` using a digest value. You can
also reference by digest in `create`, `run`, and `rmi` commands, as well as the
`FROM` image reference in a Dockerfile.

## Filtering

The filtering flag (`-f` or `--filter`) format is of "key=value". If there is more
than one filter, then pass multiple flags (e.g., `--filter "foo=bar" --filter "bif=baz"`)

The currently supported filters are:

* dangling (boolean - true or false)
* label (`label=<key>` or `label=<key>=<value>`)
* before (`<image-name>[:<tag>]`,  `<image id>` or `<image@digest>`) - filters images created before given id or references
* since (`<image-name>[:<tag>]`,  `<image id>` or `<image@digest>`) - filters images created since given id or references

##### Untagged images (dangling)

    $ docker images --filter "dangling=true"

    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    <none>              <none>              8abc22fbb042        4 weeks ago         0 B
    <none>              <none>              48e5f45168b9        4 weeks ago         2.489 MB
    <none>              <none>              bf747efa0e2f        4 weeks ago         0 B
    <none>              <none>              980fe10e5736        12 weeks ago        101.4 MB
    <none>              <none>              dea752e4e117        12 weeks ago        101.4 MB
    <none>              <none>              511136ea3c5a        8 months ago        0 B

This will display untagged images, that are the leaves of the images tree (not
intermediary layers). These images occur when a new build of an image takes the
`repo:tag` away from the image ID, leaving it as `<none>:<none>` or untagged.
A warning will be issued if trying to remove an image when a container is presently
using it. By having this flag it allows for batch cleanup.

Ready for use by `docker rmi ...`, like:

    $ docker rmi $(docker images -f "dangling=true" -q)

    8abc22fbb042
    48e5f45168b9
    bf747efa0e2f
    980fe10e5736
    dea752e4e117
    511136ea3c5a

NOTE: Docker will warn you if any containers exist that are using these untagged images.


##### Labeled images

The `label` filter matches images based on the presence of a `label` alone or a `label` and a
value.

The following filter matches images with the `com.example.version` label regardless of its value.

    $ docker images --filter "label=com.example.version"

    REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
    match-me-1          latest              eeae25ada2aa        About a minute ago   188.3 MB
    match-me-2          latest              dea752e4e117        About a minute ago   188.3 MB

The following filter matches images with the `com.example.version` label with the `1.0` value.

    $ docker images --filter "label=com.example.version=1.0"
    REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
    match-me            latest              511136ea3c5a        About a minute ago   188.3 MB

In this example, with the `0.1` value, it returns an empty set because no matches were found.

    $ docker images --filter "label=com.example.version=0.1"
    REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE

#### Before

The `before` filter shows only images created before the image with
given id or reference. For example, having these images:

    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
    image1              latest              eeae25ada2aa        4 minutes ago        188.3 MB
    image2              latest              dea752e4e117        9 minutes ago        188.3 MB
    image3              latest              511136ea3c5a        25 minutes ago       188.3 MB

Filtering with `before` would give:

    $ docker images --filter "before=image1"
    REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
    image2              latest              dea752e4e117        9 minutes ago        188.3 MB
    image3              latest              511136ea3c5a        25 minutes ago       188.3 MB

#### Since

The `since` filter shows only images created after the image with
given id or reference. For example, having these images:

    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
    image1              latest              eeae25ada2aa        4 minutes ago        188.3 MB
    image2              latest              dea752e4e117        9 minutes ago        188.3 MB
    image3              latest              511136ea3c5a        25 minutes ago       188.3 MB

Filtering with `since` would give:

    $ docker images --filter "since=image3"
    REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
    image1              latest              eeae25ada2aa        4 minutes ago        188.3 MB
    image2              latest              dea752e4e117        9 minutes ago        188.3 MB


## Formatting

The formatting option (`--format`) will pretty print container output
using a Go template.

Valid placeholders for the Go template are listed below:

Placeholder | Description
---- | ----
`.ID` | Image ID
`.Repository` | Image repository
`.Tag` | Image tag
`.Digest` | Image digest
`.CreatedSince` | Elapsed time since the image was created.
`.CreatedAt` | Time when the image was created.
`.Size` | Image disk size.

When using the `--format` option, the `image` command will either
output the data exactly as the template declares or, when using the
`table` directive, will include column headers as well.

The following example uses a template without headers and outputs the
`ID` and `Repository` entries separated by a colon for all images:

    {% raw %}
    $ docker images --format "{{.ID}}: {{.Repository}}"
    77af4d6b9913: <none>
    b6fa739cedf5: committ
    78a85c484f71: <none>
    30557a29d5ab: docker
    5ed6274db6ce: <none>
    746b819f315e: postgres
    746b819f315e: postgres
    746b819f315e: postgres
    746b819f315e: postgres
    {% endraw %}

To list all images with their repository and tag in a table format you
can use:

    {% raw %}
    $ docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}"
    IMAGE ID            REPOSITORY                TAG
    77af4d6b9913        <none>                    <none>
    b6fa739cedf5        committ                   latest
    78a85c484f71        <none>                    <none>
    30557a29d5ab        docker                    latest
    5ed6274db6ce        <none>                    <none>
    746b819f315e        postgres                  9
    746b819f315e        postgres                  9.3
    746b819f315e        postgres                  9.3.5
    746b819f315e        postgres                  latest
    {% endraw %}
                                                                                                                                                                                                                                                                                                                                                                                                                                                           go/src/github.com/docker/docker/docs/reference/commandline/import.md                                0100644 0000000 0000000 00000004240 13101060260 024213  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/import/
description: The import command description and usage
keywords:
- import, file, system, container
title: docker import
---

```markdown
Usage:  docker import [OPTIONS] file|URL|- [REPOSITORY[:TAG]]

Import the contents from a tarball to create a filesystem image

Options:
  -c, --change value     Apply Dockerfile instruction to the created image (default [])
      --help             Print usage
  -m, --message string   Set commit message for imported image
```

You can specify a `URL` or `-` (dash) to take data directly from `STDIN`. The
`URL` can point to an archive (.tar, .tar.gz, .tgz, .bzip, .tar.xz, or .txz)
containing a filesystem or to an individual file on the Docker host.  If you
specify an archive, Docker untars it in the container relative to the `/`
(root). If you specify an individual file, you must specify the full path within
the host. To import from a remote location, specify a `URI` that begins with the
`http://` or `https://` protocol.

The `--change` option will apply `Dockerfile` instructions to the image
that is created.
Supported `Dockerfile` instructions:
`CMD`|`ENTRYPOINT`|`ENV`|`EXPOSE`|`ONBUILD`|`USER`|`VOLUME`|`WORKDIR`

## Examples

**Import from a remote location:**

This will create a new untagged image.

    $ docker import http://example.com/exampleimage.tgz

**Import from a local file:**

Import to docker via pipe and `STDIN`.

    $ cat exampleimage.tgz | docker import - exampleimagelocal:new

Import with a commit message.

    $ cat exampleimage.tgz | docker import --message "New image imported from tarball" - exampleimagelocal:new

Import to docker from a local archive.

    $ docker import /path/to/exampleimage.tgz

**Import from a local directory:**

    $ sudo tar -c . | docker import - exampleimagedir

**Import from a local directory with new configurations:**

    $ sudo tar -c . | docker import --change "ENV DEBUG true" - exampleimagedir

Note the `sudo` in this example ‚Äì you must preserve
the ownership of the files (especially root ownership) during the
archiving with tar. If you are not root (or the sudo command) when you
tar, then the ownerships might not get preserved.
                                                                                                                                                                                                                                                                                                                                                                go/src/github.com/docker/docker/docs/reference/commandline/index.md                                 0100644 0000000 0000000 00000017745 13101060260 024026  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/
description: Docker's CLI command description and usage
keywords:
- Docker, Docker documentation, CLI,  command line
title: The Docker commands
---

This section contains reference information on using Docker's command line
client. Each command has a reference page along with samples. If you are
unfamiliar with the command line, you should start by reading about how to [Use
the Docker command line](cli.md).

You start the Docker daemon with the command line. How you start the daemon
affects your Docker containers. For that reason you should also make sure to
read the [`dockerd`](dockerd.md) reference page.

### Docker management commands

| Command | Description                                                        |
|:--------|:-------------------------------------------------------------------|
| [dockerd](dockerd.md) | Launch the Docker daemon                             |
| [info](info.md) | Display system-wide information                            |
| [inspect](inspect.md)| Return low-level information on a container or image  |
| [version](version.md) | Show the Docker version information                  |


### Image commands

| Command | Description                                                        |
|:--------|:-------------------------------------------------------------------|
| [build](build.md) |  Build an image from a Dockerfile                        |
| [commit](commit.md) | Create a new image from a container's changes          |
| [history](history.md) | Show the history of an image                         |
| [images](images.md) | List images                                            |
| [import](import.md) | Import the contents from a tarball to create a filesystem image |
| [load](load.md) | Load an image from a tar archive or STDIN                  |
| [rmi](rmi.md) | Remove one or more images                                    |
| [save](save.md) | Save images to a tar archive                               |
| [tag](tag.md) | Tag an image into a repository                               |

### Container commands

| Command | Description                                                        |
|:--------|:-------------------------------------------------------------------|
| [attach](attach.md) | Attach to a running container                          |
| [cp](cp.md) | Copy files/folders from a container to a HOSTDIR or to STDOUT  |
| [create](create.md) | Create a new container                                 |
| [diff](diff.md) | Inspect changes on a container's filesystem                |
| [events](events.md) | Get real time events from the server                   |
| [exec](exec.md) | Run a command in a running container                       |
| [export](export.md) | Export a container's filesystem as a tar archive       |
| [kill](kill.md) | Kill a running container                                   |
| [logs](logs.md) | Fetch the logs of a container                              |
| [pause](pause.md) | Pause all processes within a container                   |
| [port](port.md) | List port mappings or a specific mapping for the container |
| [ps](ps.md) | List containers                                                |
| [rename](rename.md) | Rename a container                                     |
| [restart](restart.md) | Restart a running container                          |
| [rm](rm.md) | Remove one or more containers                                  |
| [run](run.md) | Run a command in a new container                             |
| [start](start.md) | Start one or more stopped containers                     |
| [stats](stats.md) | Display a live stream of container(s) resource usage  statistics |
| [stop](stop.md) | Stop a running container                                   |
| [top](top.md) | Display the running processes of a container                 |
| [unpause](unpause.md) | Unpause all processes within a container             |
| [update](update.md) | Update configuration of one or more containers         |
| [wait](wait.md) | Block until a container stops, then print its exit code    |

### Hub and registry commands

| Command | Description                                                        |
|:--------|:-------------------------------------------------------------------|
| [login](login.md) | Register or log in to a Docker registry                  |
| [logout](logout.md) | Log out from a Docker registry                         |
| [pull](pull.md) | Pull an image or a repository from a Docker registry       |
| [push](push.md) | Push an image or a repository to a Docker registry         |
| [search](search.md) | Search the Docker Hub for images                       |

### Network and connectivity commands

| Command | Description                                                        |
|:--------|:-------------------------------------------------------------------|
| [network connect](network_connect.md) | Connect a container to a network     |
| [network create](network_create.md) | Create a new network                   |
| [network disconnect](network_disconnect.md) | Disconnect a container from a network |
| [network inspect](network_inspect.md) | Display information about a network  |
| [network ls](network_ls.md) | Lists all the networks the Engine `daemon` knows about |
| [network rm](network_rm.md) | Removes one or more networks                   |


### Shared data volume commands

| Command | Description                                                        |
|:--------|:-------------------------------------------------------------------|
| [volume create](volume_create.md) | Creates a new volume where containers can consume and store data |
| [volume inspect](volume_inspect.md) | Display information about a volume     |
| [volume ls](volume_ls.md) | Lists all the volumes Docker knows about         |
| [volume rm](volume_rm.md) | Remove one or more volumes                       |


### Swarm node commands

| Command | Description                                                        |
|:--------|:-------------------------------------------------------------------|
| [node promote](node_promote.md) | Promote a node that is pending a promotion to manager |
| [node demote](node_demote.md) | Demotes an existing manager so that it is no longer a manager |
| [node inspect](node_inspect.md) | Inspect a node in the swarm                |
| [node update](node_update.md) | Update attributes for a node                 |
| [node ps](node_ps.md) | List tasks running on a node                   |
| [node ls](node_ls.md) | List nodes in the swarm                              |
| [node rm](node_rm.md) | Remove one or more nodes from the swarm                         |

### Swarm swarm commands

| Command | Description                                                        |
|:--------|:-------------------------------------------------------------------|
| [swarm init](swarm_init.md) | Initialize a swarm                             |
| [swarm join](swarm_join.md) | Join a swarm as a manager node or worker node  |
| [swarm leave](swarm_leave.md) | Remove the current node from the swarm       |
| [swarm update](swarm_update.md) | Update attributes of a swarm               |
| [swarm join-token](swarm_join_token.md) | Display or rotate join tokens      |

### Swarm service commands

| Command | Description                                                        |
|:--------|:-------------------------------------------------------------------|
| [service create](service_create.md) | Create a new service                   |
| [service inspect](service_inspect.md) | Inspect a service                    |
| [service ls](service_ls.md) | List services in the swarm                     |
| [service rm](service_rm.md) | Remove a service from the swarm                |
| [service scale](service_scale.md) | Set the number of replicas for the desired state of the service |
| [service ps](service_ps.md) | List the tasks of a service              |
| [service update](service_update.md)  | Update the attributes of a service    |
                           go/src/github.com/docker/docker/docs/reference/commandline/info.md                                  0100644 0000000 0000000 00000010570 13101060260 023637  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/info/
description: The info command description and usage
keywords:
- display, docker, information
title: docker info
---

```markdown
Usage:  docker info

Display system-wide information

Options:
      --help   Print usage
```

This command displays system wide information regarding the Docker installation.
Information displayed includes the kernel version, number of containers and images.
The number of images shown is the number of unique images. The same image tagged
under different names is counted only once.

Depending on the storage driver in use, additional information can be shown, such
as pool name, data file, metadata file, data space used, total data space, metadata
space used, and total metadata space.

The data file is where the images are stored and the metadata file is where the
meta data regarding those images are stored. When run for the first time Docker
allocates a certain amount of data space and meta data space from the space
available on the volume where `/var/lib/docker` is mounted.

# Examples

## Display Docker system information

Here is a sample output for a daemon running on Ubuntu, using the overlay
storage driver and a node that is part of a 2-node swarm:

    $ docker -D info
    Containers: 14
     Running: 3
     Paused: 1
     Stopped: 10
    Images: 52
    Server Version: 1.12.0-dev
    Storage Driver: overlay
     Backing Filesystem: extfs
    Logging Driver: json-file
    Cgroup Driver: cgroupfs
    Plugins:
     Volume: local
     Network: bridge null host overlay
    Swarm:
     NodeID: 0gac67oclbxq7
     Is Manager: true
     Managers: 2
     Nodes: 2
    Runtimes: default
    Default Runtime: default
    Security Options: apparmor seccomp
    Kernel Version: 4.4.0-21-generic
    Operating System: Ubuntu 16.04 LTS
    OSType: linux
    Architecture: x86_64
    CPUs: 24
    Total Memory: 62.86 GiB
    Name: docker
    ID: I54V:OLXT:HVMM:TPKO:JPHQ:CQCD:JNLC:O3BZ:4ZVJ:43XJ:PFHZ:6N2S
    Docker Root Dir: /var/lib/docker
    Debug mode (client): true
    Debug mode (server): true
     File Descriptors: 59
     Goroutines: 159
     System Time: 2016-04-26T10:04:06.14689342-04:00
     EventsListeners: 0
    Http Proxy: http://test:test@localhost:8080
    Https Proxy: https://test:test@localhost:8080
    No Proxy: localhost,127.0.0.1,docker-registry.somecorporation.com
    Username: svendowideit
    Registry: https://index.docker.io/v1/
    WARNING: No swap limit support
    Labels:
     storage=ssd
     staging=true
    Insecure registries:
     myinsecurehost:5000
     127.0.0.0/8

The global `-D` option tells all `docker` commands to output debug information.

The example below shows the output for a daemon running on Red Hat Enterprise Linux,
using the devicemapper storage driver. As can be seen in the output, additional
information about the devicemapper storage driver is shown:

    $ docker info
    Containers: 14
     Running: 3
     Paused: 1
     Stopped: 10
    Untagged Images: 52
    Server Version: 1.10.3
    Storage Driver: devicemapper
     Pool Name: docker-202:2-25583803-pool
     Pool Blocksize: 65.54 kB
     Base Device Size: 10.74 GB
     Backing Filesystem: xfs
     Data file: /dev/loop0
     Metadata file: /dev/loop1
     Data Space Used: 1.68 GB
     Data Space Total: 107.4 GB
     Data Space Available: 7.548 GB
     Metadata Space Used: 2.322 MB
     Metadata Space Total: 2.147 GB
     Metadata Space Available: 2.145 GB
     Udev Sync Supported: true
     Deferred Removal Enabled: false
     Deferred Deletion Enabled: false
     Deferred Deleted Device Count: 0
     Data loop file: /var/lib/docker/devicemapper/devicemapper/data
     Metadata loop file: /var/lib/docker/devicemapper/devicemapper/metadata
     Library Version: 1.02.107-RHEL7 (2015-12-01)
    Execution Driver: native-0.2
    Logging Driver: json-file
    Plugins:
     Volume: local
     Network: null host bridge
    Kernel Version: 3.10.0-327.el7.x86_64
    Operating System: Red Hat Enterprise Linux Server 7.2 (Maipo)
    OSType: linux
    Architecture: x86_64
    CPUs: 1
    Total Memory: 991.7 MiB
    Name: ip-172-30-0-91.ec2.internal
    ID: I54V:OLXT:HVMM:TPKO:JPHQ:CQCD:JNLC:O3BZ:4ZVJ:43XJ:PFHZ:6N2S
    Docker Root Dir: /var/lib/docker
    Debug mode (client): false
    Debug mode (server): false
    Username: xyz
    Registry: https://index.docker.io/v1/
    Insecure registries:
     myinsecurehost:5000
     127.0.0.0/8
                                                                                                                                        go/src/github.com/docker/docker/docs/reference/commandline/inspect.md                               0100644 0000000 0000000 00000006010 13101060260 024343  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/inspect/
description: The inspect command description and usage
keywords:
- inspect, container, json
title: docker inspect
---

```markdown
Usage:  docker inspect [OPTIONS] CONTAINER|IMAGE|TASK [CONTAINER|IMAGE|TASK...]

Return low-level information on a container, image or task

  -f, --format       Format the output using the given go template
  --help             Print usage
  -s, --size         Display total file sizes if the type is container
                     values are "image" or "container" or "task"
  --type             Return JSON for specified type, (e.g image, container or task)
```

By default, this will render all results in a JSON array. If the container and
image have the same name, this will return container JSON for unspecified type.
If a format is specified, the given template will be executed for each result.

Go's [text/template](http://golang.org/pkg/text/template/) package
describes all the details of the format.

## Examples

**Get an instance's IP address:**

For the most part, you can pick out any field from the JSON in a fairly
straightforward manner.

    {% raw %}
    $ docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $INSTANCE_ID
    {% endraw %}

**Get an instance's MAC address:**

For the most part, you can pick out any field from the JSON in a fairly
straightforward manner.

    {% raw %}
    $ docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' $INSTANCE_ID
    {% endraw %}

**Get an instance's log path:**

    {% raw %}
    $ docker inspect --format='{{.LogPath}}' $INSTANCE_ID
    {% endraw %}

**Get a Task's image name:**

    {% raw %}
    $ docker inspect --format='{{.Container.Spec.Image}}' $INSTANCE_ID
    {% endraw %}

**List all port bindings:**

One can loop over arrays and maps in the results to produce simple text
output:

    {% raw %}
    $ docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' $INSTANCE_ID
    {% endraw %}

**Find a specific port mapping:**

The `.Field` syntax doesn't work when the field name begins with a
number, but the template language's `index` function does. The
`.NetworkSettings.Ports` section contains a map of the internal port
mappings to a list of external address/port objects. To grab just the
numeric public port, you use `index` to find the specific port map, and
then `index` 0 contains the first object inside of that. Then we ask for
the `HostPort` field to get the public address.

    {% raw %}
    $ docker inspect --format='{{(index (index .NetworkSettings.Ports "8787/tcp") 0).HostPort}}' $INSTANCE_ID
    {% endraw %}

**Get a subsection in JSON format:**

If you request a field which is itself a structure containing other
fields, by default you get a Go-style dump of the inner values.
Docker adds a template function, `json`, which can be applied to get
results in JSON format.

    {% raw %}
    $ docker inspect --format='{{json .Config}}' $INSTANCE_ID
    {% endraw %}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        go/src/github.com/docker/docker/docs/reference/commandline/kill.md                                  0100644 0000000 0000000 00000001327 13101060260 023637  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/kill/
description: The kill command description and usage
keywords:
- container, kill, signal
title: docker kill
---

```markdown
Usage:  docker kill [OPTIONS] CONTAINER [CONTAINER...]

Kill one or more running containers

Options:
      --help            Print usage
  -s, --signal string   Signal to send to the container (default "KILL")
```

The main process inside the container will be sent `SIGKILL`, or any
signal specified with option `--signal`.

> **Note:**
> `ENTRYPOINT` and `CMD` in the *shell* form run as a subcommand of `/bin/sh -c`,
> which does not pass signals. This means that the executable is not the container‚Äôs PID 1
> and does not receive Unix signals.
                                                                                                                                                                                                                                                                                                         go/src/github.com/docker/docker/docs/reference/commandline/load.md                                  0100644 0000000 0000000 00000003301 13101060260 023615  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/load/
description: The load command description and usage
keywords:
- stdin, tarred, repository
title: docker load
---

```markdown
Usage:  docker load [OPTIONS]

Load an image from a tar archive or STDIN

Options:
      --help           Print usage
  -i, --input string   Read from tar archive file, instead of STDIN.
                       The tarball may be compressed with gzip, bzip, or xz
  -q, --quiet          Suppress the load output but still outputs the imported images
```

Loads a tarred repository from a file or the standard input stream.
Restores both images and tags.

    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    $ docker load < busybox.tar.gz
    # [‚Ä¶]
    Loaded image: busybox:latest
    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    busybox             latest              769b9341d937        7 weeks ago         2.489 MB
    $ docker load --input fedora.tar
    # [‚Ä¶]
    Loaded image: fedora:rawhide
    # [‚Ä¶]
    Loaded image: fedora:20
    # [‚Ä¶]
    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    busybox             latest              769b9341d937        7 weeks ago         2.489 MB
    fedora              rawhide             0d20aec6529d        7 weeks ago         387 MB
    fedora              20                  58394af37342        7 weeks ago         385.5 MB
    fedora              heisenbug           58394af37342        7 weeks ago         385.5 MB
    fedora              latest              58394af37342        7 weeks ago         385.5 MB
                                                                                                                                                                                                                                                                                                                               go/src/github.com/docker/docker/docs/reference/commandline/login.md                                 0100644 0000000 0000000 00000007465 13101060260 024025  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/login/
description: The login command description and usage
keywords:
- registry, login, image
title: docker login
---

```markdown
Usage:  docker login [OPTIONS] [SERVER]

Log in to a Docker registry.
If no server is specified, the default is defined by the daemon.

Options:
      --help              Print usage
  -p, --password string   Password
  -u, --username string   Username
```

If you want to login to a self-hosted registry you can specify this by
adding the server name.

    example:
    $ docker login localhost:8080


`docker login` requires user to use `sudo` or be `root`, except when:

1.  connecting to a remote daemon, such as a `docker-machine` provisioned `docker engine`.
2.  user is added to the `docker` group.  This will impact the security of your system; the `docker` group is `root` equivalent.  See [Docker Daemon Attack Surface](/security/security/#docker-daemon-attack-surface) for details.

You can log into any public or private repository for which you have
credentials.  When you log in, the command stores encoded credentials in
`$HOME/.docker/config.json` on Linux or `%USERPROFILE%/.docker/config.json` on Windows.

## Credentials store

The Docker Engine can keep user credentials in an external credentials store,
such as the native keychain of the operating system. Using an external store
is more secure than storing credentials in the Docker configuration file.

To use a credentials store, you need an external helper program to interact
with a specific keychain or external store. Docker requires the helper
program to be in the client's host `$PATH`.

This is the list of currently available credentials helpers and where
you can download them from:

- D-Bus Secret Service: https://github.com/docker/docker-credential-helpers/releases
- Apple macOS keychain: https://github.com/docker/docker-credential-helpers/releases
- Microsoft Windows Credential Manager: https://github.com/docker/docker-credential-helpers/releases

### Usage

You need to specify the credentials store in `$HOME/.docker/config.json`
to tell the docker engine to use it:

```json
{
	"credsStore": "osxkeychain"
}
```

If you are currently logged in, run `docker logout` to remove
the credentials from the file and run `docker login` again.

### Protocol

Credential helpers can be any program or script that follows a very simple protocol.
This protocol is heavily inspired by Git, but it differs in the information shared.

The helpers always use the first argument in the command to identify the action.
There are only three possible values for that argument: `store`, `get`, and `erase`.

The `store` command takes a JSON payload from the standard input. That payload carries
the server address, to identify the credential, the user name, and either a password
or an identity token.

```json
{
	"ServerURL": "https://index.docker.io/v1",
	"Username": "david",
	"Secret": "passw0rd1"
}
```

If the secret being stored is an identity token, the Username should be set to
`<token>`.

The `store` command can write error messages to `STDOUT` that the docker engine
will show if there was an issue.

The `get` command takes a string payload from the standard input. That payload carries
the server address that the docker engine needs credentials for. This is
an example of that payload: `https://index.docker.io/v1`.

The `get` command writes a JSON payload to `STDOUT`. Docker reads the user name
and password from this payload:

```json
{
	"Username": "david",
	"Secret": "passw0rd1"
}
```

The `erase` command takes a string payload from `STDIN`. That payload carries
the server address that the docker engine wants to remove credentials for. This is
an example of that payload: `https://index.docker.io/v1`.

The `erase` command can write error messages to `STDOUT` that the docker engine
will show if there was an issue.
                                                                                                                                                                                                           go/src/github.com/docker/docker/docs/reference/commandline/logout.md                                0100644 0000000 0000000 00000000623 13101060260 024213  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/logout/
description: The logout command description and usage
keywords:
- logout, docker, registry
title: docker logout
---

```markdown
Usage:  docker logout [SERVER]

Log out from a Docker registry.
If no server is specified, the default is defined by the daemon.

Options:
      --help   Print usage
```

For example:

    $ docker logout localhost:8080
                                                                                                             go/src/github.com/docker/docker/docs/reference/commandline/logs.md                                  0100644 0000000 0000000 00000004752 13101060260 023655  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/logs/
description: The logs command description and usage
keywords:
- logs, retrieve, docker
title: docker logs
---

```markdown
Usage:  docker logs [OPTIONS] CONTAINER

Fetch the logs of a container

Options:
      --details        Show extra details provided to logs
  -f, --follow         Follow log output
      --help           Print usage
      --since string   Show logs since timestamp
      --tail string    Number of lines to show from the end of the logs (default "all")
  -t, --timestamps     Show timestamps
```

The `docker logs` command batch-retrieves logs present at the time of execution.

> **Note**: this command is only functional for containers that are started with
> the `json-file` or `journald` logging driver.

For more information about selecting and configuring logging drivers, refer to
[Configure logging drivers](https://docs.docker.com/engine/admin/logging/overview/).

The `docker logs --follow` command will continue streaming the new output from
the container's `STDOUT` and `STDERR`.

Passing a negative number or a non-integer to `--tail` is invalid and the
value is set to `all` in that case.

The `docker logs --timestamps` command will add an [RFC3339Nano timestamp](https://golang.org/pkg/time/#pkg-constants)
, for example `2014-09-16T06:17:46.000000000Z`, to each
log entry. To ensure that the timestamps are aligned the
nano-second part of the timestamp will be padded with zero when necessary.

The `docker logs --details` command will add on extra attributes, such as
environment variables and labels, provided to `--log-opt` when creating the
container.

The `--since` option shows only the container logs generated after
a given date. You can specify the date as an RFC 3339 date, a UNIX
timestamp, or a Go duration string (e.g. `1m30s`, `3h`). Besides RFC3339 date
format you may also use RFC3339Nano, `2006-01-02T15:04:05`,
`2006-01-02T15:04:05.999999999`, `2006-01-02Z07:00`, and `2006-01-02`. The local
timezone on the client will be used if you do not provide either a `Z` or a
`+-00:00` timezone offset at the end of the timestamp. When providing Unix
timestamps enter seconds[.nanoseconds], where seconds is the number of seconds
that have elapsed since January 1, 1970 (midnight UTC/GMT), not counting leap
seconds (aka Unix epoch or Unix time), and the optional .nanoseconds field is a
fraction of a second no more than nine digits long. You can combine the
`--since` option with either or both of the `--follow` or `--tail` options.
                      go/src/github.com/docker/docker/docs/reference/commandline/network_connect.md                       0100644 0000000 0000000 00000006564 13101060260 026116  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/network_connect/
description: The network connect command description and usage
keywords:
- network, connect, user-defined
title: docker network connect
---

```markdown
Usage:  docker network connect [OPTIONS] NETWORK CONTAINER

Connect a container to a network

Options:
      --alias value           Add network-scoped alias for the container (default [])
      --help                  Print usage
      --ip string             IP Address
      --ip6 string            IPv6 Address
      --link value            Add link to another container (default [])
      --link-local-ip value   Add a link-local address for the container (default [])
```

Connects a container to a network. You can connect a container by name
or by ID. Once connected, the container can communicate with other containers in
the same network.

```bash
$ docker network connect multi-host-network container1
```

You can also use the `docker run --network=<network-name>` option to start a container and immediately connect it to a network.

```bash
$ docker run -itd --network=multi-host-network busybox
```

You can specify the IP address you want to be assigned to the container's interface.

```bash
$ docker network connect --ip 10.10.36.122 multi-host-network container2
```

You can use `--link` option to link another container with a preferred alias

```bash
$ docker network connect --link container1:c1 multi-host-network container2
```

`--alias` option can be used to resolve the container by another name in the network
being connected to.

```bash
$ docker network connect --alias db --alias mysql multi-host-network container2
```
You can pause, restart, and stop containers that are connected to a network.
A container connects to its configured networks when it runs.

If specified, the container's IP address(es) is reapplied when a stopped
container is restarted. If the IP address is no longer available, the container
fails to start. One way to guarantee that the IP address is available is
to specify an `--ip-range` when creating the network, and choose the static IP
address(es) from outside that range. This ensures that the IP address is not
given to another container while this container is not on the network.

```bash
$ docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 multi-host-network
```

```bash
$ docker network connect --ip 172.20.128.2 multi-host-network container2
```

To verify the container is connected, use the `docker network inspect` command. Use `docker network disconnect` to remove a container from the network.

Once connected in network, containers can communicate using only another
container's IP address or name. For `overlay` networks or custom plugins that
support multi-host connectivity, containers connected to the same multi-host
network but launched from different Engines can also communicate in this way.

You can connect a container to one or more networks. The networks need not be the same type. For example, you can connect a single container bridge and overlay networks.

## Related information

* [network inspect](network_inspect.md)
* [network create](network_create.md)
* [network disconnect](network_disconnect.md)
* [network ls](network_ls.md)
* [network rm](network_rm.md)
* [Understand Docker container networks](../../userguide/networking/index.md)
* [Work with networks](../../userguide/networking/work-with-networks.md)
                                                                                                                                            go/src/github.com/docker/docker/docs/reference/commandline/network_create.md                        0100644 0000000 0000000 00000020137 13101060260 025720  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/network_create/
description: The network create command description and usage
keywords:
- network, create
title: docker network create
---

```markdown
Usage:	docker network create [OPTIONS] NETWORK

Create a network

Options:
      --aux-address value    Auxiliary IPv4 or IPv6 addresses used by Network
                             driver (default map[])
  -d, --driver string        Driver to manage the Network (default "bridge")
      --gateway value        IPv4 or IPv6 Gateway for the master subnet (default [])
      --help                 Print usage
      --internal             Restrict external access to the network
      --ip-range value       Allocate container ip from a sub-range (default [])
      --ipam-driver string   IP Address Management Driver (default "default")
      --ipam-opt value       Set IPAM driver specific options (default map[])
      --ipv6                 Enable IPv6 networking
      --label value          Set metadata on a network (default [])
  -o, --opt value            Set driver specific options (default map[])
      --subnet value         Subnet in CIDR format that represents a
                             network segment (default [])
```

Creates a new network. The `DRIVER` accepts `bridge` or `overlay` which are the
built-in network drivers. If you have installed a third party or your own custom
network driver you can specify that `DRIVER` here also. If you don't specify the
`--driver` option, the command automatically creates a `bridge` network for you.
When you install Docker Engine it creates a `bridge` network automatically. This
network corresponds to the `docker0` bridge that Engine has traditionally relied
on. When you launch a new container with  `docker run` it automatically connects to
this bridge network. You cannot remove this default bridge network, but you can
create new ones using the `network create` command.

```bash
$ docker network create -d bridge my-bridge-network
```

Bridge networks are isolated networks on a single Engine installation. If you
want to create a network that spans multiple Docker hosts each running an
Engine, you must create an `overlay` network. Unlike `bridge` networks, overlay
networks require some pre-existing conditions before you can create one. These
conditions are:

* Access to a key-value store. Engine supports Consul, Etcd, and ZooKeeper (Distributed store) key-value stores.
* A cluster of hosts with connectivity to the key-value store.
* A properly configured Engine `daemon` on each host in the cluster.

The `dockerd` options that support the `overlay` network are:

* `--cluster-store`
* `--cluster-store-opt`
* `--cluster-advertise`

To read more about these options and how to configure them, see ["*Get started
with multi-host network*"](../../userguide/networking/get-started-overlay.md).

While not required, it is a good idea to install Docker Swarm to
manage the cluster that makes up your network. Swarm provides sophisticated
discovery and server management tools that can assist your implementation.

Once you have prepared the `overlay` network prerequisites you simply choose a
Docker host in the cluster and issue the following to create the network:

```bash
$ docker network create -d overlay my-multihost-network
```

Network names must be unique. The Docker daemon attempts to identify naming
conflicts but this is not guaranteed. It is the user's responsibility to avoid
name conflicts.

## Connect containers

When you start a container, use the `--network` flag to connect it to a network.
This example adds the `busybox` container to the `mynet` network:

```bash
$ docker run -itd --network=mynet busybox
```

If you want to add a container to a network after the container is already
running, use the `docker network connect` subcommand.

You can connect multiple containers to the same network. Once connected, the
containers can communicate using only another container's IP address or name.
For `overlay` networks or custom plugins that support multi-host connectivity,
containers connected to the same multi-host network but launched from different
Engines can also communicate in this way.

You can disconnect a container from a network using the `docker network
disconnect` command.

## Specifying advanced options

When you create a network, Engine creates a non-overlapping subnetwork for the
network by default. This subnetwork is not a subdivision of an existing
network. It is purely for ip-addressing purposes. You can override this default
and specify subnetwork values directly using the `--subnet` option. On a
`bridge` network you can only create a single subnet:

```bash
$ docker network create --driver=bridge --subnet=192.168.0.0/16 br0
```

Additionally, you also specify the `--gateway` `--ip-range` and `--aux-address`
options.

```bash
$ docker network create \
  --driver=bridge \
  --subnet=172.28.0.0/16 \
  --ip-range=172.28.5.0/24 \
  --gateway=172.28.5.254 \
  br0
```

If you omit the `--gateway` flag the Engine selects one for you from inside a
preferred pool. For `overlay` networks and for network driver plugins that
support it you can create multiple subnetworks.

```bash
$ docker network create -d overlay \
  --subnet=192.168.0.0/16 \
  --subnet=192.170.0.0/16 \
  --gateway=192.168.0.100 \
  --gateway=192.170.0.100 \
  --ip-range=192.168.1.0/24 \
  --aux-address="my-router=192.168.1.5" --aux-address="my-switch=192.168.1.6" \
  --aux-address="my-printer=192.170.1.5" --aux-address="my-nas=192.170.1.6" \
  my-multihost-network
```

Be sure that your subnetworks do not overlap. If they do, the network create
fails and Engine returns an error.

# Bridge driver options

When creating a custom network, the default network driver (i.e. `bridge`) has
additional options that can be passed. The following are those options and the
equivalent docker daemon flags used for docker0 bridge:

| Option                                           | Equivalent  | Description                                           |
|--------------------------------------------------|-------------|-------------------------------------------------------|
| `com.docker.network.bridge.name`                 | -           | bridge name to be used when creating the Linux bridge |
| `com.docker.network.bridge.enable_ip_masquerade` | `--ip-masq` | Enable IP masquerading                                |
| `com.docker.network.bridge.enable_icc`           | `--icc`     | Enable or Disable Inter Container Connectivity        |
| `com.docker.network.bridge.host_binding_ipv4`    | `--ip`      | Default IP when binding container ports               |
| `com.docker.network.driver.mtu`                  | `--mtu`     | Set the containers network MTU                        |

The following arguments can be passed to `docker network create` for any
network driver, again with their approximate equivalents to `docker daemon`.

| Argument     | Equivalent     | Description                                |
|--------------|----------------|--------------------------------------------|
| `--gateway`  | -              | IPv4 or IPv6 Gateway for the master subnet |
| `--ip-range` | `--fixed-cidr` | Allocate IPs from a range                  |
| `--internal` | -              | Restrict external access to the network   |
| `--ipv6`     | `--ipv6`       | Enable IPv6 networking                     |
| `--subnet`   | `--bip`        | Subnet for network                         |

For example, let's use `-o` or `--opt` options to specify an IP address binding
when publishing ports:

```bash
$ docker network create \
    -o "com.docker.network.bridge.host_binding_ipv4"="172.19.0.1" \
    simple-network
```

### Network internal mode

By default, when you connect a container to an `overlay` network, Docker also
connects a bridge network to it to provide external connectivity. If you want
to create an externally isolated `overlay` network, you can specify the
`--internal` option.

## Related information

* [network inspect](network_inspect.md)
* [network connect](network_connect.md)
* [network disconnect](network_disconnect.md)
* [network ls](network_ls.md)
* [network rm](network_rm.md)
* [Understand Docker container networks](../../userguide/networking/index.md)
                                                                                                                                                                                                                                                                                                                                                                                                                                 go/src/github.com/docker/docker/docs/reference/commandline/network_disconnect.md                    0100644 0000000 0000000 00000001601 13101060260 026601  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/network_disconnect/
description: The network disconnect command description and usage
keywords:
- network, disconnect, user-defined
title: docker network disconnect
---

```markdown
Usage:  docker network disconnect [OPTIONS] NETWORK CONTAINER

Disconnect a container from a network

Options:
  -f, --force   Force the container to disconnect from a network
      --help    Print usage
```

Disconnects a container from a network. The container must be running to disconnect it from the network.

```bash
  $ docker network disconnect multi-host-network container1
```


## Related information

* [network inspect](network_inspect.md)
* [network connect](network_connect.md)
* [network create](network_create.md)
* [network ls](network_ls.md)
* [network rm](network_rm.md)
* [Understand Docker container networks](../../userguide/networking/index.md)
                                                                                                                               go/src/github.com/docker/docker/docs/reference/commandline/network_inspect.md                       0100644 0000000 0000000 00000007754 13101060260 026134  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/network_inspect/
description: The network inspect command description and usage
keywords:
- network, inspect, user-defined
title: docker network inspect
---

```markdown
Usage:  docker network inspect [OPTIONS] NETWORK [NETWORK...]

Display detailed information on one or more networks

Options:
  -f, --format string   Format the output using the given go template
      --help            Print usage
```

Returns information about one or more networks. By default, this command renders all results in a JSON object. For example, if you connect two containers to the default `bridge` network:

```bash
$ sudo docker run -itd --name=container1 busybox
f2870c98fd504370fb86e59f32cd0753b1ac9b69b7d80566ffc7192a82b3ed27

$ sudo docker run -itd --name=container2 busybox
bda12f8922785d1f160be70736f26c1e331ab8aaf8ed8d56728508f2e2fd4727
```

The `network inspect` command shows the containers, by id, in its
results. For networks backed by multi-host network driver, such as Overlay,
this command also shows the container endpoints in other hosts in the
cluster. These endpoints are represented as "ep-{endpoint-id}" in the output.
However, for swarm-scoped networks, only the endpoints that are local to the
node are shown.

You can specify an alternate format to execute a given
template for each result. Go's
[text/template](http://golang.org/pkg/text/template/) package describes all the
details of the format.

```bash
$ sudo docker network inspect bridge
[
    {
        "Name": "bridge",
        "Id": "b2b1a2cba717161d984383fd68218cf70bbbd17d328496885f7c921333228b0f",
        "Scope": "local",
        "Driver": "bridge",
        "IPAM": {
            "Driver": "default",
            "Config": [
                {
                    "Subnet": "172.17.42.1/16",
                    "Gateway": "172.17.42.1"
                }
            ]
        },
        "Internal": false,
        "Containers": {
            "bda12f8922785d1f160be70736f26c1e331ab8aaf8ed8d56728508f2e2fd4727": {
                "Name": "container2",
                "EndpointID": "0aebb8fcd2b282abe1365979536f21ee4ceaf3ed56177c628eae9f706e00e019",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            },
            "f2870c98fd504370fb86e59f32cd0753b1ac9b69b7d80566ffc7192a82b3ed27": {
                "Name": "container1",
                "EndpointID": "a00676d9c91a96bbe5bcfb34f705387a33d7cc365bac1a29e4e9728df92d10ad",
                "MacAddress": "02:42:ac:11:00:01",
                "IPv4Address": "172.17.0.1/16",
                "IPv6Address": ""
            }
        },
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        }
    }
]
```

Returns the information about the user-defined network:

```bash
$ docker network create simple-network
69568e6336d8c96bbf57869030919f7c69524f71183b44d80948bd3927c87f6a
$ docker network inspect simple-network
[
    {
        "Name": "simple-network",
        "Id": "69568e6336d8c96bbf57869030919f7c69524f71183b44d80948bd3927c87f6a",
        "Scope": "local",
        "Driver": "bridge",
        "IPAM": {
            "Driver": "default",
            "Config": [
                {
                    "Subnet": "172.22.0.0/16",
                    "Gateway": "172.22.0.1/16"
                }
            ]
        },
        "Containers": {},
        "Options": {}
    }
]
```

## Related information

* [network disconnect ](network_disconnect.md)
* [network connect](network_connect.md)
* [network create](network_create.md)
* [network ls](network_ls.md)
* [network rm](network_rm.md)
* [Understand Docker container networks](../../userguide/networking/index.md)
                    go/src/github.com/docker/docker/docs/reference/commandline/network_ls.md                            0100644 0000000 0000000 00000012332 13101060260 025071  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/network_ls/
description: The network ls command description and usage
keywords:
- network, list, user-defined
title: docker network ls
---

```markdown
Usage:  docker network ls [OPTIONS]

List networks

Aliases:
  ls, list

Options:
  -f, --filter value   Provide filter values (i.e. 'dangling=true') (default [])
      --help           Print usage
      --no-trunc       Do not truncate the output
  -q, --quiet          Only display network IDs
```

Lists all the networks the Engine `daemon` knows about. This includes the
networks that span across multiple hosts in a cluster, for example:

```bash
    $ sudo docker network ls
    NETWORK ID          NAME                DRIVER
    7fca4eb8c647        bridge              bridge
    9f904ee27bf5        none                null
    cf03ee007fb4        host                host
    78b03ee04fc4        multi-host          overlay
```

Use the `--no-trunc` option to display the full network id:

```bash
docker network ls --no-trunc
NETWORK ID                                                         NAME                DRIVER
18a2866682b85619a026c81b98a5e375bd33e1b0936a26cc497c283d27bae9b3   none                null
c288470c46f6c8949c5f7e5099b5b7947b07eabe8d9a27d79a9cbf111adcbf47   host                host
7b369448dccbf865d397c8d2be0cda7cf7edc6b0945f77d2529912ae917a0185   bridge              bridge
95e74588f40db048e86320c6526440c504650a1ff3e9f7d60a497c4d2163e5bd   foo                 bridge
63d1ff1f77b07ca51070a8c227e962238358bd310bde1529cf62e6c307ade161   dev                 bridge
```

## Filtering

The filtering flag (`-f` or `--filter`) format is a `key=value` pair. If there
is more than one filter, then pass multiple flags (e.g. `--filter "foo=bar" --filter "bif=baz"`).
Multiple filter flags are combined as an `OR` filter. For example,
`-f type=custom -f type=builtin` returns both `custom` and `builtin` networks.

The currently supported filters are:

* driver
* id (network's id)
* label (`label=<key>` or `label=<key>=<value>`)
* name (network's name)
* type (custom|builtin)

#### Driver

The `driver` filter matches networks based on their driver.

The following example matches networks with the `bridge` driver:

```bash
$ docker network ls --filter driver=bridge
NETWORK ID          NAME                DRIVER
db9db329f835        test1               bridge
f6e212da9dfd        test2               bridge
```

#### ID

The `id` filter matches on all or part of a network's ID.

The following filter matches all networks with an ID containing the
`63d1ff1f77b0...` string.

```bash
$ docker network ls --filter id=63d1ff1f77b07ca51070a8c227e962238358bd310bde1529cf62e6c307ade161
NETWORK ID          NAME                DRIVER
63d1ff1f77b0        dev                 bridge
```

You can also filter for a substring in an ID as this shows:

```bash
$ docker network ls --filter id=95e74588f40d
NETWORK ID          NAME                DRIVER
95e74588f40d        foo                 bridge

$ docker network ls --filter id=95e
NETWORK ID          NAME                DRIVER
95e74588f40d        foo                 bridge
```

#### Label

The `label` filter matches networks based on the presence of a `label` alone or a `label` and a
value.

The following filter matches networks with the `usage` label regardless of its value.

```bash
$ docker network ls -f "label=usage"
NETWORK ID          NAME                DRIVER
db9db329f835        test1               bridge
f6e212da9dfd        test2               bridge
```

The following filter matches networks with the `usage` label with the `prod` value.

```bash
$ docker network ls -f "label=usage=prod"
NETWORK ID          NAME                DRIVER
f6e212da9dfd        test2               bridge
```

#### Name

The `name` filter matches on all or part of a network's name.

The following filter matches all networks with a name containing the `foobar` string.

```bash
$ docker network ls --filter name=foobar
NETWORK ID          NAME                DRIVER
06e7eef0a170        foobar              bridge
```

You can also filter for a substring in a name as this shows:

```bash
$ docker network ls --filter name=foo
NETWORK ID          NAME                DRIVER
95e74588f40d        foo                 bridge
06e7eef0a170        foobar              bridge
```

#### Type

The `type` filter supports two values; `builtin` displays predefined networks
(`bridge`, `none`, `host`), whereas `custom` displays user defined networks.

The following filter matches all user defined networks:

```bash
$ docker network ls --filter type=custom
NETWORK ID          NAME                DRIVER
95e74588f40d        foo                 bridge
63d1ff1f77b0        dev                 bridge
```

By having this flag it allows for batch cleanup. For example, use this filter
to delete all user defined networks:

```bash
$ docker network rm `docker network ls --filter type=custom -q`
```

A warning will be issued when trying to remove a network that has containers
attached.

## Related information

* [network disconnect ](network_disconnect.md)
* [network connect](network_connect.md)
* [network create](network_create.md)
* [network inspect](network_inspect.md)
* [network rm](network_rm.md)
* [Understand Docker container networks](../../userguide/networking/index.md)
                                                                                                                                                                                                                                                                                                      go/src/github.com/docker/docker/docs/reference/commandline/network_rm.md                            0100644 0000000 0000000 00000002531 13101060260 025071  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/network_rm/
description: the network rm command description and usage
keywords:
- network, rm, user-defined
title: docker network rm
---

```markdown
Usage:  docker network rm NETWORK [NETWORK...]

Remove one or more networks

Aliases:
  rm, remove

Options:
      --help   Print usage
```

Removes one or more networks by name or identifier. To remove a network,
you must first disconnect any containers connected to it.
To remove the network named 'my-network':

```bash
  $ docker network rm my-network
```

To delete multiple networks in a single `docker network rm` command, provide
multiple network names or ids. The following example deletes a network with id
`3695c422697f` and a network named `my-network`:

```bash
  $ docker network rm 3695c422697f my-network
```

When you specify multiple networks, the command attempts to delete each in turn.
If the deletion of one network fails, the command continues to the next on the
list and tries to delete that. The command reports success or failure for each
deletion.

## Related information

* [network disconnect ](network_disconnect.md)
* [network connect](network_connect.md)
* [network create](network_create.md)
* [network ls](network_ls.md)
* [network inspect](network_inspect.md)
* [Understand Docker container networks](../../userguide/networking/index.md)
                                                                                                                                                                       go/src/github.com/docker/docker/docs/reference/commandline/node_demote.md                           0100644 0000000 0000000 00000001061 13101060260 025161  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/node_demote/
description: The node demote command description and usage
keywords:
- node, demote
title: docker node demote
---

```markdown
Usage:  docker node demote NODE [NODE...]

Demote one or more nodes from manager in the swarm

Options:
      --help   Print usage

```

Demotes an existing manager so that it is no longer a manager. This command targets a docker engine that is a manager in the swarm.


```bash
$ docker node demote <node name>
```

## Related information

* [node promote](node_promote.md)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                               go/src/github.com/docker/docker/docs/reference/commandline/node_inspect.md                          0100644 0000000 0000000 00000007171 13101060260 025361  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/node_inspect/
description: The node inspect command description and usage
keywords:
- node, inspect
title: docker node inspect
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```markdown
Usage:  docker node inspect [OPTIONS] self|NODE [NODE...]

Display detailed information on one or more nodes

Options:
  -f, --format string   Format the output using the given go template
      --help            Print usage
      --pretty          Print the information in a human friendly format.
```

Returns information about a node. By default, this command renders all results
in a JSON array. You can specify an alternate format to execute a
given template for each result. Go's
[text/template](http://golang.org/pkg/text/template/) package describes all the
details of the format.

Example output:

    $ docker node inspect swarm-manager
    [
    {
        "ID": "e216jshn25ckzbvmwlnh5jr3g",
        "Version": {
            "Index": 10
        },
        "CreatedAt": "2016-06-16T22:52:44.9910662Z",
        "UpdatedAt": "2016-06-16T22:52:45.230878043Z",
        "Spec": {
            "Role": "manager",
            "Availability": "active"
        },
        "Description": {
            "Hostname": "swarm-manager",
            "Platform": {
                "Architecture": "x86_64",
                "OS": "linux"
            },
            "Resources": {
                "NanoCPUs": 1000000000,
                "MemoryBytes": 1039843328
            },
            "Engine": {
                "EngineVersion": "1.12.0",
                "Plugins": [
                    {
                        "Type": "Volume",
                        "Name": "local"
                    },
                    {
                        "Type": "Network",
                        "Name": "overlay"
                    },
                    {
                        "Type": "Network",
                        "Name": "null"
                    },
                    {
                        "Type": "Network",
                        "Name": "host"
                    },
                    {
                        "Type": "Network",
                        "Name": "bridge"
                    },
                    {
                        "Type": "Network",
                        "Name": "overlay"
                    }
                ]
            }
        },
        "Status": {
            "State": "ready"
        },
        "ManagerStatus": {
            "Leader": true,
            "Reachability": "reachable",
            "Addr": "168.0.32.137:2377"
        }
    }
    ]

    {% raw %}
    $ docker node inspect --format '{{ .ManagerStatus.Leader }}' self
    false
    {% endraw %}

    $ docker node inspect --pretty self
    ID:                     e216jshn25ckzbvmwlnh5jr3g
    Hostname:               swarm-manager
    Joined at:              2016-06-16 22:52:44.9910662 +0000 utc
    Status:
     State:                 Ready
     Availability:          Active
    Manager Status:
     Address:               172.17.0.2:2377
     Raft Status:           Reachable
     Leader:                Yes
    Platform:
     Operating System:      linux
     Architecture:          x86_64
    Resources:
     CPUs:                  4
     Memory:                7.704 GiB
    Plugins:
      Network:              overlay, bridge, null, host, overlay
      Volume:               local
    Engine Version:         1.12.0

## Related information

* [node update](node_update.md)
* [node ps](node_ps.md)
* [node ls](node_ls.md)
* [node rm](node_rm.md)
                                                                                                                                                                                                                                                                                                                                                                                                       go/src/github.com/docker/docker/docs/reference/commandline/node_ls.md                               0100644 0000000 0000000 00000004642 13101060260 024332  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/node_ls/
description: The node ls command description and usage
keywords:
- node, list
title: docker node ls
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```markdown
Usage:  docker node ls [OPTIONS]

List nodes in the swarm

Aliases:
  ls, list

Options:
  -f, --filter value   Filter output based on conditions provided
      --help           Print usage
  -q, --quiet          Only display IDs
```

Lists all the nodes that the Docker Swarm manager knows about. You can filter using the `-f` or `--filter` flag. Refer to the [filtering](node_ls.md#filtering) section for more information about available filter options.

Example output:

```bash
$ docker node ls

ID                           HOSTNAME        STATUS  AVAILABILITY  MANAGER STATUS
1bcef6utixb0l0ca7gxuivsj0    swarm-worker2   Ready   Active
38ciaotwjuritcdtn9npbnkuz    swarm-worker1   Ready   Active
e216jshn25ckzbvmwlnh5jr3g *  swarm-manager1  Ready   Active        Leader
```

## Filtering

The filtering flag (`-f` or `--filter`) format is of "key=value". If there is more
than one filter, then pass multiple flags (e.g., `--filter "foo=bar" --filter "bif=baz"`)

The currently supported filters are:

* name
* id
* label

### name

The `name` filter matches on all or part of a node name.

The following filter matches the node with a name equal to `swarm-master` string.

```bash
$ docker node ls -f name=swarm-manager1

ID                           HOSTNAME        STATUS  AVAILABILITY  MANAGER STATUS
e216jshn25ckzbvmwlnh5jr3g *  swarm-manager1  Ready   Active        Leader
```

### id

The `id` filter matches all or part of a node's id.

```bash
$ docker node ls -f id=1

ID                         HOSTNAME       STATUS  AVAILABILITY  MANAGER STATUS
1bcef6utixb0l0ca7gxuivsj0  swarm-worker2  Ready   Active
```

#### label

The `label` filter matches tasks based on the presence of a `label` alone or a `label` and a
value.

The following filter matches nodes with the `usage` label regardless of its value.

```bash
$ docker node ls -f "label=foo"

ID                         HOSTNAME       STATUS  AVAILABILITY  MANAGER STATUS
1bcef6utixb0l0ca7gxuivsj0  swarm-worker2  Ready   Active
```


## Related information

* [node inspect](node_inspect.md)
* [node update](node_update.md)
* [node ps](node_ps.md)
* [node rm](node_rm.md)
                                                                                              go/src/github.com/docker/docker/docs/reference/commandline/node_promote.md                          0100644 0000000 0000000 00000001020 13101060260 025364  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/node_promote/
description: The node promote command description and usage
keywords:
- node, promote
title: docker node promote
---

```markdown
Usage:  docker node promote NODE [NODE...]

Promote one or more nodes to manager in the swarm

Options:
      --help   Print usage
```

Promotes a node to manager. This command targets a docker engine that is a manager in the swarm.


```bash
$ docker node promote <node name>
```

## Related information

* [node demote](node_demote.md)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                go/src/github.com/docker/docker/docs/reference/commandline/node_ps.md                               0100644 0000000 0000000 00000007566 13101060260 024346  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/node_ps/
  - /engine/reference/commandline/node_tasks/
description: The node ps command description and usage
keywords:
- node, tasks
- ps
title: docker node ps
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```markdown
Usage:  docker node ps [OPTIONS] self|NODE

List tasks running on a node

Options:
  -a, --all            Display all instances
  -f, --filter value   Filter output based on conditions provided
      --help           Print usage
      --no-resolve     Do not map IDs to Names
```

Lists all the tasks on a Node that Docker knows about. You can filter using the `-f` or `--filter` flag. Refer to the [filtering](node_ps.md#filtering) section for more information about available filter options.

Example output:

    $ docker node ps swarm-manager1
    ID                         NAME      SERVICE  IMAGE        LAST STATE          DESIRED STATE  NODE
    7q92v0nr1hcgts2amcjyqg3pq  redis.1   redis    redis:3.0.6  Running 5 hours     Running        swarm-manager1
    b465edgho06e318egmgjbqo4o  redis.6   redis    redis:3.0.6  Running 29 seconds  Running        swarm-manager1
    bg8c07zzg87di2mufeq51a2qp  redis.7   redis    redis:3.0.6  Running 5 seconds   Running        swarm-manager1
    dkkual96p4bb3s6b10r7coxxt  redis.9   redis    redis:3.0.6  Running 5 seconds   Running        swarm-manager1
    0tgctg8h8cech4w0k0gwrmr23  redis.10  redis    redis:3.0.6  Running 5 seconds   Running        swarm-manager1


## Filtering

The filtering flag (`-f` or `--filter`) format is of "key=value". If there is more
than one filter, then pass multiple flags (e.g., `--filter "foo=bar" --filter "bif=baz"`)

The currently supported filters are:

* [name](node_ps.md#name)
* [id](node_ps.md#id)
* [label](node_ps.md#label)
* [desired-state](node_ps.md#desired-state)

#### name

The `name` filter matches on all or part of a task's name.

The following filter matches all tasks with a name containing the `redis` string.

    $ docker node ps -f name=redis swarm-manager1
    ID                         NAME      SERVICE  IMAGE        LAST STATE          DESIRED STATE  NODE
    7q92v0nr1hcgts2amcjyqg3pq  redis.1   redis    redis:3.0.6  Running 5 hours     Running        swarm-manager1
    b465edgho06e318egmgjbqo4o  redis.6   redis    redis:3.0.6  Running 29 seconds  Running        swarm-manager1
    bg8c07zzg87di2mufeq51a2qp  redis.7   redis    redis:3.0.6  Running 5 seconds   Running        swarm-manager1
    dkkual96p4bb3s6b10r7coxxt  redis.9   redis    redis:3.0.6  Running 5 seconds   Running        swarm-manager1
    0tgctg8h8cech4w0k0gwrmr23  redis.10  redis    redis:3.0.6  Running 5 seconds   Running        swarm-manager1


#### id

The `id` filter matches a task's id.

    $ docker node ps -f id=bg8c07zzg87di2mufeq51a2qp swarm-manager1
    ID                         NAME      SERVICE  IMAGE        LAST STATE             DESIRED STATE  NODE
    bg8c07zzg87di2mufeq51a2qp  redis.7   redis    redis:3.0.6  Running 5 seconds      Running        swarm-manager1


#### label

The `label` filter matches tasks based on the presence of a `label` alone or a `label` and a
value.

The following filter matches tasks with the `usage` label regardless of its value.

```bash
$ docker node ps -f "label=usage"
ID                         NAME     SERVICE  IMAGE        LAST STATE          DESIRED STATE  NODE
b465edgho06e318egmgjbqo4o  redis.6  redis    redis:3.0.6  Running 10 minutes  Running        swarm-manager1
bg8c07zzg87di2mufeq51a2qp  redis.7  redis    redis:3.0.6  Running 9 minutes   Running        swarm-manager1
```


#### desired-state

The `desired-state` filter can take the values `running`, `shutdown`, and `accepted`.


## Related information

* [node inspect](node_inspect.md)
* [node update](node_update.md)
* [node ls](node_ls.md)
* [node rm](node_rm.md)
                                                                                                                                          go/src/github.com/docker/docker/docs/reference/commandline/node_rm.md                               0100644 0000000 0000000 00000003204 13101060260 024323  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/node_rm/
description: The node rm command description and usage
keywords:
- node, remove
title: docker node rm
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```markdown
Usage:  docker node rm [OPTIONS] NODE [NODE...]

Remove one or more nodes from the swarm

Aliases:
  rm, remove

Options:
      --force  Force remove an active node
      --help   Print usage
```

When run from a manager node, removes the specified nodes from a swarm.


Example output:

```nohighlight
$ docker node rm swarm-node-02

Node swarm-node-02 removed from swarm
```

Removes the specified nodes from the swarm, but only if the nodes are in the
down state. If you attempt to remove an active node you will receive an error:

```nohighlight
$ docker node rm swarm-node-03

Error response from daemon: rpc error: code = 9 desc = node swarm-node-03 is not
down and can't be removed
```

If you lose access to a worker node or need to shut it down because it has been
compromised or is not behaving as expected, you can use the `--force` option.
This may cause transient errors or interruptions, depending on the type of task
being run on the node.

```nohighlight
$ docker node rm --force swarm-node-03

Node swarm-node-03 removed from swarm
```

A manager node must be demoted to a worker node (using `docker node demote`)
before you can remove it from the swarm.

## Related information

* [node inspect](node_inspect.md)
* [node update](node_update.md)
* [node demote](node_demote.md)
* [node ps](node_ps.md)
* [node ls](node_ls.md)
                                                                                                                                                                                                                                                                                                                                                                                            go/src/github.com/docker/docker/docs/reference/commandline/node_update.md                           0100644 0000000 0000000 00000003626 13101060260 025177  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/node_update/
description: The node update command description and usage
keywords:
- resources, update, dynamically
title: docker node update
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```markdown
Usage:  docker node update [OPTIONS] NODE

Update a node

Options:
      --availability string   Availability of the node (active/pause/drain)
      --help                  Print usage
      --label-add value       Add or update a node label (key=value) (default [])
      --label-rm value        Remove a node label if exists (default [])
      --role string           Role of the node (worker/manager)
```

### Add label metadata to a node

Add metadata to a swarm node using node labels. You can specify a node label as
a key with an empty value:

``` bash
$ docker node update --label-add foo worker1
```

To add multiple labels to a node, pass the `--label-add` flag for each label:

``` bash
$ docker node update --label-add foo --label-add bar worker1
```

When you [create a service](service_create.md),
you can use node labels as a constraint. A constraint limits the nodes where the
scheduler deploys tasks for a service.

For example, to add a `type` label to identify nodes where the scheduler should
deploy message queue service tasks:

``` bash
$ docker node update --label-add type=queue worker1
```

The labels you set for nodes using `docker node update` apply only to the node
entity within the swarm. Do not confuse them with the docker daemon labels for
[dockerd]( ../../userguide/labels-custom-metadata.md#daemon-labels).

For more information about labels, refer to [apply custom
metadata](../../userguide/labels-custom-metadata.md).

## Related information

* [node inspect](node_inspect.md)
* [node ps](node_ps.md)
* [node ls](node_ls.md)
* [node rm](node_rm.md)
                                                                                                          go/src/github.com/docker/docker/docs/reference/commandline/pause.md                                 0100644 0000000 0000000 00000001451 13101060260 024017  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/pause/
description: The pause command description and usage
keywords:
- cgroups, container, suspend, SIGSTOP
title: docker pause
---

```markdown
Usage:  docker pause CONTAINER [CONTAINER...]

Pause all processes within one or more containers

Options:
      --help   Print usage
```

The `docker pause` command uses the cgroups freezer to suspend all processes in
a container. Traditionally, when suspending a process the `SIGSTOP` signal is
used, which is observable by the process being suspended. With the cgroups freezer
the process is unaware, and unable to capture, that it is being suspended,
and subsequently resumed.

See the
[cgroups freezer documentation](https://www.kernel.org/doc/Documentation/cgroup-v1/freezer-subsystem.txt)
for further details.
                                                                                                                                                                                                                       go/src/github.com/docker/docker/docs/reference/commandline/plugin_disable.md                        0100644 0000000 0000000 00000002262 13101060260 025664  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/plugin_disable/
advisory: experimental
description: the plugin disable command description and usage
keywords:
- plugin, disable
title: docker plugin disable (experimental)
---

```markdown
Usage:  docker plugin disable PLUGIN

Disable a plugin

Options:
      --help   Print usage
```

Disables a plugin. The plugin must be installed before it can be disabled,
see [`docker plugin install`](plugin_install.md).


The following example shows that the `no-remove` plugin is installed
and active:

```bash
$ docker plugin ls

NAME                        TAG           ACTIVE
tiborvass/no-remove         latest        true
```

To disable the plugin, use the following command:

```bash
$ docker plugin disable tiborvass/no-remove

tiborvass/no-remove
```

After the plugin is disabled, it appears as "inactive" in the list of plugins:

```bash
$ docker plugin ls

NAME                    VERSION           ACTIVE
tiborvass/no-remove     latest            false
```

## Related information

* [plugin ls](plugin_ls.md)
* [plugin enable](plugin_enable.md)
* [plugin inspect](plugin_inspect.md)
* [plugin install](plugin_install.md)
* [plugin rm](plugin_rm.md)
                                                                                                                                                                                                                                                                                                                                              go/src/github.com/docker/docker/docs/reference/commandline/plugin_enable.md                         0100644 0000000 0000000 00000002277 13101060260 025515  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/plugin_enable/
advisory: experimental
description: the plugin enable command description and usage
keywords:
- plugin, enable
title: docker plugin enable (experimental)
---

```markdown
Usage:  docker plugin enable PLUGIN

Enable a plugin

Options:
      --help   Print usage
```

Enables a plugin. The plugin must be installed before it can be enabled,
see [`docker plugin install`](plugin_install.md).


The following example shows that the `no-remove` plugin is installed,
but disabled ("inactive"):

```bash
$ docker plugin ls

NAME                    VERSION             ACTIVE
tiborvass/no-remove     latest              false
```

To enable the plugin, use the following command:

```bash
$ docker plugin enable tiborvass/no-remove

tiborvass/no-remove
```

After the plugin is enabled, it appears as "active" in the list of plugins:

```bash
$ docker plugin ls

NAME                    VERSION             ACTIVE
tiborvass/no-remove     latest              true
```

## Related information

* [plugin ls](plugin_ls.md)
* [plugin disable](plugin_disable.md)
* [plugin inspect](plugin_inspect.md)
* [plugin install](plugin_install.md)
* [plugin rm](plugin_rm.md)
                                                                                                                                                                                                                                                                                                                                 go/src/github.com/docker/docker/docs/reference/commandline/plugin_inspect.md                        0100644 0000000 0000000 00000005551 13101060260 025732  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/plugin_inspect/
advisory: experimental
description: The plugin inspect command description and usage
keywords:
- plugin, inspect
title: docker plugin inspect (experimental)
---

```markdown
Usage:  docker plugin inspect [OPTIONS] PLUGIN [PLUGIN...]

Display detailed information on one or more plugins

Options:
      --help   Print usage
```

Returns information about a plugin. By default, this command renders all results
in a JSON array.

Example output:

```bash
$ docker plugin inspect tiborvass/no-remove:latest
```
```JSON
{
  "Id": "8c74c978c434745c3ade82f1bc0acf38d04990eaf494fa507c16d9f1daa99c21",
  "Name": "tiborvass/no-remove",
  "Tag": "latest",
  "Active": true,
  "Config": {
    "Mounts": [
      {
        "Name": "",
        "Description": "",
        "Settable": null,
        "Source": "/data",
        "Destination": "/data",
        "Type": "bind",
        "Options": [
          "shared",
          "rbind"
        ]
      },
      {
        "Name": "",
        "Description": "",
        "Settable": null,
        "Source": null,
        "Destination": "/foobar",
        "Type": "tmpfs",
        "Options": null
      }
    ],
    "Env": [
      "DEBUG=1"
    ],
    "Args": null,
    "Devices": null
  },
  "Manifest": {
    "ManifestVersion": "v0",
    "Description": "A test plugin for Docker",
    "Documentation": "https://docs.docker.com/engine/extend/plugins/",
    "Interface": {
      "Types": [
        "docker.volumedriver/1.0"
      ],
      "Socket": "plugins.sock"
    },
    "Entrypoint": [
      "plugin-no-remove",
      "/data"
    ],
    "Workdir": "",
    "User": {
    },
    "Network": {
      "Type": "host"
    },
    "Capabilities": null,
    "Mounts": [
      {
        "Name": "",
        "Description": "",
        "Settable": null,
        "Source": "/data",
        "Destination": "/data",
        "Type": "bind",
        "Options": [
          "shared",
          "rbind"
        ]
      },
      {
        "Name": "",
        "Description": "",
        "Settable": null,
        "Source": null,
        "Destination": "/foobar",
        "Type": "tmpfs",
        "Options": null
      }
    ],
    "Devices": [
      {
        "Name": "device",
        "Description": "a host device to mount",
        "Settable": null,
        "Path": "/dev/cpu_dma_latency"
      }
    ],
    "Env": [
      {
        "Name": "DEBUG",
        "Description": "If set, prints debug messages",
        "Settable": null,
        "Value": "1"
      }
    ],
    "Args": {
      "Name": "args",
      "Description": "command line arguments",
      "Settable": null,
      "Value": [

      ]
    }
  }
}
```
(output formatted for readability)



## Related information

* [plugin ls](plugin_ls.md)
* [plugin enable](plugin_enable.md)
* [plugin disable](plugin_disable.md)
* [plugin install](plugin_install.md)
* [plugin rm](plugin_rm.md)
                                                                                                                                                       go/src/github.com/docker/docker/docs/reference/commandline/plugin_install.md                        0100644 0000000 0000000 00000003000 13101060260 025716  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/plugin_install/
advisory: experimental
description: the plugin install command description and usage
keywords:
- plugin, install
title: docker plugin install (experimental)
---

```markdown
Usage:  docker plugin install [OPTIONS] PLUGIN

Install a plugin

Options:
      --disable                 do not enable the plugin on install
      --grant-all-permissions   grant all permissions necessary to run the plugin
      --help                    Print usage
```

Installs and enables a plugin. Docker looks first for the plugin on your Docker
host. If the plugin does not exist locally, then the plugin is pulled from
Docker Hub.


The following example installs `no-remove` plugin. Install consists of pulling the
plugin from Docker Hub, prompting the user to accept the list of privileges that
the plugin needs and enabling the plugin.

```bash
$ docker plugin install tiborvass/no-remove

Plugin "tiborvass/no-remove" is requesting the following privileges:
 - network: [host]
 - mount: [/data]
 - device: [/dev/cpu_dma_latency]
Do you grant the above permissions? [y/N] y
tiborvass/no-remove
```

After the plugin is installed, it appears in the list of plugins:

```bash
$ docker plugin ls

NAME                  VERSION             ACTIVE
tiborvass/no-remove   latest              true
```

## Related information

* [plugin ls](plugin_ls.md)
* [plugin enable](plugin_enable.md)
* [plugin disable](plugin_disable.md)
* [plugin inspect](plugin_inspect.md)
* [plugin rm](plugin_rm.md)
go/src/github.com/docker/docker/docs/reference/commandline/plugin_ls.md                             0100644 0000000 0000000 00000001451 13101060260 024676  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/plugin_ls/
advisory: experimental
description: The plugin ls command description and usage
keywords:
- plugin, list
title: docker plugin ls (experimental)
---

```markdown
Usage:  docker plugin ls

List plugins

Aliases:
  ls, list

Options:
      --help   Print usage
```

Lists all the plugins that are currently installed. You can install plugins
using the [`docker plugin install`](plugin_install.md) command.

Example output:

```bash
$ docker plugin ls

NAME                  VERSION             ACTIVE
tiborvass/no-remove   latest              true
```

## Related information

* [plugin enable](plugin_enable.md)
* [plugin disable](plugin_disable.md)
* [plugin inspect](plugin_inspect.md)
* [plugin install](plugin_install.md)
* [plugin rm](plugin_rm.md)
                                                                                                                                                                                                                       go/src/github.com/docker/docker/docs/reference/commandline/plugin_rm.md                             0100644 0000000 0000000 00000001636 13101060260 024703  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/plugin_rm/
advisory: experimental
description: the plugin rm command description and usage
keywords:
- plugin, rm
title: docker plugin rm (experimental)
---

```markdown
Usage:  docker plugin rm PLUGIN

Remove one or more plugins

Aliases:
  rm, remove

Options:
      --help   Print usage
```

Removes a plugin. You cannot remove a plugin if it is active, you must disable
a plugin using the [`docker plugin disable`](plugin_disable.md) before removing
it.

The following example disables and removes the `no-remove:latest` plugin;

```bash
$ docker plugin disable tiborvass/no-remove
tiborvass/no-remove

$ docker plugin rm tiborvass/no-remove:latest
tiborvass/no-remove
```

## Related information

* [plugin ls](plugin_ls.md)
* [plugin enable](plugin_enable.md)
* [plugin disable](plugin_disable.md)
* [plugin inspect](plugin_inspect.md)
* [plugin install](plugin_install.md)
                                                                                                  go/src/github.com/docker/docker/docs/reference/commandline/port.md                                  0100644 0000000 0000000 00000002033 13101060260 023663  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/port/
description: The port command description and usage
keywords:
- port, mapping, container
title: docker port
---

```markdown
Usage:  docker port CONTAINER [PRIVATE_PORT[/PROTO]]

List port mappings or a specific mapping for the container

Options:
      --help   Print usage
```

You can find out all the ports mapped by not specifying a `PRIVATE_PORT`, or
just a specific mapping:

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                            NAMES
    b650456536c7        busybox:latest      top                 54 minutes ago      Up 54 minutes       0.0.0.0:1234->9876/tcp, 0.0.0.0:4321->7890/tcp   test
    $ docker port test
    7890/tcp -> 0.0.0.0:4321
    9876/tcp -> 0.0.0.0:1234
    $ docker port test 7890/tcp
    0.0.0.0:4321
    $ docker port test 7890/udp
    2014/06/24 11:53:36 Error: No public port '7890/udp' published for test
    $ docker port test 7890
    0.0.0.0:4321
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     go/src/github.com/docker/docker/docs/reference/commandline/ps.md                                    0100644 0000000 0000000 00000036662 13101060260 023340  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/ps/
description: The ps command description and usage
keywords:
- container, running, list
title: docker ps
---

```markdown
Usage: docker ps [OPTIONS]

List containers

Options:
  -a, --all             Show all containers (default shows just running)
  -f, --filter value    Filter output based on conditions provided (default [])
                        - exited=<int> an exit code of <int>
                        - label=<key> or label=<key>=<value>
                        - status=(created|restarting|running|paused|exited)
                        - name=<string> a container's name
                        - id=<ID> a container's ID
                        - before=(<container-name>|<container-id>)
                        - since=(<container-name>|<container-id>)
                        - ancestor=(<image-name>[:tag]|<image-id>|<image@digest>)
                          containers created from an image or a descendant.
      --format string   Pretty-print containers using a Go template
      --help            Print usage
  -n, --last int        Show n last created containers (includes all states) (default -1)
  -l, --latest          Show the latest created container (includes all states)
      --no-trunc        Don't truncate output
  -q, --quiet           Only display numeric IDs
  -s, --size            Display total file sizes
```

Running `docker ps --no-trunc` showing 2 linked containers.

```bash
$ docker ps

CONTAINER ID        IMAGE                        COMMAND                CREATED              STATUS              PORTS               NAMES
4c01db0b339c        ubuntu:12.04                 bash                   17 seconds ago       Up 16 seconds       3300-3310/tcp       webapp
d7886598dbe2        crosbymichael/redis:latest   /redis-server --dir    33 minutes ago       Up 33 minutes       6379/tcp            redis,webapp/db
```

The `docker ps` command only shows running containers by default. To see all
containers, use the `-a` (or `--all`) flag:

```bash
$ docker ps -a
```

`docker ps` groups exposed ports into a single range if possible. E.g., a
container that exposes TCP ports `100, 101, 102` displays `100-102/tcp` in
the `PORTS` column.

## Filtering

The filtering flag (`-f` or `--filter`) format is a `key=value` pair. If there is more
than one filter, then pass multiple flags (e.g. `--filter "foo=bar" --filter "bif=baz"`)

The currently supported filters are:

* id (container's id)
* label (`label=<key>` or `label=<key>=<value>`)
* name (container's name)
* exited (int - the code of exited containers. Only useful with `--all`)
* status (created|restarting|running|paused|exited|dead)
* ancestor (`<image-name>[:<tag>]`,  `<image id>` or `<image@digest>`) - filters containers that were created from the given image or a descendant.
* before (container's id or name) - filters containers created before given id or name
* since (container's id or name) - filters containers created since given id or name
* isolation (default|process|hyperv)   (Windows daemon only)
* volume (volume name or mount point) - filters containers that mount volumes.
* network (network id or name) - filters containers connected to the provided network

#### Label

The `label` filter matches containers based on the presence of a `label` alone or a `label` and a
value.

The following filter matches containers with the `color` label regardless of its value.

```bash
$ docker ps --filter "label=color"

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
673394ef1d4c        busybox             "top"               47 seconds ago      Up 45 seconds                           nostalgic_shockley
d85756f57265        busybox             "top"               52 seconds ago      Up 51 seconds                           high_albattani
```

The following filter matches containers with the `color` label with the `blue` value.

```bash
$ docker ps --filter "label=color=blue"

CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
d85756f57265        busybox             "top"               About a minute ago   Up About a minute                       high_albattani
```

#### Name

The `name` filter matches on all or part of a container's name.

The following filter matches all containers with a name containing the `nostalgic_stallman` string.

```bash
$ docker ps --filter "name=nostalgic_stallman"

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
9b6247364a03        busybox             "top"               2 minutes ago       Up 2 minutes                            nostalgic_stallman
```

You can also filter for a substring in a name as this shows:

```bash
$ docker ps --filter "name=nostalgic"

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
715ebfcee040        busybox             "top"               3 seconds ago       Up 1 seconds                            i_am_nostalgic
9b6247364a03        busybox             "top"               7 minutes ago       Up 7 minutes                            nostalgic_stallman
673394ef1d4c        busybox             "top"               38 minutes ago      Up 38 minutes                           nostalgic_shockley
```

#### Exited

The `exited` filter matches containers by exist status code. For example, to
filter for containers that have exited successfully:

```bash
$ docker ps -a --filter 'exited=0'

CONTAINER ID        IMAGE             COMMAND                CREATED             STATUS                   PORTS                      NAMES
ea09c3c82f6e        registry:latest   /srv/run.sh            2 weeks ago         Exited (0) 2 weeks ago   127.0.0.1:5000->5000/tcp   desperate_leakey
106ea823fe4e        fedora:latest     /bin/sh -c 'bash -l'   2 weeks ago         Exited (0) 2 weeks ago                              determined_albattani
48ee228c9464        fedora:20         bash                   2 weeks ago         Exited (0) 2 weeks ago                              tender_torvalds
```

#### Killed containers

You can use a filter to locate containers that exited with status of `137`
meaning a `SIGKILL(9)` killed them.

```bash
$ docker ps -a --filter 'exited=137'
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS                       PORTS               NAMES
b3e1c0ed5bfe        ubuntu:latest       "sleep 1000"           12 seconds ago      Exited (137) 5 seconds ago                       grave_kowalevski
a2eb5558d669        redis:latest        "/entrypoint.sh redi   2 hours ago         Exited (137) 2 hours ago                         sharp_lalande
```

Any of these events result in a `137` status:

* the `init` process of the container is killed manually
* `docker kill` kills the container
* Docker daemon restarts which kills all running containers

#### Status

The `status` filter matches containers by status. You can filter using
`created`, `restarting`, `running`, `paused`, `exited` and `dead`. For example,
to filter for `running` containers:

```bash
$ docker ps --filter status=running

CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS              PORTS               NAMES
715ebfcee040        busybox                "top"               16 minutes ago      Up 16 minutes                           i_am_nostalgic
d5c976d3c462        busybox                "top"               23 minutes ago      Up 23 minutes                           top
9b6247364a03        busybox                "top"               24 minutes ago      Up 24 minutes                           nostalgic_stallman
```

To filter for `paused` containers:

```bash
$ docker ps --filter status=paused

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
673394ef1d4c        busybox             "top"               About an hour ago   Up About an hour (Paused)                       nostalgic_shockley
```

#### Ancestor

The `ancestor` filter matches containers based on its image or a descendant of
it. The filter supports the following image representation:

- image
- image:tag
- image:tag@digest
- short-id
- full-id

If you don't specify a `tag`, the `latest` tag is used. For example, to filter
for containers that use the latest `ubuntu` image:

```bash
$ docker ps --filter ancestor=ubuntu

CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
919e1179bdb8        ubuntu-c1           "top"               About a minute ago   Up About a minute                       admiring_lovelace
5d1e4a540723        ubuntu-c2           "top"               About a minute ago   Up About a minute                       admiring_sammet
82a598284012        ubuntu              "top"               3 minutes ago        Up 3 minutes                            sleepy_bose
bab2a34ba363        ubuntu              "top"               3 minutes ago        Up 3 minutes                            focused_yonath
```

Match containers based on the `ubuntu-c1` image which, in this case, is a child
of `ubuntu`:

```bash
$ docker ps --filter ancestor=ubuntu-c1

CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
919e1179bdb8        ubuntu-c1           "top"               About a minute ago   Up About a minute                       admiring_lovelace
```

Match containers based on the `ubuntu` version `12.04.5` image:

```bash
$ docker ps --filter ancestor=ubuntu:12.04.5

CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
82a598284012        ubuntu:12.04.5      "top"               3 minutes ago        Up 3 minutes                            sleepy_bose
```

The following matches containers based on the layer `d0e008c6cf02` or an image
that have this layer in it's layer stack.

```bash
$ docker ps --filter ancestor=d0e008c6cf02

CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
82a598284012        ubuntu:12.04.5      "top"               3 minutes ago        Up 3 minutes                            sleepy_bose
```

#### Before

The `before` filter shows only containers created before the container with
given id or name. For example, having these containers created:

```bash
$ docker ps

CONTAINER ID        IMAGE       COMMAND       CREATED              STATUS              PORTS              NAMES
9c3527ed70ce        busybox     "top"         14 seconds ago       Up 15 seconds                          desperate_dubinsky
4aace5031105        busybox     "top"         48 seconds ago       Up 49 seconds                          focused_hamilton
6e63f6ff38b0        busybox     "top"         About a minute ago   Up About a minute                      distracted_fermat
```

Filtering with `before` would give:

```bash
$ docker ps -f before=9c3527ed70ce

CONTAINER ID        IMAGE       COMMAND       CREATED              STATUS              PORTS              NAMES
4aace5031105        busybox     "top"         About a minute ago   Up About a minute                      focused_hamilton
6e63f6ff38b0        busybox     "top"         About a minute ago   Up About a minute                      distracted_fermat
```

#### Since

The `since` filter shows only containers created since the container with given
id or name. For example, with the same containers as in `before` filter:

```bash
$ docker ps -f since=6e63f6ff38b0

CONTAINER ID        IMAGE       COMMAND       CREATED             STATUS              PORTS               NAMES
9c3527ed70ce        busybox     "top"         10 minutes ago      Up 10 minutes                           desperate_dubinsky
4aace5031105        busybox     "top"         10 minutes ago      Up 10 minutes                           focused_hamilton
```

#### Volume

The `volume` filter shows only containers that mount a specific volume or have
a volume mounted in a specific path:

```bash{% raw %}
$ docker ps --filter volume=remote-volume --format "table {{.ID}}\t{{.Mounts}}"
CONTAINER ID        MOUNTS
9c3527ed70ce        remote-volume

$ docker ps --filter volume=/data --format "table {{.ID}}\t{{.Mounts}}"
CONTAINER ID        MOUNTS
9c3527ed70ce        remote-volume
{% endraw %}```

#### Network

The `network` filter shows only containers that are connected to a network with
a given name or id.

The following filter matches all containers that are connected to a network
with a name containing `net1`.

```bash
$ docker run -d --net=net1 --name=test1 ubuntu top
$ docker run -d --net=net2 --name=test2 ubuntu top

$ docker ps --filter network=net1

CONTAINER ID        IMAGE       COMMAND       CREATED             STATUS              PORTS               NAMES
9d4893ed80fe        ubuntu      "top"         10 minutes ago      Up 10 minutes                           test1
```

The network filter matches on both the network's name and id. The following
example shows all containers that are attached to the `net1` network, using
the network id as a filter;

```bash
{% raw %}
$ docker network inspect --format "{{.ID}}" net1
{% endraw %}

8c0b4110ae930dbe26b258de9bc34a03f98056ed6f27f991d32919bfe401d7c5

$ docker ps --filter network=8c0b4110ae930dbe26b258de9bc34a03f98056ed6f27f991d32919bfe401d7c5

CONTAINER ID        IMAGE       COMMAND       CREATED             STATUS              PORTS               NAMES
9d4893ed80fe        ubuntu      "top"         10 minutes ago      Up 10 minutes                           test1
```

## Formatting

The formatting option (`--format`) pretty-prints container output using a Go
template.

Valid placeholders for the Go template are listed below:

Placeholder   | Description
--------------|----------------------------------------------------------------------------------------------------
`.ID`         | Container ID
`.Image`      | Image ID
`.Command`    | Quoted command
`.CreatedAt`  | Time when the container was created.
`.RunningFor` | Elapsed time since the container was started.
`.Ports`      | Exposed ports.
`.Status`     | Container status.
`.Size`       | Container disk size.
`.Names`      | Container names.
`.Labels`     | All labels assigned to the container.
`.Label`      | Value of a specific label for this container. For example `'{% raw %}{{.Label "com.docker.swarm.cpu"}}{% endraw %}'`
`.Mounts`     | Names of the volumes mounted in this container.

When using the `--format` option, the `ps` command will either output the data
exactly as the template declares or, when using the `table` directive, includes
column headers as well.

The following example uses a template without headers and outputs the `ID` and
`Command` entries separated by a colon for all running containers:

```bash
{% raw %}
$ docker ps --format "{{.ID}}: {{.Command}}"
{% endraw %}

a87ecb4f327c: /bin/sh -c #(nop) MA
01946d9d34d8: /bin/sh -c #(nop) MA
c1d3b0166030: /bin/sh -c yum -y up
41d50ecd2f57: /bin/sh -c #(nop) MA
```

To list all running containers with their labels in a table format you can use:

```bash
{% raw %}
$ docker ps --format "table {{.ID}}\t{{.Labels}}"
{% endraw %}

CONTAINER ID        LABELS
a87ecb4f327c        com.docker.swarm.node=ubuntu,com.docker.swarm.storage=ssd
01946d9d34d8
c1d3b0166030        com.docker.swarm.node=debian,com.docker.swarm.cpu=6
41d50ecd2f57        com.docker.swarm.node=fedora,com.docker.swarm.cpu=3,com.docker.swarm.storage=ssd
```
                                                                              go/src/github.com/docker/docker/docs/reference/commandline/pull.md                                  0100644 0000000 0000000 00000020704 13101060260 023660  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/pull/
description: The pull command description and usage
keywords:
- pull, image, hub, docker
title: docker pull
---

```markdown
Usage:  docker pull [OPTIONS] NAME[:TAG|@DIGEST]

Pull an image or a repository from a registry

Options:
  -a, --all-tags                Download all tagged images in the repository
      --disable-content-trust   Skip image verification (default true)
      --help                    Print usage
```

Most of your images will be created on top of a base image from the
[Docker Hub](https://hub.docker.com) registry.

[Docker Hub](https://hub.docker.com) contains many pre-built images that you
can `pull` and try without needing to define and configure your own.

To download a particular image, or set of images (i.e., a repository),
use `docker pull`.

## Proxy configuration

If you are behind an HTTP proxy server, for example in corporate settings,
before open a connect to registry, you may need to configure the Docker
daemon's proxy settings, using the `HTTP_PROXY`, `HTTPS_PROXY`, and `NO_PROXY`
environment variables. To set these environment variables on a host using
`systemd`, refer to the [control and configure Docker with systemd](../../admin/systemd.md#http-proxy)
for variables configuration.

## Examples

### Pull an image from Docker Hub

To download a particular image, or set of images (i.e., a repository), use
`docker pull`. If no tag is provided, Docker Engine uses the `:latest` tag as a
default. This command pulls the `debian:latest` image:

```bash
$ docker pull debian

Using default tag: latest
latest: Pulling from library/debian
fdd5d7827f33: Pull complete
a3ed95caeb02: Pull complete
Digest: sha256:e7d38b3517548a1c71e41bffe9c8ae6d6d29546ce46bf62159837aad072c90aa
Status: Downloaded newer image for debian:latest
```

Docker images can consist of multiple layers. In the example above, the image
consists of two layers; `fdd5d7827f33` and `a3ed95caeb02`.

Layers can be reused by images. For example, the `debian:jessie` image shares
both layers with `debian:latest`. Pulling the `debian:jessie` image therefore
only pulls its metadata, but not its layers, because all layers are already
present locally:

```bash
$ docker pull debian:jessie

jessie: Pulling from library/debian
fdd5d7827f33: Already exists
a3ed95caeb02: Already exists
Digest: sha256:a9c958be96d7d40df920e7041608f2f017af81800ca5ad23e327bc402626b58e
Status: Downloaded newer image for debian:jessie
```

To see which images are present locally, use the [`docker images`](images.md)
command:

```bash
$ docker images

REPOSITORY   TAG      IMAGE ID        CREATED      SIZE
debian       jessie   f50f9524513f    5 days ago   125.1 MB
debian       latest   f50f9524513f    5 days ago   125.1 MB
```

Docker uses a content-addressable image store, and the image ID is a SHA256
digest covering the image's configuration and layers. In the example above,
`debian:jessie` and `debian:latest` have the same image ID because they are
actually the *same* image tagged with different names. Because they are the
same image, their layers are stored only once and do not consume extra disk
space.

For more information about images, layers, and the content-addressable store,
refer to [understand images, containers, and storage drivers](../../userguide/storagedriver/imagesandcontainers.md).


## Pull an image by digest (immutable identifier)

So far, you've pulled images by their name (and "tag"). Using names and tags is
a convenient way to work with images. When using tags, you can `docker pull` an
image again to make sure you have the most up-to-date version of that image.
For example, `docker pull ubuntu:14.04` pulls the latest version of the Ubuntu
14.04 image.

In some cases you don't want images to be updated to newer versions, but prefer
to use a fixed version of an image. Docker enables you to pull an image by its
*digest*. When pulling an image by digest, you specify *exactly* which version
of an image to pull. Doing so, allows you to "pin" an image to that version,
and guarantee that the image you're using is always the same.

To know the digest of an image, pull the image first. Let's pull the latest
`ubuntu:14.04` image from Docker Hub:

```bash
$ docker pull ubuntu:14.04

14.04: Pulling from library/ubuntu
5a132a7e7af1: Pull complete
fd2731e4c50c: Pull complete
28a2f68d1120: Pull complete
a3ed95caeb02: Pull complete
Digest: sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2
Status: Downloaded newer image for ubuntu:14.04
```

Docker prints the digest of the image after the pull has finished. In the example
above, the digest of the image is:

    sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2

Docker also prints the digest of an image when *pushing* to a registry. This
may be useful if you want to pin to a version of the image you just pushed.

A digest takes the place of the tag when pulling an image, for example, to
pull the above image by digest, run the following command:

```bash
$ docker pull ubuntu@sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2

sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2: Pulling from library/ubuntu
5a132a7e7af1: Already exists
fd2731e4c50c: Already exists
28a2f68d1120: Already exists
a3ed95caeb02: Already exists
Digest: sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2
Status: Downloaded newer image for ubuntu@sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2
```

Digest can also be used in the `FROM` of a Dockerfile, for example:

```Dockerfile
FROM ubuntu@sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2
MAINTAINER some maintainer <maintainer@example.com>
```

> **Note**: Using this feature "pins" an image to a specific version in time.
> Docker will therefore not pull updated versions of an image, which may include
> security updates. If you want to pull an updated image, you need to change the
> digest accordingly.


## Pulling from a different registry

By default, `docker pull` pulls images from [Docker Hub](https://hub.docker.com). It is also possible to
manually specify the path of a registry to pull from. For example, if you have
set up a local registry, you can specify its path to pull from it. A registry
path is similar to a URL, but does not contain a protocol specifier (`https://`).

The following command pulls the `testing/test-image` image from a local registry
listening on port 5000 (`myregistry.local:5000`):

```bash
$ docker pull myregistry.local:5000/testing/test-image
```

Registry credentials are managed by [docker login](login.md).

Docker uses the `https://` protocol to communicate with a registry, unless the
registry is allowed to be accessed over an insecure connection. Refer to the
[insecure registries](dockerd.md#insecure-registries) section for more information.


## Pull a repository with multiple images

By default, `docker pull` pulls a *single* image from the registry. A repository
can contain multiple images. To pull all images from a repository, provide the
`-a` (or `--all-tags`) option when using `docker pull`.

This command pulls all images from the `fedora` repository:

```bash
$ docker pull --all-tags fedora

Pulling repository fedora
ad57ef8d78d7: Download complete
105182bb5e8b: Download complete
511136ea3c5a: Download complete
73bd853d2ea5: Download complete
....

Status: Downloaded newer image for fedora
```

After the pull has completed use the `docker images` command to see the
images that were pulled. The example below shows all the `fedora` images
that are present locally:

```bash
$ docker images fedora

REPOSITORY   TAG         IMAGE ID        CREATED      SIZE
fedora       rawhide     ad57ef8d78d7    5 days ago   359.3 MB
fedora       20          105182bb5e8b    5 days ago   372.7 MB
fedora       heisenbug   105182bb5e8b    5 days ago   372.7 MB
fedora       latest      105182bb5e8b    5 days ago   372.7 MB
```

## Canceling a pull

Killing the `docker pull` process, for example by pressing `CTRL-c` while it is
running in a terminal, will terminate the pull operation.

```bash
$ docker pull fedora

Using default tag: latest
latest: Pulling from library/fedora
a3ed95caeb02: Pulling fs layer
236608c7b546: Pulling fs layer
^C
```

> **Note**: Technically, the Engine terminates a pull operation when the
> connection between the Docker Engine daemon and the Docker Engine client
> initiating the pull is lost. If the connection with the Engine daemon is
> lost for other reasons than a manual interaction, the pull is also aborted.
                                                            go/src/github.com/docker/docker/docs/reference/commandline/push.md                                  0100644 0000000 0000000 00000003114 13101060260 023657  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/push/
description: The push command description and usage
keywords:
- share, push, image
title: docker push
---

```markdown
Usage:  docker push [OPTIONS] NAME[:TAG]

Push an image or a repository to a registry

Options:
      --disable-content-trust   Skip image verification (default true)
      --help                    Print usage
```

Use `docker push` to share your images to the [Docker Hub](https://hub.docker.com)
registry or to a self-hosted one.

Refer to the [`docker tag`](tag.md) reference for more information about valid
image and tag names.

Killing the `docker push` process, for example by pressing `CTRL-c` while it is
running in a terminal, terminates the push operation.

Registry credentials are managed by [docker login](login.md).

## Examples

### Pushing a new image to a registry

First save the new image by finding the container ID (using [`docker ps`](ps.md))
and then committing it to a new image name.  Note that only `a-z0-9-_.` are
allowed when naming images:

```bash
$ docker commit c16378f943fe rhel-httpd
```

Now, push the image to the registry using the image ID. In this example the
registry is on host named `registry-host` and listening on port `5000`. To do
this, tag the image with the host name or IP address, and the port of the
registry:

```bash
$ docker tag rhel-httpd registry-host:5000/myadmin/rhel-httpd
$ docker push registry-host:5000/myadmin/rhel-httpd
```

Check that this worked by running:

```bash
$ docker images
```

You should see both `rhel-httpd` and `registry-host:5000/myadmin/rhel-httpd`
listed.
                                                                                                                                                                                                                                                                                                                                                                                                                                                    go/src/github.com/docker/docker/docs/reference/commandline/rename.md                                0100644 0000000 0000000 00000000563 13101060260 024154  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/rename/
description: The rename command description and usage
keywords:
- rename, docker, container
title: docker rename
---

```markdown
Usage:  docker rename CONTAINER NEW_NAME

Rename a container

Options:
      --help   Print usage
```

The `docker rename` command allows the container to be renamed to a different name.
                                                                                                                                             go/src/github.com/docker/docker/docs/reference/commandline/restart.md                               0100644 0000000 0000000 00000000631 13101060260 024365  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/restart/
description: The restart command description and usage
keywords:
- restart, container, Docker
title: docker restart
---

```markdown
Usage:  docker restart [OPTIONS] CONTAINER [CONTAINER...]

Restart one or more containers

Options:
      --help       Print usage
  -t, --time int   Seconds to wait for stop before killing the container (default 10)
```
                                                                                                       go/src/github.com/docker/docker/docs/reference/commandline/rm.md                                    0100644 0000000 0000000 00000003201 13101060260 023313  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/rm/
description: The rm command description and usage
keywords:
- remove, Docker, container
title: docker rm
---

```markdown
Usage:  docker rm [OPTIONS] CONTAINER [CONTAINER...]

Remove one or more containers

Options:
  -f, --force     Force the removal of a running container (uses SIGKILL)
      --help      Print usage
  -l, --link      Remove the specified link
  -v, --volumes   Remove the volumes associated with the container
```

## Examples

    $ docker rm /redis
    /redis

This will remove the container referenced under the link
`/redis`.

    $ docker rm --link /webapp/redis
    /webapp/redis

This will remove the underlying link between `/webapp` and the `/redis`
containers removing all network communication.

    $ docker rm --force redis
    redis

The main process inside the container referenced under the link `/redis` will receive
`SIGKILL`, then the container will be removed.

    $ docker rm $(docker ps -a -q)

This command will delete all stopped containers. The command
`docker ps -a -q` will return all existing container IDs and pass them to
the `rm` command which will delete them. Any running containers will not be
deleted.

    $ docker rm -v redis
    redis

This command will remove the container and any volumes associated with it.
Note that if a volume was specified with a name, it will not be removed.

    $ docker create -v awesome:/foo -v /bar --name hello redis
    hello
    $ docker rm -v hello

In this example, the volume for `/foo` will remain intact, but the volume for
`/bar` will be removed. The same behavior holds for volumes inherited with
`--volumes-from`.
                                                                                                                                                                                                                                                                                                                                                                                               go/src/github.com/docker/docker/docs/reference/commandline/rmi.md                                   0100644 0000000 0000000 00000006616 13101060260 023501  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/rmi/
description: The rmi command description and usage
keywords:
- remove, image, Docker
title: docker rmi
---

```markdown
Usage:  docker rmi [OPTIONS] IMAGE [IMAGE...]

Remove one or more images

Options:
  -f, --force      Force removal of the image
      --help       Print usage
      --no-prune   Do not delete untagged parents
```

You can remove an image using its short or long ID, its tag, or its digest. If
an image has one or more tag referencing it, you must remove all of them before
the image is removed. Digest references are removed automatically when an image
is removed by tag.

    $ docker images
    REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
    test1                     latest              fd484f19954f        23 seconds ago      7 B (virtual 4.964 MB)
    test                      latest              fd484f19954f        23 seconds ago      7 B (virtual 4.964 MB)
    test2                     latest              fd484f19954f        23 seconds ago      7 B (virtual 4.964 MB)

    $ docker rmi fd484f19954f
    Error: Conflict, cannot delete image fd484f19954f because it is tagged in multiple repositories, use -f to force
    2013/12/11 05:47:16 Error: failed to remove one or more images

    $ docker rmi test1
    Untagged: test1:latest
    $ docker rmi test2
    Untagged: test2:latest

    $ docker images
    REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
    test                      latest              fd484f19954f        23 seconds ago      7 B (virtual 4.964 MB)
    $ docker rmi test
    Untagged: test:latest
    Deleted: fd484f19954f4920da7ff372b5067f5b7ddb2fd3830cecd17b96ea9e286ba5b8

If you use the `-f` flag and specify the image's short or long ID, then this
command untags and removes all images that match the specified ID.

    $ docker images
    REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
    test1                     latest              fd484f19954f        23 seconds ago      7 B (virtual 4.964 MB)
    test                      latest              fd484f19954f        23 seconds ago      7 B (virtual 4.964 MB)
    test2                     latest              fd484f19954f        23 seconds ago      7 B (virtual 4.964 MB)

    $ docker rmi -f fd484f19954f
    Untagged: test1:latest
    Untagged: test:latest
    Untagged: test2:latest
    Deleted: fd484f19954f4920da7ff372b5067f5b7ddb2fd3830cecd17b96ea9e286ba5b8

An image pulled by digest has no tag associated with it:

    $ docker images --digests
    REPOSITORY                     TAG       DIGEST                                                                    IMAGE ID        CREATED         SIZE
    localhost:5000/test/busybox    <none>    sha256:cbbf2f9a99b47fc460d422812b6a5adff7dfee951d8fa2e4a98caa0382cfbdbf   4986bf8c1536    9 weeks ago     2.43 MB

To remove an image using its digest:

    $ docker rmi localhost:5000/test/busybox@sha256:cbbf2f9a99b47fc460d422812b6a5adff7dfee951d8fa2e4a98caa0382cfbdbf
    Untagged: localhost:5000/test/busybox@sha256:cbbf2f9a99b47fc460d422812b6a5adff7dfee951d8fa2e4a98caa0382cfbdbf
    Deleted: 4986bf8c15363d1c5d15512d5266f8777bfba4974ac56e3270e7760f6f0a8125
    Deleted: ea13149945cb6b1e746bf28032f02e9b5a793523481a0a18645fc77ad53c4ea2
    Deleted: df7546f9f060a2268024c8a230d8639878585defcc1bc6f79d2728a13957871b
                                                                                                                  go/src/github.com/docker/docker/docs/reference/commandline/run.md                                   0100644 0000000 0000000 00000077341 13101060260 023521  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/run/
description: The run command description and usage
keywords:
- run, command, container
title: docker run
---

```markdown
Usage:  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

Run a command in a new container

Options:
      --add-host value              Add a custom host-to-IP mapping (host:ip) (default [])
  -a, --attach value                Attach to STDIN, STDOUT or STDERR (default [])
      --blkio-weight value          Block IO (relative weight), between 10 and 1000
      --blkio-weight-device value   Block IO weight (relative device weight) (default [])
      --cap-add value               Add Linux capabilities (default [])
      --cap-drop value              Drop Linux capabilities (default [])
      --cgroup-parent string        Optional parent cgroup for the container
      --cidfile string              Write the container ID to the file
      --cpu-percent int             CPU percent (Windows only)
      --cpu-period int              Limit CPU CFS (Completely Fair Scheduler) period
      --cpu-quota int               Limit CPU CFS (Completely Fair Scheduler) quota
  -c, --cpu-shares int              CPU shares (relative weight)
      --cpuset-cpus string          CPUs in which to allow execution (0-3, 0,1)
      --cpuset-mems string          MEMs in which to allow execution (0-3, 0,1)
  -d, --detach                      Run container in background and print container ID
      --detach-keys string          Override the key sequence for detaching a container
      --device value                Add a host device to the container (default [])
      --device-read-bps value       Limit read rate (bytes per second) from a device (default [])
      --device-read-iops value      Limit read rate (IO per second) from a device (default [])
      --device-write-bps value      Limit write rate (bytes per second) to a device (default [])
      --device-write-iops value     Limit write rate (IO per second) to a device (default [])
      --disable-content-trust       Skip image verification (default true)
      --dns value                   Set custom DNS servers (default [])
      --dns-opt value               Set DNS options (default [])
      --dns-search value            Set custom DNS search domains (default [])
      --entrypoint string           Overwrite the default ENTRYPOINT of the image
  -e, --env value                   Set environment variables (default [])
      --env-file value              Read in a file of environment variables (default [])
      --expose value                Expose a port or a range of ports (default [])
      --group-add value             Add additional groups to join (default [])
      --health-cmd string           Command to run to check health
      --health-interval duration    Time between running the check
      --health-retries int          Consecutive failures needed to report unhealthy
      --health-timeout duration     Maximum time to allow one check to run
      --help                        Print usage
  -h, --hostname string             Container host name
  -i, --interactive                 Keep STDIN open even if not attached
      --io-maxbandwidth string      Maximum IO bandwidth limit for the system drive (Windows only)
                                    (Windows only). The format is `<number><unit>`.
                                    Unit is optional and can be `b` (bytes per second),
                                    `k` (kilobytes per second), `m` (megabytes per second),
                                    or `g` (gigabytes per second). If you omit the unit,
                                    the system uses bytes per second.
                                    --io-maxbandwidth and --io-maxiops are mutually exclusive options.
      --io-maxiops uint             Maximum IOps limit for the system drive (Windows only)
      --ip string                   Container IPv4 address (e.g. 172.30.100.104)
      --ip6 string                  Container IPv6 address (e.g. 2001:db8::33)
      --ipc string                  IPC namespace to use
      --isolation string            Container isolation technology
      --kernel-memory string        Kernel memory limit
  -l, --label value                 Set meta data on a container (default [])
      --label-file value            Read in a line delimited file of labels (default [])
      --link value                  Add link to another container (default [])
      --link-local-ip value         Container IPv4/IPv6 link-local addresses (default [])
      --log-driver string           Logging driver for the container
      --log-opt value               Log driver options (default [])
      --mac-address string          Container MAC address (e.g. 92:d0:c6:0a:29:33)
  -m, --memory string               Memory limit
      --memory-reservation string   Memory soft limit
      --memory-swap string          Swap limit equal to memory plus swap: '-1' to enable unlimited swap
      --memory-swappiness int       Tune container memory swappiness (0 to 100) (default -1).
      --name string                 Assign a name to the container
      --network-alias value         Add network-scoped alias for the container (default [])
      --network string              Connect a container to a network
                                    'bridge': create a network stack on the default Docker bridge
                                    'none': no networking
                                    'container:<name|id>': reuse another container's network stack
                                    'host': use the Docker host network stack
                                    '<network-name>|<network-id>': connect to a user-defined network
      --no-healthcheck              Disable any container-specified HEALTHCHECK
      --oom-kill-disable            Disable OOM Killer
      --oom-score-adj int           Tune host's OOM preferences (-1000 to 1000)
      --pid string                  PID namespace to use
      --pids-limit int              Tune container pids limit (set -1 for unlimited)
      --privileged                  Give extended privileges to this container
  -p, --publish value               Publish a container's port(s) to the host (default [])
  -P, --publish-all                 Publish all exposed ports to random ports
      --read-only                   Mount the container's root filesystem as read only
      --restart string              Restart policy to apply when a container exits (default "no")
                                    Possible values are : no, on-failure[:max-retry], always, unless-stopped
      --rm                          Automatically remove the container when it exits
      --runtime string              Runtime to use for this container
      --security-opt value          Security Options (default [])
      --shm-size string             Size of /dev/shm, default value is 64MB.
                                    The format is `<number><unit>`. `number` must be greater than `0`.
                                    Unit is optional and can be `b` (bytes), `k` (kilobytes), `m` (megabytes),
                                    or `g` (gigabytes). If you omit the unit, the system uses bytes.
      --sig-proxy                   Proxy received signals to the process (default true)
      --stop-signal string          Signal to stop a container, SIGTERM by default (default "SIGTERM")
      --storage-opt value           Storage driver options for the container (default [])
      --sysctl value                Sysctl options (default map[])
      --tmpfs value                 Mount a tmpfs directory (default [])
  -t, --tty                         Allocate a pseudo-TTY
      --ulimit value                Ulimit options (default [])
  -u, --user string                 Username or UID (format: <name|uid>[:<group|gid>])
      --userns string               User namespace to use
                                    'host': Use the Docker host user namespace
                                    '': Use the Docker daemon user namespace specified by `--userns-remap` option.
      --uts string                  UTS namespace to use
  -v, --volume value                Bind mount a volume (default []). The format
                                    is `[host-src:]container-dest[:<options>]`.
                                    The comma-delimited `options` are [rw|ro],
                                    [z|Z], [[r]shared|[r]slave|[r]private], and
                                    [nocopy]. The 'host-src' is an absolute path
                                    or a name value.
      --volume-driver string        Optional volume driver for the container
      --volumes-from value          Mount volumes from the specified container(s) (default [])
  -w, --workdir string              Working directory inside the container
```

The `docker run` command first `creates` a writeable container layer over the
specified image, and then `starts` it using the specified command. That is,
`docker run` is equivalent to the API `/containers/create` then
`/containers/(id)/start`. A stopped container can be restarted with all its
previous changes intact using `docker start`. See `docker ps -a` to view a list
of all containers.

The `docker run` command can be used in combination with `docker commit` to
[*change the command that a container runs*](commit.md). There is additional detailed information about `docker run` in the [Docker run reference](../run.md).

For information on connecting a container to a network, see the ["*Docker network overview*"](../../userguide/networking/index.md).

## Examples

### Assign name and allocate pseudo-TTY (--name, -it)

    $ docker run --name test -it debian
    root@d6c0fe130dba:/# exit 13
    $ echo $?
    13
    $ docker ps -a | grep test
    d6c0fe130dba        debian:7            "/bin/bash"         26 seconds ago      Exited (13) 17 seconds ago                         test

This example runs a container named `test` using the `debian:latest`
image. The `-it` instructs Docker to allocate a pseudo-TTY connected to
the container's stdin; creating an interactive `bash` shell in the container.
In the example, the `bash` shell is quit by entering
`exit 13`. This exit code is passed on to the caller of
`docker run`, and is recorded in the `test` container's metadata.

### Capture container ID (--cidfile)

    $ docker run --cidfile /tmp/docker_test.cid ubuntu echo "test"

This will create a container and print `test` to the console. The `cidfile`
flag makes Docker attempt to create a new file and write the container ID to it.
If the file exists already, Docker will return an error. Docker will close this
file when `docker run` exits.

### Full container capabilities (--privileged)

    $ docker run -t -i --rm ubuntu bash
    root@bc338942ef20:/# mount -t tmpfs none /mnt
    mount: permission denied

This will *not* work, because by default, most potentially dangerous kernel
capabilities are dropped; including `cap_sys_admin` (which is required to mount
filesystems). However, the `--privileged` flag will allow it to run:

    $ docker run -t -i --privileged ubuntu bash
    root@50e3f57e16e6:/# mount -t tmpfs none /mnt
    root@50e3f57e16e6:/# df -h
    Filesystem      Size  Used Avail Use% Mounted on
    none            1.9G     0  1.9G   0% /mnt

The `--privileged` flag gives *all* capabilities to the container, and it also
lifts all the limitations enforced by the `device` cgroup controller. In other
words, the container can then do almost everything that the host can do. This
flag exists to allow special use-cases, like running Docker within Docker.

### Set working directory (-w)

    $ docker  run -w /path/to/dir/ -i -t  ubuntu pwd

The `-w` lets the command being executed inside directory given, here
`/path/to/dir/`. If the path does not exist it is created inside the container.

### Set storage driver options per container

    $ docker run -it --storage-opt size=120G fedora /bin/bash

This (size) will allow to set the container rootfs size to 120G at creation time.
User cannot pass a size less than the Default BaseFS Size. This option is only
available for the `devicemapper`, `btrfs`, and `zfs` graph drivers.

### Mount tmpfs (--tmpfs)

    $ docker run -d --tmpfs /run:rw,noexec,nosuid,size=65536k my_image

The `--tmpfs` flag mounts an empty tmpfs into the container with the `rw`,
`noexec`, `nosuid`, `size=65536k` options.

### Mount volume (-v, --read-only)

    $ docker  run  -v `pwd`:`pwd` -w `pwd` -i -t  ubuntu pwd

The `-v` flag mounts the current working directory into the container. The `-w`
lets the command being executed inside the current working directory, by
changing into the directory to the value returned by `pwd`. So this
combination executes the command using the container, but inside the
current working directory.

    $ docker run -v /doesnt/exist:/foo -w /foo -i -t ubuntu bash

When the host directory of a bind-mounted volume doesn't exist, Docker
will automatically create this directory on the host for you. In the
example above, Docker will create the `/doesnt/exist`
folder before starting your container.

    $ docker run --read-only -v /icanwrite busybox touch /icanwrite/here

Volumes can be used in combination with `--read-only` to control where
a container writes files. The `--read-only` flag mounts the container's root
filesystem as read only prohibiting writes to locations other than the
specified volumes for the container.

    $ docker run -t -i -v /var/run/docker.sock:/var/run/docker.sock -v /path/to/static-docker-binary:/usr/bin/docker busybox sh

By bind-mounting the docker unix socket and statically linked docker
binary (refer to [get the linux binary](
../../installation/binaries.md#get-the-linux-binary)),
you give the container the full access to create and manipulate the host's
Docker daemon.

On Windows, the paths must be specified using Windows-style semantics. 

    PS C:\> docker run -v c:\foo:c:\dest microsoft/nanoserver cmd /s /c type c:\dest\somefile.txt
    Contents of file
	
    PS C:\> docker run -v c:\foo:d: microsoft/nanoserver cmd /s /c type d:\somefile.txt
    Contents of file

The following examples will fail when using Windows-based containers, as the 
destination of a volume or bind-mount inside the container must be one of: 
a non-existing or empty directory; or a drive other than C:. Further, the source
of a bind mount must be a local directory, not a file.

    net use z: \\remotemachine\share
    docker run -v z:\foo:c:\dest ...
    docker run -v \\uncpath\to\directory:c:\dest ...
    docker run -v c:\foo\somefile.txt:c:\dest ...
    docker run -v c:\foo:c: ...
    docker run -v c:\foo:c:\existing-directory-with-contents ...

For in-depth information about volumes, refer to [manage data in containers](https://docs.docker.com/engine/tutorials/dockervolumes/)

### Publish or expose port (-p, --expose)

    $ docker run -p 127.0.0.1:80:8080 ubuntu bash

This binds port `8080` of the container to port `80` on `127.0.0.1` of the host
machine. The [Docker User
Guide](../../userguide/networking/default_network/dockerlinks.md)
explains in detail how to manipulate ports in Docker.

    $ docker run --expose 80 ubuntu bash

This exposes port `80` of the container without publishing the port to the host
system's interfaces.

### Set environment variables (-e, --env, --env-file)

    $ docker run -e MYVAR1 --env MYVAR2=foo --env-file ./env.list ubuntu bash

This sets simple (non-array) environmental variables in the container. For
illustration all three
flags are shown here. Where `-e`, `--env` take an environment variable and
value, or if no `=` is provided, then that variable's current value, set via
`export`, is passed through (i.e. `$MYVAR1` from the host is set to `$MYVAR1`
in the container). When no `=` is provided and that variable is not defined
in the client's environment then that variable will be removed from the
container's list of environment variables. All three flags, `-e`, `--env` and
`--env-file` can be repeated.

Regardless of the order of these three flags, the `--env-file` are processed
first, and then `-e`, `--env` flags. This way, the `-e` or `--env` will
override variables as needed.

    $ cat ./env.list
    TEST_FOO=BAR
    $ docker run --env TEST_FOO="This is a test" --env-file ./env.list busybox env | grep TEST_FOO
    TEST_FOO=This is a test

The `--env-file` flag takes a filename as an argument and expects each line
to be in the `VAR=VAL` format, mimicking the argument passed to `--env`. Comment
lines need only be prefixed with `#`

An example of a file passed with `--env-file`

    $ cat ./env.list
    TEST_FOO=BAR

    # this is a comment
    TEST_APP_DEST_HOST=10.10.0.127
    TEST_APP_DEST_PORT=8888
    _TEST_BAR=FOO
    TEST_APP_42=magic
    helloWorld=true
    123qwe=bar
    org.spring.config=something

    # pass through this variable from the caller
    TEST_PASSTHROUGH
    $ TEST_PASSTHROUGH=howdy docker run --env-file ./env.list busybox env
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    HOSTNAME=5198e0745561
    TEST_FOO=BAR
    TEST_APP_DEST_HOST=10.10.0.127
    TEST_APP_DEST_PORT=8888
    _TEST_BAR=FOO
    TEST_APP_42=magic
    helloWorld=true
    TEST_PASSTHROUGH=howdy
    HOME=/root
    123qwe=bar
    org.spring.config=something

    $ docker run --env-file ./env.list busybox env
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    HOSTNAME=5198e0745561
    TEST_FOO=BAR
    TEST_APP_DEST_HOST=10.10.0.127
    TEST_APP_DEST_PORT=8888
    _TEST_BAR=FOO
    TEST_APP_42=magic
    helloWorld=true
    TEST_PASSTHROUGH=
    HOME=/root
    123qwe=bar
    org.spring.config=something

### Set metadata on container (-l, --label, --label-file)

A label is a `key=value` pair that applies metadata to a container. To label a container with two labels:

    $ docker run -l my-label --label com.example.foo=bar ubuntu bash

The `my-label` key doesn't specify a value so the label defaults to an empty
string(`""`). To add multiple labels, repeat the label flag (`-l` or `--label`).

The `key=value` must be unique to avoid overwriting the label value. If you
specify labels with identical keys but different values, each subsequent value
overwrites the previous. Docker uses the last `key=value` you supply.

Use the `--label-file` flag to load multiple labels from a file. Delimit each
label in the file with an EOL mark. The example below loads labels from a
labels file in the current directory:

    $ docker run --label-file ./labels ubuntu bash

The label-file format is similar to the format for loading environment
variables. (Unlike environment variables, labels are not visible to processes
running inside a container.) The following example illustrates a label-file
format:

    com.example.label1="a label"

    # this is a comment
    com.example.label2=another\ label
    com.example.label3

You can load multiple label-files by supplying multiple  `--label-file` flags.

For additional information on working with labels, see [*Labels - custom
metadata in Docker*](../../userguide/labels-custom-metadata.md) in the Docker User
Guide.

### Connect a container to a network (--network)

When you start a container use the `--network` flag to connect it to a network.
This adds the `busybox` container to the `my-net` network.

```bash
$ docker run -itd --network=my-net busybox
```

You can also choose the IP addresses for the container with `--ip` and `--ip6`
flags when you start the container on a user-defined network.

```bash
$ docker run -itd --network=my-net --ip=10.10.9.75 busybox
```

If you want to add a running container to a network use the `docker network connect` subcommand.

You can connect multiple containers to the same network. Once connected, the
containers can communicate easily need only another container's IP address
or name. For `overlay` networks or custom plugins that support multi-host
connectivity, containers connected to the same multi-host network but launched
from different Engines can also communicate in this way.

**Note**: Service discovery is unavailable on the default bridge network.
Containers can communicate via their IP addresses by default. To communicate
by name, they must be linked.

You can disconnect a container from a network using the `docker network
disconnect` command.

### Mount volumes from container (--volumes-from)

    $ docker run --volumes-from 777f7dc92da7 --volumes-from ba8c0c54f0f2:ro -i -t ubuntu pwd

The `--volumes-from` flag mounts all the defined volumes from the referenced
containers. Containers can be specified by repetitions of the `--volumes-from`
argument. The container ID may be optionally suffixed with `:ro` or `:rw` to
mount the volumes in read-only or read-write mode, respectively. By default,
the volumes are mounted in the same mode (read write or read only) as
the reference container.

Labeling systems like SELinux require that proper labels are placed on volume
content mounted into a container. Without a label, the security system might
prevent the processes running inside the container from using the content. By
default, Docker does not change the labels set by the OS.

To change the label in the container context, you can add either of two suffixes
`:z` or `:Z` to the volume mount. These suffixes tell Docker to relabel file
objects on the shared volumes. The `z` option tells Docker that two containers
share the volume content. As a result, Docker labels the content with a shared
content label. Shared volume labels allow all containers to read/write content.
The `Z` option tells Docker to label the content with a private unshared label.
Only the current container can use a private volume.

### Attach to STDIN/STDOUT/STDERR (-a)

The `-a` flag tells `docker run` to bind to the container's `STDIN`, `STDOUT`
or `STDERR`. This makes it possible to manipulate the output and input as
needed.

    $ echo "test" | docker run -i -a stdin ubuntu cat -

This pipes data into a container and prints the container's ID by attaching
only to the container's `STDIN`.

    $ docker run -a stderr ubuntu echo test

This isn't going to print anything unless there's an error because we've
only attached to the `STDERR` of the container. The container's logs
still store what's been written to `STDERR` and `STDOUT`.

    $ cat somefile | docker run -i -a stdin mybuilder dobuild

This is how piping a file into a container could be done for a build.
The container's ID will be printed after the build is done and the build
logs could be retrieved using `docker logs`. This is
useful if you need to pipe a file or something else into a container and
retrieve the container's ID once the container has finished running.

### Add host device to container (--device)

    $ docker run --device=/dev/sdc:/dev/xvdc --device=/dev/sdd --device=/dev/zero:/dev/nulo -i -t ubuntu ls -l /dev/{xvdc,sdd,nulo}
    brw-rw---- 1 root disk 8, 2 Feb  9 16:05 /dev/xvdc
    brw-rw---- 1 root disk 8, 3 Feb  9 16:05 /dev/sdd
    crw-rw-rw- 1 root root 1, 5 Feb  9 16:05 /dev/nulo

It is often necessary to directly expose devices to a container. The `--device`
option enables that. For example, a specific block storage device or loop
device or audio device can be added to an otherwise unprivileged container
(without the `--privileged` flag) and have the application directly access it.

By default, the container will be able to `read`, `write` and `mknod` these devices.
This can be overridden using a third `:rwm` set of options to each `--device`
flag:


    $ docker run --device=/dev/sda:/dev/xvdc --rm -it ubuntu fdisk  /dev/xvdc

    Command (m for help): q
    $ docker run --device=/dev/sda:/dev/xvdc:r --rm -it ubuntu fdisk  /dev/xvdc
    You will not be able to write the partition table.

    Command (m for help): q

    $ docker run --device=/dev/sda:/dev/xvdc:rw --rm -it ubuntu fdisk  /dev/xvdc

    Command (m for help): q

    $ docker run --device=/dev/sda:/dev/xvdc:m --rm -it ubuntu fdisk  /dev/xvdc
    fdisk: unable to open /dev/xvdc: Operation not permitted

> **Note:**
> `--device` cannot be safely used with ephemeral devices. Block devices
> that may be removed should not be added to untrusted containers with
> `--device`.

### Restart policies (--restart)

Use Docker's `--restart` to specify a container's *restart policy*. A restart
policy controls whether the Docker daemon restarts a container after exit.
Docker supports the following restart policies:

<table>
  <thead>
    <tr>
      <th>Policy</th>
      <th>Result</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>no</strong></td>
      <td>
        Do not automatically restart the container when it exits. This is the
        default.
      </td>
    </tr>
    <tr>
      <td>
        <span style="white-space: nowrap">
          <strong>on-failure</strong>[:max-retries]
        </span>
      </td>
      <td>
        Restart only if the container exits with a non-zero exit status.
        Optionally, limit the number of restart retries the Docker
        daemon attempts.
      </td>
    </tr>
    <tr>
      <td><strong>always</strong></td>
      <td>
        Always restart the container regardless of the exit status.
        When you specify always, the Docker daemon will try to restart
        the container indefinitely. The container will also always start
        on daemon startup, regardless of the current state of the container.
      </td>
    </tr>
    <tr>
      <td><strong>unless-stopped</strong></td>
      <td>
        Always restart the container regardless of the exit status, but
        do not start it on daemon startup if the container has been put
        to a stopped state before.
      </td>
    </tr>
  </tbody>
</table>

    $ docker run --restart=always redis

This will run the `redis` container with a restart policy of **always**
so that if the container exits, Docker will restart it.

More detailed information on restart policies can be found in the
[Restart Policies (--restart)](../run.md#restart-policies-restart)
section of the Docker run reference page.

### Add entries to container hosts file (--add-host)

You can add other hosts into a container's `/etc/hosts` file by using one or
more `--add-host` flags. This example adds a static address for a host named
`docker`:

    $ docker run --add-host=docker:10.180.0.1 --rm -it debian
    root@f38c87f2a42d:/# ping docker
    PING docker (10.180.0.1): 48 data bytes
    56 bytes from 10.180.0.1: icmp_seq=0 ttl=254 time=7.600 ms
    56 bytes from 10.180.0.1: icmp_seq=1 ttl=254 time=30.705 ms
    ^C--- docker ping statistics ---
    2 packets transmitted, 2 packets received, 0% packet loss
    round-trip min/avg/max/stddev = 7.600/19.152/30.705/11.553 ms

Sometimes you need to connect to the Docker host from within your
container. To enable this, pass the Docker host's IP address to
the container using the `--add-host` flag. To find the host's address,
use the `ip addr show` command.

The flags you pass to `ip addr show` depend on whether you are
using IPv4 or IPv6 networking in your containers. Use the following
flags for IPv4 address retrieval for a network device named `eth0`:

    $ HOSTIP=`ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1`
    $ docker run  --add-host=docker:${HOSTIP} --rm -it debian

For IPv6 use the `-6` flag instead of the `-4` flag. For other network
devices, replace `eth0` with the correct device name (for example `docker0`
for the bridge device).

### Set ulimits in container (--ulimit)

Since setting `ulimit` settings in a container requires extra privileges not
available in the default container, you can set these using the `--ulimit` flag.
`--ulimit` is specified with a soft and hard limit as such:
`<type>=<soft limit>[:<hard limit>]`, for example:

    $ docker run --ulimit nofile=1024:1024 --rm debian sh -c "ulimit -n"
    1024

> **Note:**
> If you do not provide a `hard limit`, the `soft limit` will be used
> for both values. If no `ulimits` are set, they will be inherited from
> the default `ulimits` set on the daemon.  `as` option is disabled now.
> In other words, the following script is not supported:
> `$ docker run -it --ulimit as=1024 fedora /bin/bash`

The values are sent to the appropriate `syscall` as they are set.
Docker doesn't perform any byte conversion. Take this into account when setting the values.

#### For `nproc` usage

Be careful setting `nproc` with the `ulimit` flag as `nproc` is designed by Linux to set the
maximum number of processes available to a user, not to a container.  For example, start four
containers with `daemon` user:

    docker run -d -u daemon --ulimit nproc=3 busybox top
    docker run -d -u daemon --ulimit nproc=3 busybox top
    docker run -d -u daemon --ulimit nproc=3 busybox top
    docker run -d -u daemon --ulimit nproc=3 busybox top

The 4th container fails and reports "[8] System error: resource temporarily unavailable" error.
This fails because the caller set `nproc=3` resulting in the first three containers using up
the three processes quota set for the `daemon` user.

### Stop container with signal (--stop-signal)

The `--stop-signal` flag sets the system call signal that will be sent to the container to exit.
This signal can be a valid unsigned number that matches a position in the kernel's syscall table, for instance 9,
or a signal name in the format SIGNAME, for instance SIGKILL.

### Specify isolation technology for container (--isolation)

This option is useful in situations where you are running Docker containers on
Microsoft Windows. The `--isolation <value>` option sets a container's isolation
technology. On Linux, the only supported is the `default` option which uses
Linux namespaces. These two commands are equivalent on Linux:

```
$ docker run -d busybox top
$ docker run -d --isolation default busybox top
```

On Microsoft Windows, can take any of these values:


| Value     | Description                                                                                                                                                   |
|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `default` | Use the value specified by the Docker daemon's `--exec-opt` . If the `daemon` does not specify an isolation technology, Microsoft Windows uses `process` as its default value.  |
| `process` | Namespace isolation only.                                                                                                                                     |
| `hyperv`   | Hyper-V hypervisor partition-based isolation.                                                                                                                  |

On Windows, the default isolation for client is `hyperv`, and for server is
`process`. Therefore when running on Windows server without a `daemon` option
set, these two commands are equivalent:
```
$ docker run -d --isolation default busybox top
$ docker run -d --isolation process busybox top
```

If you have set the `--exec-opt isolation=hyperv` option on the Docker `daemon`,
if running on Windows server, any of these commands also result in `hyperv` isolation:

```
$ docker run -d --isolation default busybox top
$ docker run -d --isolation hyperv busybox top
```

### Configure namespaced kernel parameters (sysctls) at runtime

The `--sysctl` sets namespaced kernel parameters (sysctls) in the
container. For example, to turn on IP forwarding in the containers
network namespace, run this command:

    $ docker run --sysctl net.ipv4.ip_forward=1 someimage


> **Note**: Not all sysctls are namespaced. Docker does not support changing sysctls
> inside of a container that also modify the host system. As the kernel
> evolves we expect to see more sysctls become namespaced.

#### Currently supported sysctls

  `IPC Namespace`:

  kernel.msgmax, kernel.msgmnb, kernel.msgmni, kernel.sem, kernel.shmall, kernel.shmmax, kernel.shmmni, kernel.shm_rmid_forced
  Sysctls beginning with fs.mqueue.*

  If you use the `--ipc=host` option these sysctls will not be allowed.

  `Network Namespace`:
      Sysctls beginning with net.*

  If you use the `--network=host` option using these sysctls will not be allowed.
                                                                                                                                                                                                                                                                                               go/src/github.com/docker/docker/docs/reference/commandline/save.md                                  0100644 0000000 0000000 00000002040 13101060260 023633  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/save/
description: The save command description and usage
keywords:
- tarred, repository, backup
title: docker save
---

```markdown
Usage:  docker save [OPTIONS] IMAGE [IMAGE...]

Save one or more images to a tar archive (streamed to STDOUT by default)

Options:
      --help            Print usage
  -o, --output string   Write to a file, instead of STDOUT
```

Produces a tarred repository to the standard output stream.
Contains all parent layers, and all tags + versions, or specified `repo:tag`, for
each argument provided.

It is used to create a backup that can then be used with `docker load`

    $ docker save busybox > busybox.tar
    $ ls -sh busybox.tar
    2.7M busybox.tar
    $ docker save --output busybox.tar busybox
    $ ls -sh busybox.tar
    2.7M busybox.tar
    $ docker save -o fedora-all.tar fedora
    $ docker save -o fedora-latest.tar fedora:latest

It is even useful to cherry-pick particular tags of an image repository

    $ docker save -o ubuntu.tar ubuntu:lucid ubuntu:saucy
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                go/src/github.com/docker/docker/docs/reference/commandline/search.md                                0100644 0000000 0000000 00000015141 13101060260 024150  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/search/
description: The search command description and usage
keywords:
- search, hub, images
title: docker search
---

```markdown
Usage:  docker search [OPTIONS] TERM

Search the Docker Hub for images

Options:
  -f, --filter value   Filter output based on conditions provided (default [])
                       - is-automated=(true|false)
                       - is-official=(true|false)
                       - stars=<number> - image has at least 'number' stars
      --help           Print usage
      --limit int      Max number of search results (default 25)
      --no-trunc       Don't truncate output
```

Search [Docker Hub](https://hub.docker.com) for images

See [*Find Public Images on Docker Hub*](../../tutorials/dockerrepos.md#searching-for-images) for
more details on finding shared images from the command line.

> **Note:**
> Search queries will only return up to 25 results

## Examples

### Search images by name

This example displays images with a name containing 'busybox':

    $ docker search busybox
    NAME                             DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
    busybox                          Busybox base image.                             316       [OK]
    progrium/busybox                                                                 50                   [OK]
    radial/busyboxplus               Full-chain, Internet enabled, busybox made...   8                    [OK]
    odise/busybox-python                                                             2                    [OK]
    azukiapp/busybox                 This image is meant to be used as the base...   2                    [OK]
    ofayau/busybox-jvm               Prepare busybox to install a 32 bits JVM.       1                    [OK]
    shingonoide/archlinux-busybox    Arch Linux, a lightweight and flexible Lin...   1                    [OK]
    odise/busybox-curl                                                               1                    [OK]
    ofayau/busybox-libc32            Busybox with 32 bits (and 64 bits) libs         1                    [OK]
    peelsky/zulu-openjdk-busybox                                                     1                    [OK]
    skomma/busybox-data              Docker image suitable for data volume cont...   1                    [OK]
    elektritter/busybox-teamspeak    Lightweight teamspeak3 container based on...    1                    [OK]
    socketplane/busybox                                                              1                    [OK]
    oveits/docker-nginx-busybox      This is a tiny NginX docker image based on...   0                    [OK]
    ggtools/busybox-ubuntu           Busybox ubuntu version with extra goodies       0                    [OK]
    nikfoundas/busybox-confd         Minimal busybox based distribution of confd     0                    [OK]
    openshift/busybox-http-app                                                       0                    [OK]
    jllopis/busybox                                                                  0                    [OK]
    swyckoff/busybox                                                                 0                    [OK]
    powellquiring/busybox                                                            0                    [OK]
    williamyeh/busybox-sh            Docker image for BusyBox's sh                   0                    [OK]
    simplexsys/busybox-cli-powered   Docker busybox images, with a few often us...   0                    [OK]
    fhisamoto/busybox-java           Busybox java                                    0                    [OK]
    scottabernethy/busybox                                                           0                    [OK]
    marclop/busybox-solr

### Display non-truncated description (--no-trunc)

This example displays images with a name containing 'busybox',
at least 3 stars and the description isn't truncated in the output:

    $ docker search --stars=3 --no-trunc busybox
    NAME                 DESCRIPTION                                                                               STARS     OFFICIAL   AUTOMATED
    busybox              Busybox base image.                                                                       325       [OK]
    progrium/busybox                                                                                               50                   [OK]
    radial/busyboxplus   Full-chain, Internet enabled, busybox made from scratch. Comes in git and cURL flavors.   8                    [OK]

## Limit search results (--limit)

The flag `--limit` is the maximum number of results returned by a search. This value could
be in the range between 1 and 100. The default value of `--limit` is 25.


## Filtering

The filtering flag (`-f` or `--filter`) format is a `key=value` pair. If there is more
than one filter, then pass multiple flags (e.g. `--filter "foo=bar" --filter "bif=baz"`)

The currently supported filters are:

* stars (int - number of stars the image has)
* is-automated (true|false) - is the image automated or not
* is-official (true|false) - is the image official or not


### stars

This example displays images with a name containing 'busybox' and at
least 3 stars:

    $ docker search --filter stars=3 busybox
    NAME                 DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
    busybox              Busybox base image.                             325       [OK]
    progrium/busybox                                                     50                   [OK]
    radial/busyboxplus   Full-chain, Internet enabled, busybox made...   8                    [OK]


### is-automated

This example displays images with a name containing 'busybox'
and are automated builds:

    $ docker search --filter is-automated busybox
    NAME                 DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
    progrium/busybox                                                     50                   [OK]
    radial/busyboxplus   Full-chain, Internet enabled, busybox made...   8                    [OK]

### is-official

This example displays images with a name containing 'busybox', at least
3 stars and are official builds:

    $ docker search --filter "is-official=true" --filter "stars=3" busybox
    NAME                 DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
    progrium/busybox                                                     50                   [OK]
    radial/busyboxplus   Full-chain, Internet enabled, busybox made...   8                    [OK]
                                                                                                                                                                                                                                                                                                                                                                                                                               go/src/github.com/docker/docker/docs/reference/commandline/service_create.md                        0100644 0000000 0000000 00000051453 13101060260 025674  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/service_create/
description: The service create command description and usage
keywords:
- service, create
title: docker service create
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```Markdown
Usage:  docker service create [OPTIONS] IMAGE [COMMAND] [ARG...]

Create a new service

Options:
      --constraint value               Placement constraints (default [])
      --container-label value          Service container labels (default [])
      --endpoint-mode string           Endpoint mode (vip or dnsrr)
  -e, --env value                      Set environment variables (default [])
      --help                           Print usage
  -l, --label value                    Service labels (default [])
      --limit-cpu value                Limit CPUs (default 0.000)
      --limit-memory value             Limit Memory (default 0 B)
      --log-driver string              Logging driver for service
      --log-opt value                  Logging driver options (default [])
      --mode string                    Service mode (replicated or global) (default "replicated")
      --mount value                    Attach a mount to the service
      --name string                    Service name
      --network value                  Network attachments (default [])
  -p, --publish value                  Publish a port as a node port (default [])
      --replicas value                 Number of tasks (default none)
      --reserve-cpu value              Reserve CPUs (default 0.000)
      --reserve-memory value           Reserve Memory (default 0 B)
      --restart-condition string       Restart when condition is met (none, on-failure, or any)
      --restart-delay value            Delay between restart attempts (default none)
      --restart-max-attempts value     Maximum number of restarts before giving up (default none)
      --restart-window value           Window used to evaluate the restart policy (default none)
      --stop-grace-period value        Time to wait before force killing a container (default none)
      --update-delay duration          Delay between updates
      --update-failure-action string   Action on update failure (pause|continue) (default "pause")
      --update-parallelism uint        Maximum number of tasks updated simultaneously (0 to update all at once) (default 1)
  -u, --user string                    Username or UID
      --with-registry-auth             Send registry authentication details to Swarm agents
  -w, --workdir string                 Working directory inside the container
```

Creates a service as described by the specified parameters. You must run this
command on a manager node.

## Examples

### Create a service

```bash
$ docker service create --name redis redis:3.0.6
dmu1ept4cxcfe8k8lhtux3ro3

$ docker service ls
ID            NAME   REPLICAS  IMAGE        COMMAND
dmu1ept4cxcf  redis  1/1       redis:3.0.6
```

### Create a service with 5 replica tasks (--replicas)

Use the `--replicas` flag to set the number of replica tasks for a replicated
service. The following command creates a `redis` service with `5` replica tasks:

```bash
$ docker service create --name redis --replicas=5 redis:3.0.6
4cdgfyky7ozwh3htjfw0d12qv
```

The above command sets the *desired* number of tasks for the service. Even
though the command returns immediately, actual scaling of the service may take
some time. The `REPLICAS` column shows both the *actual* and *desired* number
of replica tasks for the service.

In the following example the desired state is  `5` replicas, but the current
number of `RUNNING` tasks is `3`:

```bash
$ docker service ls
ID            NAME    REPLICAS  IMAGE        COMMAND
4cdgfyky7ozw  redis   3/5       redis:3.0.7
```

Once all the tasks are created and `RUNNING`, the actual number of tasks is
equal to the desired number:

```bash
$ docker service ls
ID            NAME    REPLICAS  IMAGE        COMMAND
4cdgfyky7ozw  redis   5/5       redis:3.0.7
```

### Create a service with a rolling update policy

```bash
$ docker service create \
  --replicas 10 \
  --name redis \
  --update-delay 10s \
  --update-parallelism 2 \
  redis:3.0.6
```

When you run a [service update](service_update.md), the scheduler updates a
maximum of 2 tasks at a time, with `10s` between updates. For more information,
refer to the [rolling updates
tutorial](../../swarm/swarm-tutorial/rolling-update.md).

### Set environment variables (-e, --env)

This sets environmental variables for all tasks in a service. For example:

```bash
$ docker service create --name redis_2 --replicas 5 --env MYVAR=foo redis:3.0.6
```

### Set metadata on a service (-l, --label)

A label is a `key=value` pair that applies metadata to a service. To label a
service with two labels:

```bash
$ docker service create \
  --name redis_2 \
  --label com.example.foo="bar"
  --label bar=baz \
  redis:3.0.6
```

For more information about labels, refer to [apply custom
metadata](../../userguide/labels-custom-metadata.md).

### Add bind-mounts or volumes

Docker supports two different kinds of mounts, which allow containers to read to
or write from files or directories on other containers or the host operating
system. These types are _data volumes_ (often referred to simply as volumes) and
_bind-mounts_.

A **bind-mount** makes a file or directory on the host available to the
container it is mounted within. A bind-mount may be either read-only or
read-write. For example, a container might share its host's DNS information by
means of a bind-mount of the host's `/etc/resolv.conf` or a container might
write logs to its host's `/var/log/myContainerLogs` directory. If you use
bind-mounts and your host and containers have different notions of permissions,
access controls, or other such details, you will run into portability issues.

A **named volume** is a mechanism for decoupling persistent data needed by your
container from the image used to create the container and from the host machine.
Named volumes are created and managed by Docker, and a named volume persists
even when no container is currently using it. Data in named volumes can be
shared between a container and the host machine, as well as between multiple
containers. Docker uses a _volume driver_ to create, manage, and mount volumes.
You can back up or restore volumes using Docker commands.

Consider a situation where your image starts a lightweight web server. You could
use that image as a base image, copy in your website's HTML files, and package
that into another image. Each time your website changed, you'd need to update
the new image and redeploy all of the containers serving your website. A better
solution is to store the website in a named volume which is attached to each of
your web server containers when they start. To update the website, you just
update the named volume.

For more information about named volumes, see
[Data Volumes](/engine/tutorials/dockervolumes/).

The following table describes options which apply to both bind-mounts and named
volumes in a service:

<table>
<thead>
<tr>
<th align="left">Option</th>
<th align="left">Required</th>
<th align="left">Description</th>
</tr>
</thead>

<tbody>
<tr>
<td align="left"><strong>type</strong></td>
<td align="left"></td>
<td align="left">The type of mount, can be either <code>volume</code>, or <code>bind</code>. Defaults to <code>volume</code> if no type is specified.<ul><li><code>volume</code>: mounts a <a href="../../../../engine/reference/commandline/volume_create/">managed volume</a> into the container.</li><li><code>bind</code>: bind-mounts a directory or file from the host into the container.</li></ul></td>
</tr>

<tr>
<td align="left"><strong>src</strong> or <strong>source</strong></td>
<td align="left">for <code>type=bind</code>&nbsp;only</td>
<td align="left"><ul><li><code>type=volume</code>: <code>src</code> is an optional way to specify the name of the volume (for example, <code>src=my-volume</code>). If the named volume does not exist, it is automatically created. If no <code>src</code> is specified, the volume is assigned a random name which is guaranteed to be unique on the host, but may not be unique cluster-wide. A randomly-named volume has the same lifecycle as its container and is destroyed when the <em>container</em> is destroyed (which is upon <code>service update</code>, or when scaling or re-balancing the service).</li><li><code>type=bind</code>: <code>src</code> is required, and specifies an absolute path to the file or directory to bind-mount (for example, <code>src=/path/on/host/</code>).  An error is produced if the file or directory does not exist.</li></ul></td>
</tr>

<tr>
<td align="left"><strong>dst</strong> or <strong>destination</strong> or <strong>target</strong></td>
<td align="left">yes</td>
<td align="left">Mount path inside the container, for example <code>/some/path/in/container/</code>. If the path does not exist in the container&rsquo;s filesystem, the Engine creates a directory at the specified location before mounting the volume or bind-mount.</td>
</tr>

<tr>
<td align="left"><strong>readonly</strong> or <strong>ro</strong></td>
<td align="left"></td>
<td align="left">The Engine mounts binds and volumes <code>read-write</code> unless <code>readonly</code> option is given when mounting the bind or volume.<br /><br /><ul><li><code>true</code> or <code>1</code> or no value: Mounts the bind or volume read-only.</li><li><code>false</code> or <code>0</code>: Mounts the bind or volume read-write.</li></ul></td>
</tr>
</tbody>
</table>

#### Bind Propagation

Bind propagation refers to whether or not mounts created within a given
bind-mount or named volume can be propagated to replicas of that mount. Consider
a mount point `/mnt`, which is also mounted on `/tmp`. The propagation settings
control whether a mount on `/tmp/a` would also be available on `/mnt/a`. Each
propagation setting has a recursive counterpoint. In the case of recursion,
consider that `/tmp/a` is also mounted as `/foo`. The propagation settings
control whether `/mnt/a` and/or `/tmp/a` would exist.

The `bind-propagation` option defaults to `rprivate` for both bind-mounts and
volume mounts, and is only configurable for bind-mounts. In other words, named
volumes do not support bind propagation.

- **`shared`**: Sub-mounts of the original mount are exposed to replica mounts,
                and sub-mounts of replica mounts are also propagated to the
                original mount.
- **`slave`**: similar to a shared mount, but only in one direction. If the
               original mount exposes a sub-mount, the replica mount can see it.
               However, if the replica mount exposes a sub-mount, the original
               mount cannot see it.
- **`private`**: The mount is private. Sub-mounts within it are not exposed to
                 replica mounts, and sub-mounts of replica mounts are not
                 exposed to the original mount.
- **`rshared`**: The same as shared, but the propagation also extends to and from
                 mount points nested within any of the original or replica mount
                 points.
- **`rslave`**: The same as `slave`, but the propagation also extends to and from
                 mount points nested within any of the original or replica mount
                 points.
- **`rprivate`**: The default. The same as `private`, meaning that no mount points
                  anywhere within the original or replica mount points propagate
                  in either direction.

For more information about bind propagation, see the
[Linux kernel documentation for shared subtree](https://www.kernel.org/doc/Documentation/filesystems/sharedsubtree.txt).

#### Options for Named Volumes
The following options can only be used for named volumes (`type=volume`);

<table>
<thead>
<tr>
<th align="left">Option</th>
<th align="left">Description</th>
</tr>
</thead>

<tbody>
<tr>
<td align="left"><strong>volume-driver</strong></td>
<td align="left">Name of the volume-driver plugin to use for the volume. Defaults to <code>&quot;local&quot;</code>, to use the local volume driver to create the volume if the volume does not exist.</td>
</tr>

<tr>
<td align="left"><strong>volume-label</strong></td>
<td align="left">One or more custom metadata (&ldquo;labels&rdquo;) to apply to the volume upon creation. For example, <code>volume-label=mylabel=hello-world,my-other-label=hello-mars</code>. For more information about labels, refer to <a href="../../../../engine/userguide/labels-custom-metadata/">apply custom metadata</a>.</td>
</tr>

<tr>
<td align="left"><strong>volume-nocopy</strong></td>
<td align="left">By default, if you attach an empty volume to a container, and files or directories already existed at the mount-path in the container (<code>dst</code>), the Engine copies those files and directories into the volume, allowing the host to access them. Set <code>volume-nocopy</code> to disables copying files from the container&rsquo;s filesystem to the volume and mount the empty volume.<br /><br />A value is optional:<ul><li><code>true</code> or <code>1</code>: Default if you do not provide a value. Disables copying.</li><li><code>false</code> or <code>0</code>: Enables copying.</li></ul></td>
</tr>

<tr>
<td align="left"><strong>volume-opt</strong></td>
<td align="left">Options specific to a given volume driver, which will be passed to the driver when creating the volume. Options are provided as a comma-separated list of key/value pairs, for example, <code>volume-opt=some-option=some-value,some-other-option=some-other-value</code>. For available options for a given driver, refer to that driver&rsquo;s documentation.</td>
</tr>
</tbody>
</table>


#### Differences between "--mount" and "--volume"

The `--mount` flag supports most options that are supported by the `-v`
or `--volume` flag for `docker run`, with some important exceptions:

- The `--mount` flag allows you to specify a volume driver and volume driver
    options *per volume*, without creating the volumes in advance. In contrast,
    `docker run` allows you to specify a single volume driver which is shared
    by all volumes, using the `--volume-driver` flag.

- The `--mount` flag allows you to specify custom metadata ("labels") for a volume,
    before the volume is created.

- When you use `--mount` with `type=bind`, the host-path must refer to an *existing*
    path on the host. The path will not be created for you and the service will fail
    with an error if the path does not exist.

- The `--mount` flag does not allow you to relabel a volume with `Z` or `z` flags,
    which are used for `selinux` labeling.

#### Create a service using a named volume

The following example creates a service that uses a named volume:

```bash
$ docker service create \
  --name my-service \
  --replicas 3 \
  --mount type=volume,source=my-volume,destination=/path/in/container,volume-label="color=red",volume-label="shape=round" \
  nginx:alpine
```

For each replica of the service, the engine requests a volume named "my-volume"
from the default ("local") volume driver where the task is deployed. If the
volume does not exist, the engine creates a new volume and applies the "color"
and "shape" labels.

When the task is started, the volume is mounted on `/path/in/container/` inside
the container.

Be aware that the default ("local") volume is a locally scoped volume driver.
This means that depending on where a task is deployed, either that task gets a
*new* volume named "my-volume", or shares the same "my-volume" with other tasks
of the same service. Multiple containers writing to a single shared volume can
cause data corruption if the software running inside the container is not
designed to handle concurrent processes writing to the same location. Also take
into account that containers can be re-scheduled by the Swarm orchestrator and
be deployed on a different node.

#### Create a service that uses an anonymous volume

The following command creates a service with three replicas with an anonymous
volume on `/path/in/container`:

```bash
$ docker service create \
  --name my-service \
  --replicas 3 \
  --mount type=volume,destination=/path/in/container \
  nginx:alpine
```

In this example, no name (`source`) is specified for the volume, so a new volume
is created for each task. This guarantees that each task gets its own volume,
and volumes are not shared between tasks. Anonymous volumes are removed after
the task using them is complete.

#### Create a service that uses a bind-mounted host directory

The following example bind-mounts a host directory at `/path/in/container` in
the containers backing the service:

```bash
$ docker service create \
  --name my-service \
  --mount type=bind,source=/path/on/host,destination=/path/in/container \
  nginx:alpine
```

### Set service mode (--mode)

The service mode determines whether this is a _replicated_ service or a _global_
service. A replicated service runs as many tasks as specified, while a global
service runs on each active node in the swarm.

The following command creates a global service:

```bash
$ docker service create \
 --name redis_2 \
 --mode global \
 redis:3.0.6
```

### Specify service constraints (--constraint)

You can limit the set of nodes where a task can be scheduled by defining
constraint expressions. Multiple constraints find nodes that satisfy every
expression (AND match). Constraints can match node or Docker Engine labels as
follows:

| node attribute  | matches                   | example                                         |
|:----------------|:--------------------------|:------------------------------------------------|
| node.id         | node ID                   | `node.id == 2ivku8v2gvtg4`                      |
| node.hostname   | node hostname             | `node.hostname != node-2`                       |
| node.role       | node role: manager        | `node.role == manager`                          |
| node.labels     | user defined node labels  | `node.labels.security == high`                  |
| engine.labels   | Docker Engine's labels    | `engine.labels.operatingsystem == ubuntu 14.04` |

`engine.labels` apply to Docker Engine labels like operating system,
drivers, etc. Swarm administrators add `node.labels` for operational purposes by
using the [`docker node update`](node_update.md) command.

For example, the following limits tasks for the redis service to nodes where the
node type label equals queue:

```bash
$ docker service create \
  --name redis_2 \
  --constraint 'node.labels.type == queue' \
  redis:3.0.6
```

### Attach a service to an existing network (--network)

You can use overlay networks to connect one or more services within the swarm.

First, create an overlay network on a manager node the docker network create
command:

```bash
$ docker network create --driver overlay my-network

etjpu59cykrptrgw0z0hk5snf
```

After you create an overlay network in swarm mode, all manager nodes have
access to the network.

When you create a service and pass the --network flag to attach the service to
the overlay network:

```bash
$ docker service create \
  --replicas 3 \
  --network my-network \
  --name my-web \
  nginx

716thylsndqma81j6kkkb5aus
```

The swarm extends my-network to each node running the service.

Containers on the same network can access each other using
[service discovery](../../swarm/networking.md#use-swarm-mode-service-discovery).

### Publish service ports externally to the swarm (-p, --publish)

You can publish service ports to make them available externally to the swarm
using the `--publish` flag:

```bash
$ docker service create --publish <TARGET-PORT>:<SERVICE-PORT> nginx
```

For example:

```bash
$ docker service create --name my_web --replicas 3 --publish 8080:80 nginx
```

When you publish a service port, the swarm routing mesh makes the service
accessible at the target port on every node regardless if there is a task for
the service running on the node. For more information refer to
[Use swarm mode routing mesh](https://docs.docker.com/engine/swarm/ingress/).

### Publish a port for TCP only or UCP only

By default, when you publish a port, it is a TCP port. You can
specifically publish a UDP port instead of or in addition to a TCP port. When
you publish both TCP and UDP ports, Docker 1.12.2 and earlier require you to
add the suffix `/tcp` for TCP ports. Otherwise it is optional.

#### TCP only

The following two commands are equivalent.

```bash
$ docker service create --name dns-cache -p 53:53 dns-cache

$ docker service create --name dns-cache -p 53:53/tcp dns-cache
```

#### TCP and UDP

```bash
$ docker service create --name dns-cache -p 53:53/tcp -p 53:53/udp dns-cache
```

#### UDP only

```bash
$ docker service create --name dns-cache -p 53:53/udp dns-cache
```

## Related information

* [service inspect](service_inspect.md)
* [service ls](service_ls.md)
* [service rm](service_rm.md)
* [service scale](service_scale.md)
* [service ps](service_ps.md)
* [service update](service_update.md)

<style>table tr > td:first-child { white-space: nowrap;}</style>
                                                                                                                                                                                                                     go/src/github.com/docker/docker/docs/reference/commandline/service_inspect.md                       0100644 0000000 0000000 00000007153 13101060260 026074  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/service_inspect/
description: The service inspect command description and usage
keywords:
- service, inspect
title: docker service inspect
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```Markdown
Usage:  docker service inspect [OPTIONS] SERVICE [SERVICE...]

Display detailed information on one or more services

Options:
  -f, --format string   Format the output using the given go template
      --help            Print usage
      --pretty          Print the information in a human friendly format.
```


Inspects the specified service. This command has to be run targeting a manager
node.

By default, this renders all results in a JSON array. If a format is specified,
the given template will be executed for each result.

Go's [text/template](http://golang.org/pkg/text/template/) package
describes all the details of the format.

## Examples

### Inspecting a service  by name or ID

You can inspect a service, either by its *name*, or *ID*

For example, given the following service;

```bash
$ docker service ls
ID            NAME      REPLICAS  IMAGE         COMMAND
dmu1ept4cxcf  redis     3/3       redis:3.0.6
```

Both `docker service inspect redis`, and `docker service inspect dmu1ept4cxcf`
produce the same result:

```bash
$ docker service inspect redis
[
    {
        "ID": "dmu1ept4cxcfe8k8lhtux3ro3",
        "Version": {
            "Index": 12
        },
        "CreatedAt": "2016-06-17T18:44:02.558012087Z",
        "UpdatedAt": "2016-06-17T18:44:02.558012087Z",
        "Spec": {
            "Name": "redis",
            "TaskTemplate": {
                "ContainerSpec": {
                    "Image": "redis:3.0.6"
                },
                "Resources": {
                    "Limits": {},
                    "Reservations": {}
                },
                "RestartPolicy": {
                    "Condition": "any",
                    "MaxAttempts": 0
                },
                "Placement": {}
            },
            "Mode": {
                "Replicated": {
                    "Replicas": 1
                }
            },
            "UpdateConfig": {},
            "EndpointSpec": {
                "Mode": "vip"
            }
        },
        "Endpoint": {
            "Spec": {}
        }
    }
]
```

```bash
$ docker service inspect dmu1ept4cxcf
[
    {
        "ID": "dmu1ept4cxcfe8k8lhtux3ro3",
        "Version": {
            "Index": 12
        },
        ...
    }
]
```

### Inspect a service using pretty-print

You can print the inspect output in a human-readable format instead of the default
JSON output, by using the `--pretty` option:

```bash
$ docker service inspect --pretty frontend
ID:		c8wgl7q4ndfd52ni6qftkvnnp
Name:		frontend
Labels:
 - org.example.projectname=demo-app
Mode:		REPLICATED
 Replicas:		5
Placement:
UpdateConfig:
 Parallelism:	0
ContainerSpec:
 Image:		nginx:alpine
Resources:
Ports:
 Name =
 Protocol = tcp
 TargetPort = 443
 PublishedPort = 4443
```


### Finding the number of tasks running as part of a service

The `--format` option can be used to obtain specific information about a
service. For example, the following command outputs the number of replicas
of the "redis" service.

```bash{% raw %}
$ docker service inspect --format='{{.Spec.Mode.Replicated.Replicas}}' redis
10
{% endraw %}```


## Related information

* [service create](service_create.md)
* [service ls](service_ls.md)
* [service rm](service_rm.md)
* [service scale](service_scale.md)
* [service ps](service_ps.md)
* [service update](service_update.md)
                                                                                                                                                                                                                                                                                                                                                                                                                     go/src/github.com/docker/docker/docs/reference/commandline/service_ls.md                            0100644 0000000 0000000 00000005270 13101060260 025043  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/service_ls/
description: The service ls command description and usage
keywords:
- service, ls
title: docker service ls
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```Markdown
Usage:	docker service ls [OPTIONS]

List services

Aliases:
  ls, list

Options:
  -f, --filter value   Filter output based on conditions provided
      --help           Print usage
  -q, --quiet          Only display IDs
```

This command when run targeting a manager, lists services are running in the
swarm.

On a manager node:

```bash
ID            NAME      REPLICAS  IMAGE         COMMAND
c8wgl7q4ndfd  frontend  5/5       nginx:alpine
dmu1ept4cxcf  redis     3/3       redis:3.0.6
```

The `REPLICAS` column shows both the *actual* and *desired* number of tasks for
the service.


## Filtering

The filtering flag (`-f` or `--filter`) format is of "key=value". If there is more
than one filter, then pass multiple flags (e.g., `--filter "foo=bar" --filter "bif=baz"`)

The currently supported filters are:

* [id](service_ls.md#id)
* [label](service_ls.md#label)
* [name](service_ls.md#name)

#### ID

The `id` filter matches all or part of a service's id.

```bash
$ docker service ls -f "id=0bcjw"
ID            NAME   REPLICAS  IMAGE        COMMAND
0bcjwfh8ychr  redis  1/1       redis:3.0.6
```

#### Label

The `label` filter matches services based on the presence of a `label` alone or
a `label` and a value.

The following filter matches all services with a `project` label regardless of
its value:

```bash
$ docker service ls --filter label=project
ID            NAME       REPLICAS  IMAGE         COMMAND
01sl1rp6nj5u  frontend2  1/1       nginx:alpine
36xvvwwauej0  frontend   5/5       nginx:alpine
74nzcxxjv6fq  backend    3/3       redis:3.0.6
```

The following filter matches only services with the `project` label with the
`project-a` value.

```bash
$ docker service ls --filter label=project=project-a
ID            NAME      REPLICAS  IMAGE         COMMAND
36xvvwwauej0  frontend  5/5       nginx:alpine
74nzcxxjv6fq  backend   3/3       redis:3.0.6
```


#### Name

The `name` filter matches on all or part of a tasks's name.

The following filter matches services with a name containing `redis`.

```bash
$ docker service ls --filter name=redis
ID            NAME   REPLICAS  IMAGE        COMMAND
0bcjwfh8ychr  redis  1/1       redis:3.0.6
```

## Related information

* [service create](service_create.md)
* [service inspect](service_inspect.md)
* [service rm](service_rm.md)
* [service scale](service_scale.md)
* [service ps](service_ps.md)
* [service update](service_update.md)
                                                                                                                                                                                                                                                                                                                                        go/src/github.com/docker/docker/docs/reference/commandline/service_ps.md                            0100644 0000000 0000000 00000010223 13101060260 025041  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
- /reference/commandline/service_ps/
- /engine/reference/commandline/service_tasks/
description: The service ps command description and usage
keywords:
- service, tasks
- ps
title: docker service ps
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```Markdown
Usage:	docker service ps [OPTIONS] SERVICE

List the tasks of a service

Options:
  -a, --all            Display all tasks
  -f, --filter value   Filter output based on conditions provided
      --help           Print usage
      --no-resolve     Do not map IDs to Names
```

Lists the tasks that are running as part of the specified service. This command
has to be run targeting a manager node.


## Examples

### Listing the tasks that are part of a service

The following command shows all the tasks that are part of the `redis` service:

```bash
$ docker service ps redis
ID                         NAME      SERVICE IMAGE        LAST STATE          DESIRED STATE  NODE
0qihejybwf1x5vqi8lgzlgnpq  redis.1   redis   redis:3.0.6  Running 8 seconds   Running        manager1
bk658fpbex0d57cqcwoe3jthu  redis.2   redis   redis:3.0.6  Running 9 seconds   Running        worker2
5ls5s5fldaqg37s9pwayjecrf  redis.3   redis   redis:3.0.6  Running 9 seconds   Running        worker1
8ryt076polmclyihzx67zsssj  redis.4   redis   redis:3.0.6  Running 9 seconds   Running        worker1
1x0v8yomsncd6sbvfn0ph6ogc  redis.5   redis   redis:3.0.6  Running 8 seconds   Running        manager1
71v7je3el7rrw0osfywzs0lko  redis.6   redis   redis:3.0.6  Running 9 seconds   Running        worker2
4l3zm9b7tfr7cedaik8roxq6r  redis.7   redis   redis:3.0.6  Running 9 seconds   Running        worker2
9tfpyixiy2i74ad9uqmzp1q6o  redis.8   redis   redis:3.0.6  Running 9 seconds   Running        worker1
3w1wu13yuplna8ri3fx47iwad  redis.9   redis   redis:3.0.6  Running 8 seconds   Running        manager1
8eaxrb2fqpbnv9x30vr06i6vt  redis.10  redis   redis:3.0.6  Running 8 seconds   Running        manager1
```


## Filtering

The filtering flag (`-f` or `--filter`) format is a `key=value` pair. If there
is more than one filter, then pass multiple flags (e.g. `--filter "foo=bar" --filter "bif=baz"`).
Multiple filter flags are combined as an `OR` filter. For example,
`-f name=redis.1 -f name=redis.7` returns both `redis.1` and `redis.7` tasks.

The currently supported filters are:

* [id](service_ps.md#id)
* [name](service_ps.md#name)
* [node](service_ps.md#node)
* [desired-state](service_ps.md#desired-state)


#### ID

The `id` filter matches on all or a prefix of a task's ID.

```bash
$ docker service ps -f "id=8" redis
ID                         NAME      SERVICE  IMAGE        LAST STATE         DESIRED STATE  NODE
8ryt076polmclyihzx67zsssj  redis.4   redis    redis:3.0.6  Running 4 minutes  Running        worker1
8eaxrb2fqpbnv9x30vr06i6vt  redis.10  redis    redis:3.0.6  Running 4 minutes  Running        manager1
```

#### Name

The `name` filter matches on task names.

```bash
$ docker service ps -f "name=redis.1" redis
ID                         NAME      SERVICE  IMAGE        DESIRED STATE  LAST STATE         NODE
0qihejybwf1x5vqi8lgzlgnpq  redis.1   redis    redis:3.0.6  Running        Running 8 seconds  manager1
```


#### Node

The `node` filter matches on a node name or a node ID.

```bash
$ docker service ps -f "node=manager1" redis
NAME                                IMAGE        NODE      DESIRED STATE  CURRENT STATE
redis.1.0qihejybwf1x5vqi8lgzlgnpq   redis:3.0.6  manager1  Running        Running 8 seconds
redis.5.1x0v8yomsncd6sbvfn0ph6ogc   redis:3.0.6  manager1  Running        Running 8 seconds
redis.9.3w1wu13yuplna8ri3fx47iwad   redis:3.0.6  manager1  Running        Running 8 seconds
redis.10.8eaxrb2fqpbnv9x30vr06i6vt  redis:3.0.6  manager1  Running        Running 8 seconds
```


#### desired-state

The `desired-state` filter can take the values `running`, `shutdown`, and `accepted`.


## Related information

* [service create](service_create.md)
* [service inspect](service_inspect.md)
* [service ls](service_ls.md)
* [service rm](service_rm.md)
* [service scale](service_scale.md)
* [service update](service_update.md)
                                                                                                                                                                                                                                                                                                                                                                             go/src/github.com/docker/docker/docs/reference/commandline/service_rm.md                            0100644 0000000 0000000 00000002107 13101060260 025037  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/service_rm/
description: The service rm command description and usage
keywords:
- service, rm
title: docker service rm
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```Markdown
Usage:	docker service rm [OPTIONS] SERVICE [SERVICE...]

Remove one or more services

Aliases:
  rm, remove

Options:
      --help   Print usage
```

Removes the specified services from the swarm. This command has to be run
targeting a manager node.

For example, to remove the redis service:

```bash
$ docker service rm redis
redis
$ docker service ls
ID            NAME   SCALE  IMAGE        COMMAND
```

> **Warning**: Unlike `docker rm`, this command does not ask for confirmation
> before removing a running service.



## Related information

* [service create](service_create.md)
* [service inspect](service_inspect.md)
* [service ls](service_ls.md)
* [service scale](service_scale.md)
* [service ps](service_ps.md)
* [service update](service_update.md)
                                                                                                                                                                                                                                                                                                                                                                                                                                                         go/src/github.com/docker/docker/docs/reference/commandline/service_scale.md                         0100644 0000000 0000000 00000004203 13101060260 025507  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/service_scale/
description: The service scale command description and usage
keywords:
- service, scale
title: docker service scale
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```markdown
Usage:  docker service scale SERVICE=REPLICAS [SERVICE=REPLICAS...]

Scale one or multiple services

Options:
      --help   Print usage
```

## Examples

### Scale a service

The scale command enables you to scale one or more services either up or down to the desired¬†number of replicas. The command will return immediatly, but the actual scaling of the service may take some time. To stop all replicas of a service while keeping the service active in the swarm you can set the scale to 0.


For example, the following command scales the "frontend" service to 50 tasks.

```bash
$ docker service scale frontend=50
frontend scaled to 50
```

Directly afterwards, run `docker service ls`, to see the actual number of
replicas

```bash
$ docker service ls --filter name=frontend

ID            NAME      REPLICAS  IMAGE         COMMAND
3pr5mlvu3fh9  frontend  15/50     nginx:alpine
```

You can also scale a service using the [`docker service update`](service_update.md)
command. The following commands are therefore equivalent:

```bash
$ docker service scale frontend=50
$ docker service update --replicas=50 frontend
```

### Scale multiple services

The `docker service scale` command allows you to set the desired number of
tasks for multiple services at once. The following example scales both the
backend and frontend services:

```bash
$ docker service scale backend=3 frontend=5
backend scaled to 3
frontend scaled to 5

$ docker service ls
ID            NAME      REPLICAS  IMAGE         COMMAND
3pr5mlvu3fh9  frontend  5/5       nginx:alpine
74nzcxxjv6fq  backend   3/3       redis:3.0.6
```

## Related information

* [service create](service_create.md)
* [service inspect](service_inspect.md)
* [service ls](service_ls.md)
* [service rm](service_rm.md)
* [service ps](service_ps.md)
* [service update](service_update.md)
                                                                                                                                                                                                                                                                                                                                                                                             go/src/github.com/docker/docker/docs/reference/commandline/service_update.md                        0100644 0000000 0000000 00000011377 13101060260 025714  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/service_update/
description: The service update command description and usage
keywords:
- service, update
title: docker service update
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```Markdown
Usage:  docker service update [OPTIONS] SERVICE

Update a service

Options:
      --args string                    Service command args
      --constraint-add value           Add or update placement constraints (default [])
      --constraint-rm value            Remove a constraint (default [])
      --container-label-add value      Add or update container labels (default [])
      --container-label-rm value       Remove a container label by its key (default [])
      --endpoint-mode string           Endpoint mode (vip or dnsrr)
      --env-add value                  Add or update environment variables (default [])
      --env-rm value                   Remove an environment variable (default [])
      --help                           Print usage
      --image string                   Service image tag
      --label-add value                Add or update service labels (default [])
      --label-rm value                 Remove a label by its key (default [])
      --limit-cpu value                Limit CPUs (default 0.000)
      --limit-memory value             Limit Memory (default 0 B)
      --log-driver string              Logging driver for service
      --log-opt value                  Logging driver options (default [])
      --mount-add value                Add or update a mount on a service
      --mount-rm value                 Remove a mount by its target path (default [])
      --name string                    Service name
      --publish-add value              Add or update a published port (default [])
      --publish-rm value               Remove a published port by its target port (default [])
      --replicas value                 Number of tasks (default none)
      --reserve-cpu value              Reserve CPUs (default 0.000)
      --reserve-memory value           Reserve Memory (default 0 B)
      --restart-condition string       Restart when condition is met (none, on-failure, or any)
      --restart-delay value            Delay between restart attempts (default none)
      --restart-max-attempts value     Maximum number of restarts before giving up (default none)
      --restart-window value           Window used to evaluate the restart policy (default none)
      --stop-grace-period value        Time to wait before force killing a container (default none)
      --update-delay duration          Delay between updates
      --update-failure-action string   Action on update failure (pause|continue) (default "pause")
      --update-parallelism uint        Maximum number of tasks updated simultaneously (0 to update all at once) (default 1)
  -u, --user string                    Username or UID
      --with-registry-auth             Send registry authentication details to Swarm agents
  -w, --workdir string                 Working directory inside the container
```

Updates a service as described by the specified parameters. This command has to be run targeting a manager node.
The parameters are the same as [`docker service create`](service_create.md). Please look at the description there
for further information.

## Examples

### Update a service

```bash
$ docker service update --limit-cpu 2 redis
```

### Adding and removing mounts

Use the `--mount-add` or `--mount-rm` options add or remove a service's bind-mounts
or volumes.

The following example creates a service which mounts the `test-data` volume to
`/somewhere`. The next step updates the service to also mount the `other-volume`
volume to `/somewhere-else`volume, The last step unmounts the `/somewhere` mount
point, effectively removing the `test-data` volume. Each command returns the
service name.

- The `--mount-add` flag takes the same parameters as the `--mount` flag on
  `service create`. Refer to the [volumes and
  bind-mounts](service_create.md#volumes-and-bind-mounts-mount) section in the
  `service create` reference for details.

- The `--mount-rm` flag takes the `target` path of the mount.

```bash
$ docker service create \
    --name=myservice \
    --mount \
      type=volume,source=test-data,target=/somewhere \
    nginx:alpine \
    myservice

myservice

$ docker service update \
    --mount-add \
      type=volume,source=other-volume,target=/somewhere-else \
    myservice

myservice

$ docker service update --mount-rm /somewhere myservice

myservice
```

## Related information

* [service create](service_create.md)
* [service inspect](service_inspect.md)
* [service ps](service_ps.md)
* [service ls](service_ls.md)
* [service rm](service_rm.md)
                                                                                                                                                                                                                                                                 go/src/github.com/docker/docker/docs/reference/commandline/stack_config.md                          0100644 0000000 0000000 00000001223 13101060260 025331  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/stack_config/
advisory: experimental
description: The stack config command description and usage
keywords:
- stack, config
title: docker stack config (experimental)
---

```markdown
Usage:  docker stack config [OPTIONS] STACK

Print the stack configuration

Options:
      --file   string   Path to a Distributed Application Bundle file (Default: STACK.dab)
      --help            Print usage
```

Displays the configuration of a stack.

## Related information

* [stack deploy](stack_deploy.md)
* [stack rm](stack_rm.md)
* [stack services](stack_services.md)
* [stack ps](stack_ps.md)
* [stack ls](stack_ls.md)
                                                                                                                                                                                                                                                                                                                                                                             go/src/github.com/docker/docker/docs/reference/commandline/stack_deploy.md                          0100644 0000000 0000000 00000004454 13101060260 025371  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/stack_deploy/
advisory: experimental
description: The stack deploy command description and usage
keywords:
- stack, deploy, up
title: docker stack deploy (experimental)
---

```markdown
Usage:  docker stack deploy [OPTIONS] STACK

Create and update a stack from a Distributed Application Bundle (DAB)

Aliases:
  deploy, up

Options:
      --file   string   Path to a Distributed Application Bundle file (Default: STACK.dab)
      --help            Print usage
```

Create and update a stack from a `dab` file on the swarm. This command
has to be run targeting a manager node.

```bash
$ docker stack deploy vossibility-stack
Loading bundle from vossibility-stack.dab
Creating service vossibility-stack_elasticsearch
Creating service vossibility-stack_kibana
Creating service vossibility-stack_logstash
Creating service vossibility-stack_lookupd
Creating service vossibility-stack_nsqd
Creating service vossibility-stack_vossibility-collector
```

You can verify that the services were correctly created:

```bash
$ docker service ls
ID            NAME                                     REPLICAS  IMAGE
COMMAND
29bv0vnlm903  vossibility-stack_lookupd                1 nsqio/nsq@sha256:eeba05599f31eba418e96e71e0984c3dc96963ceb66924dd37a47bf7ce18a662 /nsqlookupd
4awt47624qwh  vossibility-stack_nsqd                   1 nsqio/nsq@sha256:eeba05599f31eba418e96e71e0984c3dc96963ceb66924dd37a47bf7ce18a662 /nsqd --data-path=/data --lookupd-tcp-address=lookupd:4160
4tjx9biia6fs  vossibility-stack_elasticsearch          1 elasticsearch@sha256:12ac7c6af55d001f71800b83ba91a04f716e58d82e748fa6e5a7359eed2301aa
7563uuzr9eys  vossibility-stack_kibana                 1 kibana@sha256:6995a2d25709a62694a937b8a529ff36da92ebee74bafd7bf00e6caf6db2eb03
9gc5m4met4he  vossibility-stack_logstash               1 logstash@sha256:2dc8bddd1bb4a5a34e8ebaf73749f6413c101b2edef6617f2f7713926d2141fe logstash -f /etc/logstash/conf.d/logstash.conf
axqh55ipl40h  vossibility-stack_vossibility-collector  1 icecrime/vossibility-collector@sha256:f03f2977203ba6253988c18d04061c5ec7aab46bca9dfd89a9a1fa4500989fba --config /config/config.toml --debug
```

## Related information

* [stack config](stack_config.md)
* [stack rm](stack_rm.md)
* [stack services](stack_services.md)
* [stack ps](stack_ps.md)
* [stack ls](stack_ls.md)
                                                                                                                                                                                                                    go/src/github.com/docker/docker/docs/reference/commandline/stack_ps.md                              0100644 0000000 0000000 00000002232 13101060260 024507  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/stack_tasks/
advisory: experimental
description: The stack ps command description and usage
keywords:
- stack, ps
title: docker stack ps (experimental)
---

```markdown
Usage:  docker stack ps [OPTIONS] STACK

List the tasks in the stack

Options:
  -a, --all            Display all tasks
  -f, --filter value   Filter output based on conditions provided
      --no-resolve     Do not map IDs to Names
      --no-trunc       Do not truncate output
```

Lists the tasks that are running as part of the specified stack. This
command has to be run targeting a manager node.

## Filtering

The filtering flag (`-f` or `--filter`) format is a `key=value` pair. If there
is more than one filter, then pass multiple flags (e.g. `--filter "foo=bar" --filter "bif=baz"`).
Multiple filter flags are combined as an `OR` filter. For example,
`-f name=redis.1 -f name=redis.7` returns both `redis.1` and `redis.7` tasks.

The currently supported filters are:

* id
* name
* desired-state

## Related information

* [stack config](stack_config.md)
* [stack deploy](stack_deploy.md)
* [stack rm](stack_rm.md)
* [stack services](stack_services.md)
                                                                                                                                                                                                                                                                                                                                                                      go/src/github.com/docker/docker/docs/reference/commandline/stack_rm.md                              0100644 0000000 0000000 00000001146 13101060260 024506  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/stack_rm/
advisory: experimental
description: The stack rm command description and usage
keywords:
- stack, rm, remove, down
title: docker stack rm (experimental)
---

```markdown
Usage:  docker stack rm STACK

Remove the stack

Aliases:
  rm, remove, down

Options:
      --help   Print usage
```

Remove the stack from the swarm. This command has to be run targeting
a manager node.

## Related information

* [stack config](stack_config.md)
* [stack deploy](stack_deploy.md)
* [stack services](stack_services.md)
* [stack ps](stack_ps.md)
* [stack ls](stack_ls.md)
                                                                                                                                                                                                                                                                                                                                                                                                                          go/src/github.com/docker/docker/docs/reference/commandline/stack_services.md                        0100644 0000000 0000000 00000004215 13101060260 025713  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/stack_services/
advisory: experimental
description: The stack services command description and usage
keywords:
- stack, services
title: docker stack services (experimental)
---

```markdown
Usage:	docker stack services [OPTIONS] STACK

List the services in the stack

Options:
  -f, --filter value   Filter output based on conditions provided
      --help           Print usage
  -q, --quiet          Only display IDs
```

Lists the services that are running as part of the specified stack. This
command has to be run targeting a manager node.

For example, the following command shows all services in the `myapp` stack:

```bash
$ docker stack services myapp

ID            NAME            REPLICAS  IMAGE                                                                          COMMAND
7be5ei6sqeye  myapp_web       1/1       nginx@sha256:23f809e7fd5952e7d5be065b4d3643fbbceccd349d537b62a123ef2201bc886f
dn7m7nhhfb9y  myapp_db        1/1       mysql@sha256:a9a5b559f8821fe73d58c3606c812d1c044868d42c63817fa5125fd9d8b7b539
```

## Filtering

The filtering flag (`-f` or `--filter`) format is a `key=value` pair. If there
is more than one filter, then pass multiple flags (e.g. `--filter "foo=bar" --filter "bif=baz"`).
Multiple filter flags are combined as an `OR` filter.

The following command shows both the `web` and `db` services:

```bash
$ docker stack services --filter name=myapp_web --filter name=myapp_db myapp

ID            NAME            REPLICAS  IMAGE                                                                          COMMAND
7be5ei6sqeye  myapp_web       1/1       nginx@sha256:23f809e7fd5952e7d5be065b4d3643fbbceccd349d537b62a123ef2201bc886f
dn7m7nhhfb9y  myapp_db        1/1       mysql@sha256:a9a5b559f8821fe73d58c3606c812d1c044868d42c63817fa5125fd9d8b7b539
```

The currently supported filters are:

* id / ID (`--filter id=7be5ei6sqeye`, or `--filter ID=7be5ei6sqeye`)
* name (`--filter name=myapp_web`)
* label (`--filter label=key=value`)

## Related information

* [stack config](stack_config.md)
* [stack deploy](stack_deploy.md)
* [stack rm](stack_rm.md)
* [stack ps](stack_ps.md)
* [stack ls](stack_ls.md)
                                                                                                                                                                                                                                                                                                                                                                                   go/src/github.com/docker/docker/docs/reference/commandline/start.md                                 0100644 0000000 0000000 00000001027 13101060260 024036  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/start/
description: The start command description and usage
keywords:
- Start, container, stopped
title: docker start
---

```markdown
Usage:  docker start [OPTIONS] CONTAINER [CONTAINER...]

Start one or more stopped containers

Options:
  -a, --attach               Attach STDOUT/STDERR and forward signals
      --detach-keys string   Override the key sequence for detaching a container
      --help                 Print usage
  -i, --interactive          Attach container's STDIN
```
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         go/src/github.com/docker/docker/docs/reference/commandline/stats.md                                 0100644 0000000 0000000 00000003500 13101060260 024035  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/stats/
description: The stats command description and usage
keywords:
- container, resource, statistics
title: docker stats
---

```markdown
Usage:  docker stats [OPTIONS] [CONTAINER...]

Display a live stream of container(s) resource usage statistics

Options:
  -a, --all         Show all containers (default shows just running)
      --help        Print usage
      --no-stream   Disable streaming stats and only pull the first result
```

The `docker stats` command returns a live data stream for running containers. To limit data to one or more specific containers, specify a list of container names or ids separated by a space. You can specify a stopped container but stopped containers do not return any data.

If you want more detailed information about a container's resource usage, use the `/containers/(id)/stats` API endpoint.

## Examples

Running `docker stats` on all running containers

    $ docker stats
    CONTAINER           CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O
    1285939c1fd3        0.07%               796 KiB / 64 MiB        1.21%               788 B / 648 B       3.568 MB / 512 KB
    9c76f7834ae2        0.07%               2.746 MiB / 64 MiB      4.29%               1.266 KB / 648 B    12.4 MB / 0 B
    d1ea048f04e4        0.03%               4.583 MiB / 64 MiB      6.30%               2.854 KB / 648 B    27.7 MB / 0 B

Running `docker stats` on multiple containers by name and id.

    $ docker stats fervent_panini 5acfcb1b4fd1
    CONTAINER           CPU %               MEM USAGE/LIMIT     MEM %               NET I/O
    5acfcb1b4fd1        0.00%               115.2 MiB/1.045 GiB   11.03%              1.422 kB/648 B
    fervent_panini      0.02%               11.08 MiB/1.045 GiB   1.06%               648 B/648 B
                                                                                                                                                                                                go/src/github.com/docker/docker/docs/reference/commandline/stop.md                                  0100644 0000000 0000000 00000000747 13101060260 023676  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/stop/
description: The stop command description and usage
keywords:
- stop, SIGKILL, SIGTERM
title: docker stop
---

```markdown
Usage:  docker stop [OPTIONS] CONTAINER [CONTAINER...]

Stop one or more running containers

Options:
      --help       Print usage
  -t, --time int   Seconds to wait for stop before killing it (default 10)
```

The main process inside the container will receive `SIGTERM`, and after a grace
period, `SIGKILL`.
                         go/src/github.com/docker/docker/docs/reference/commandline/swarm_init.md                            0100644 0000000 0000000 00000010043 13101060260 025053  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/swarm_init/
description: The swarm init command description and usage
keywords:
- swarm, init
title: docker swarm init
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```markdown
Usage:  docker swarm init [OPTIONS]

Initialize a swarm

Options:
      --advertise-addr value            Advertised address (format: <ip|interface>[:port])
      --cert-expiry duration            Validity period for node certificates (default 2160h0m0s)
      --dispatcher-heartbeat duration   Dispatcher heartbeat period (default 5s)
      --external-ca value               Specifications of one or more certificate signing endpoints
      --force-new-cluster               Force create a new cluster from current state.
      --help                            Print usage
      --listen-addr value               Listen address (format: <ip|interface>[:port])
      --task-history-limit int          Task history retention limit (default 5)
```

Initialize a swarm. The docker engine targeted by this command becomes a manager
in the newly created single-node swarm.


```bash
$ docker swarm init --advertise-addr 192.168.99.121
Swarm initialized: current node (bvz81updecsj6wjz393c09vti) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-1awxwuwd3z9j1z3puu7rcgdbx \
    172.17.0.2:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

`docker swarm init` generates two random tokens, a worker token and a manager token. When you join
a new node to the swarm, the node joins as a worker or manager node based upon the token you pass
to [swarm join](swarm_join.md).

After you create the swarm, you can display or rotate the token using
[swarm join-token](swarm_join_token.md).

### `--cert-expiry`

This flag sets the validity period for node certificates.

### `--dispatcher-heartbeat`

This flags sets the frequency with which nodes are told to use as a
period to report their health.

### `--external-ca value`

This flag sets up the swarm to use an external CA to issue node certificates. The value takes
the form `protocol=X,url=Y`. The value for `protocol` specifies what protocol should be used
to send signing requests to the external CA. Currently, the only supported value is `cfssl`.
The URL specifies the endpoint where signing requests should be submitted.

### `--force-new-cluster`

This flag forces an existing node that was part of a quorum that was lost to restart as a single node Manager without losing its data.

### `--listen-addr value`

The node listens for inbound swarm manager traffic on this address. The default is to listen on
0.0.0.0:2377. It is also possible to specify a network interface to listen on that interface's
address; for example `--listen-addr eth0:2377`.

Specifying a port is optional. If the value is a bare IP address or interface
name, the default port 2377 will be used.

### `--advertise-addr value`

This flag specifies the address that will be advertised to other members of the
swarm for API access and overlay networking. If unspecified, Docker will check
if the system has a single IP address, and use that IP address with with the
listening port (see `--listen-addr`). If the system has multiple IP addresses,
`--advertise-addr` must be specified so that the correct address is chosen for
inter-manager communication and overlay networking.

It is also possible to specify a network interface to advertise that interface's address;
for example `--advertise-addr eth0:2377`.

Specifying a port is optional. If the value is a bare IP address or interface
name, the default port 2377 will be used.

### `--task-history-limit`

This flag sets up task history retention limit.

## Related information

* [swarm join](swarm_join.md)
* [swarm leave](swarm_leave.md)
* [swarm update](swarm_update.md)
* [swarm join-token](swarm_join_token.md)
* [node rm](node_rm.md)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             go/src/github.com/docker/docker/docs/reference/commandline/swarm_join.md                            0100644 0000000 0000000 00000007333 13101060260 025057  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/swarm_join/
description: The swarm join command description and usage
keywords:
- swarm, join
title: docker swarm join
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```markdown
Usage:  docker swarm join [OPTIONS] HOST:PORT

Join a swarm as a node and/or manager

Options:
      --advertise-addr value   Advertised address (format: <ip|interface>[:port])
      --help                   Print usage
      --listen-addr value      Listen address (format: <ip|interface>[:port)
      --token string           Token for entry into the swarm
```

Join a node to a swarm. The node joins as a manager node or worker node based upon the token you
pass with the `--token` flag. If you pass a manager token, the node joins as a manager. If you
pass a worker token, the node joins as a worker.

### Join a node to swarm as a manager

The example below demonstrates joining a manager node using a manager token.

```bash
$ docker swarm join --token SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-7p73s1dx5in4tatdymyhg9hu2 192.168.99.121:2377
This node joined a swarm as a manager.
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
dkp8vy1dq1kxleu9g4u78tlag *  manager2  Ready   Active        Reachable
dvfxp4zseq4s0rih1selh0d20    manager1  Ready   Active        Leader
```

A cluster should only have 3-7 managers at most, because a majority of managers must be available
for the cluster to function. Nodes that aren't meant to participate in this management quorum
should join as workers instead. Managers should be stable hosts that have static IP addresses.

### Join a node to swarm as a worker

The example below demonstrates joining a worker node using a worker token.

```bash
$ docker swarm join --token SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-1awxwuwd3z9j1z3puu7rcgdbx 192.168.99.121:2377
This node joined a swarm as a worker.
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
7ln70fl22uw2dvjn2ft53m3q5    worker2   Ready   Active
dkp8vy1dq1kxleu9g4u78tlag    worker1   Ready   Active        Reachable
dvfxp4zseq4s0rih1selh0d20 *  manager1  Ready   Active        Leader
```

### `--listen-addr value`

If the node is a manager, it will listen for inbound swarm manager traffic on this
address. The default is to listen on 0.0.0.0:2377. It is also possible to specify a
network interface to listen on that interface's address; for example `--listen-addr eth0:2377`.

Specifying a port is optional. If the value is a bare IP address, or interface
name, the default port 2377 will be used.

This flag is generally not necessary when joining an existing swarm.

### `--advertise-addr value`

This flag specifies the address that will be advertised to other members of the
swarm for API access. If unspecified, Docker will check if the system has a
single IP address, and use that IP address with with the listening port (see
`--listen-addr`). If the system has multiple IP addresses, `--advertise-addr`
must be specified so that the correct address is chosen for inter-manager
communication and overlay networking.

It is also possible to specify a network interface to advertise that interface's address;
for example `--advertise-addr eth0:2377`.

Specifying a port is optional. If the value is a bare IP address, or interface
name, the default port 2377 will be used.

This flag is generally not necessary when joining an existing swarm.

### `--token string`

Secret value required for nodes to join the swarm


## Related information

* [swarm init](swarm_init.md)
* [swarm leave](swarm_leave.md)
* [swarm update](swarm_update.md)
                                                                                                                                                                                                                                                                                                     go/src/github.com/docker/docker/docs/reference/commandline/swarm_join_token.md                      0100644 0000000 0000000 00000006044 13101060260 026255  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/swarm_join_token/
description: The swarm join-token command description and usage
keywords:
- swarm, join-token
title: docker swarm join-token
---

```markdown
Usage:	docker swarm join-token [--rotate] (worker|manager)

Manage join tokens

Options:
      --help     Print usage
  -q, --quiet    Only display token
      --rotate   Rotate join token
```

Join tokens are secrets that allow a node to join the swarm. There are two
different join tokens available, one for the worker role and one for the manager
role. You pass the token using the `--token` flag when you run
[swarm join](swarm_join.md). Nodes use the join token only when they join the
swarm.

You can view or rotate the join tokens using `swarm join-token`.

As a convenience, you can pass `worker` or `manager` as an argument to
`join-token` to print the full `docker swarm join` command to join a new node to
the swarm:

```bash
$ docker swarm join-token worker
To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-1awxwuwd3z9j1z3puu7rcgdbx \
    172.17.0.2:2377

$ docker swarm join-token manager
To add a manager to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-7p73s1dx5in4tatdymyhg9hu2 \
    172.17.0.2:2377
```

Use the `--rotate` flag to generate a new join token for the specified role:

```bash
$ docker swarm join-token --rotate worker
Succesfully rotated worker join token.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-b30ljddcqhef9b9v4rs7mel7t \
    172.17.0.2:2377
```

After using `--rotate`, only the new token will be valid for joining with the specified role.

The `-q` (or `--quiet`) flag only prints the token:

```bash
$ docker swarm join-token -q worker

SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-b30ljddcqhef9b9v4rs7mel7t
```

### `--rotate`

Because tokens allow new nodes to join the swarm, you should keep them secret.
Be particularly careful with manager tokens since they allow new manager nodes
to join the swarm. A rogue manager has the potential to disrupt the operation of
your swarm.

Rotate your swarm's join token if a token gets checked-in to version control,
stolen, or a node is compromised. You may also want to periodically rotate the
token to ensure any unknown token leaks do not allow a rogue node to join
the swarm.

To rotate the join token and print the newly generated token, run
`docker swarm join-token --rotate` and pass the role: `manager` or `worker`.

Rotating a join-token means that no new nodes will be able to join the swarm
using the old token. Rotation does not affect existing nodes in the swarm
because the join token is only used for authorizing new nodes joining the swarm.

### `--quiet`

Only print the token. Do not print a complete command for joining.

## Related information

* [swarm join](swarm_join.md)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            go/src/github.com/docker/docker/docs/reference/commandline/swarm_leave.md                           0100644 0000000 0000000 00000003331 13101060260 025206  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/swarm_leave/
description: The swarm leave command description and usage
keywords:
- swarm, leave
title: docker swarm leave
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```markdown
Usage:  docker swarm leave [OPTIONS]

Leave the swarm (workers only).

Options:
      --force   Force this node to leave the swarm, ignoring warnings
      --help    Print usage
```

When you run this command on a worker, that worker leaves the swarm.

You can use the `--force` option to on a manager to remove it from the swarm.
However, this does not reconfigure the swarm to ensure that there are enough
managers to maintain a quorum in the swarm. The safe way to remove a manager
from a swarm is to demote it to a worker and then direct it to leave the quorum
without using `--force`. Only use `--force` in situations where the swarm will
no longer be used after the manager leaves, such as in a single-node swarm.

Consider the following swarm, as seen from the manager:

```bash
$ docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
7ln70fl22uw2dvjn2ft53m3q5    worker2   Ready   Active
dkp8vy1dq1kxleu9g4u78tlag    worker1   Ready   Active
dvfxp4zseq4s0rih1selh0d20 *  manager1  Ready   Active        Leader
```

To remove `worker2`, issue the following command from `worker2` itself:

```bash
$ docker swarm leave
Node left the default swarm.
```

To remove an inactive node, use the [`node rm`](node_rm.md) command instead.

## Related information

* [node rm](node_rm.md)
* [swarm init](swarm_init.md)
* [swarm join](swarm_join.md)
* [swarm update](swarm_update.md)
                                                                                                                                                                                                                                                                                                       go/src/github.com/docker/docker/docs/reference/commandline/swarm_update.md                          0100644 0000000 0000000 00000002070 13101060260 025373  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/swarm_update/
description: The swarm update command description and usage
keywords:
- swarm, update
title: docker swarm update
---

**Warning:** this command is part of the Swarm management feature introduced in Docker 1.12, and might be subject to non backward-compatible changes.

```markdown
Usage:  docker swarm update [OPTIONS]

Update the swarm

Options:
      --cert-expiry duration            Validity period for node certificates (default 2160h0m0s)
      --dispatcher-heartbeat duration   Dispatcher heartbeat period (default 5s)
      --external-ca value               Specifications of one or more certificate signing endpoints
      --help                            Print usage
      --task-history-limit int          Task history retention limit (default 5)
```

Updates a swarm with new parameter values. This command must target a manager node.


```bash
$ docker swarm update --cert-expiry 720h
```

## Related information

* [swarm init](swarm_init.md)
* [swarm join](swarm_join.md)
* [swarm leave](swarm_leave.md)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                        go/src/github.com/docker/docker/docs/reference/commandline/tag.md                                   0100644 0000000 0000000 00000004243 13101060260 023457  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/tag/
description: The tag command description and usage
keywords:
- tag, name, image
title: docker tag
---

```markdown
Usage:  docker tag IMAGE[:TAG] IMAGE[:TAG]

Tag an image into a repository

Options:
      --help   Print usage
```

An image name is made up of slash-separated name components, optionally prefixed
by a registry hostname. The hostname must comply with standard DNS rules, but
may not contain underscores. If a hostname is present, it may optionally be
followed by a port number in the format `:8080`. If not present, the command
uses Docker's public registry located at `registry-1.docker.io` by default. Name
components may contain lowercase characters, digits and separators. A separator
is defined as a period, one or two underscores, or one or more dashes. A name
component may not start or end with a separator.

A tag name may contain lowercase and uppercase characters, digits, underscores,
periods and dashes. A tag name may not start with a period or a dash and may
contain a maximum of 128 characters.

You can group your images together using names and tags, and then upload them
to [*Share Images via Repositories*](../../tutorials/dockerrepos.md#contributing-to-docker-hub).

# Examples

## Tagging an image referenced by ID

To tag a local image with ID "0e5574283393" into the "fedora" repository with
"version1.0":

    docker tag 0e5574283393 fedora/httpd:version1.0

## Tagging an image referenced by Name

To tag a local image with name "httpd" into the "fedora" repository with
"version1.0":

    docker tag httpd fedora/httpd:version1.0

Note that since the tag name is not specified, the alias is created for an
existing local version `httpd:latest`.

## Tagging an image referenced by Name and Tag

To tag a local image with name "httpd" and tag "test" into the "fedora"
repository with "version1.0.test":

    docker tag httpd:test fedora/httpd:version1.0.test

## Tagging an image for a private repository

To push an image to a private registry and not the central Docker
registry you must tag it with the registry hostname and port (if needed).

    docker tag 0e5574283393 myregistryhost:5000/fedora/httpd:version1.0
                                                                                                                                                                                                                                                                                                                                                             go/src/github.com/docker/docker/docs/reference/commandline/top.md                                   0100644 0000000 0000000 00000000464 13101060260 023507  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/top/
description: The top command description and usage
keywords:
- container, running, processes
title: docker top
---

```markdown
Usage:  docker top CONTAINER [ps OPTIONS]

Display the running processes of a container

Options:
      --help   Print usage
```
                                                                                                                                                                                                            go/src/github.com/docker/docker/docs/reference/commandline/unpause.md                               0100644 0000000 0000000 00000001066 13101060260 024364  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/unpause/
description: The unpause command description and usage
keywords:
- cgroups, suspend, container
title: docker unpause
---

```markdown
Usage:  docker unpause CONTAINER [CONTAINER...]

Unpause all processes within one or more containers

Options:
      --help   Print usage
```

The `docker unpause` command uses the cgroups freezer to un-suspend all
processes in a container.

See the
[cgroups freezer documentation](https://www.kernel.org/doc/Documentation/cgroup-v1/freezer-subsystem.txt)
for further details.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                          go/src/github.com/docker/docker/docs/reference/commandline/update.md                                0100644 0000000 0000000 00000005316 13101060260 024170  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/update/
description: The update command description and usage
keywords:
- resources, update, dynamically
title: docker update
---

```markdown
Usage:  docker update [OPTIONS] CONTAINER [CONTAINER...]

Update configuration of one or more containers

Options:
      --blkio-weight value          Block IO (relative weight), between 10 and 1000
      --cpu-period int              Limit CPU CFS (Completely Fair Scheduler) period
      --cpu-quota int               Limit CPU CFS (Completely Fair Scheduler) quota
  -c, --cpu-shares int              CPU shares (relative weight)
      --cpuset-cpus string          CPUs in which to allow execution (0-3, 0,1)
      --cpuset-mems string          MEMs in which to allow execution (0-3, 0,1)
      --help                        Print usage
      --kernel-memory string        Kernel memory limit
  -m, --memory string               Memory limit
      --memory-reservation string   Memory soft limit
      --memory-swap string          Swap limit equal to memory plus swap: '-1' to enable unlimited swap
      --restart string              Restart policy to apply when a container exits
```

The `docker update` command dynamically updates container configuration.
You can use this command to prevent containers from consuming too many resources
from their Docker host.  With a single command, you can place limits on
a single container or on many. To specify more than one container, provide
space-separated list of container names or IDs.

With the exception of the `--kernel-memory` value, you can specify these
options on a running or a stopped container. You can only update
`--kernel-memory` on a stopped container. When you run `docker update` on
stopped container, the next time you restart it, the container uses those
values.

Another configuration you can change with this command is restart policy,
new restart policy will take effect instantly after you run `docker update`
on a container.

## Examples

The following sections illustrate ways to use this command.

### Update a container with cpu-shares=512

To limit a container's cpu-shares to 512, first identify the container
name or ID. You can use **docker ps** to find these values. You can also
use the ID returned from the **docker run** command.  Then, do the following:

```bash
$ docker update --cpu-shares 512 abebf7571666
```

### Update a container with cpu-shares and memory

To update multiple resource configurations for multiple containers:

```bash
$ docker update --cpu-shares 512 -m 300M abebf7571666 hopeful_morse
```

### Update a container's restart policy

To update restart policy for one or more containers:
```bash
$ docker update --restart=on-failure:3 abebf7571666 hopeful_morse
```
                                                                                                                                                                                                                                                                                                                  go/src/github.com/docker/docker/docs/reference/commandline/version.md                               0100644 0000000 0000000 00000003143 13101060260 024367  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/version/
description: The version command description and usage
keywords:
- version, architecture, api
title: docker version
---

```markdown
Usage:  docker version [OPTIONS]

Show the Docker version information

Options:
  -f, --format string   Format the output using the given go template
      --help            Print usage
```

By default, this will render all version information in an easy to read
layout. If a format is specified, the given template will be executed instead.

Go's [text/template](http://golang.org/pkg/text/template/) package
describes all the details of the format.

## Examples

**Default output:**

    $ docker version
	Client:
	 Version:      1.8.0
	 API version:  1.20
	 Go version:   go1.4.2
	 Git commit:   f5bae0a
	 Built:        Tue Jun 23 17:56:00 UTC 2015
	 OS/Arch:      linux/amd64

	Server:
	 Version:      1.8.0
	 API version:  1.20
	 Go version:   go1.4.2
	 Git commit:   f5bae0a
	 Built:        Tue Jun 23 17:56:00 UTC 2015
	 OS/Arch:      linux/amd64

**Get server version:**

    {% raw %}
    $ docker version --format '{{.Server.Version}}'
	1.8.0
    {% endraw %}

**Dump raw data:**

    {% raw %}
    $ docker version --format '{{json .}}'
    {"Client":{"Version":"1.8.0","ApiVersion":"1.20","GitCommit":"f5bae0a","GoVersion":"go1.4.2","Os":"linux","Arch":"amd64","BuildTime":"Tue Jun 23 17:56:00 UTC 2015"},"ServerOK":true,"Server":{"Version":"1.8.0","ApiVersion":"1.20","GitCommit":"f5bae0a","GoVersion":"go1.4.2","Os":"linux","Arch":"amd64","KernelVersion":"3.13.2-gentoo","BuildTime":"Tue Jun 23 17:56:00 UTC 2015"}}
    {% endraw %}
                                                                                                                                                                                                                                                                                                                                                                                                                             go/src/github.com/docker/docker/docs/reference/commandline/volume_create.md                         0100644 0000000 0000000 00000006241 13101060260 025536  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/volume_create/
description: The volume create command description and usage
keywords:
- volume, create
title: docker volume create
---

```markdown
Usage:  docker volume create [OPTIONS]

Create a volume

Options:
  -d, --driver string   Specify volume driver name (default "local")
      --help            Print usage
      --label value     Set metadata for a volume (default [])
      --name string     Specify volume name
  -o, --opt value       Set driver specific options (default map[])
```

Creates a new volume that containers can consume and store data in. If a name is not specified, Docker generates a random name. You create a volume and then configure the container to use it, for example:

```bash
$ docker volume create --name hello
hello

$ docker run -d -v hello:/world busybox ls /world
```

The mount is created inside the container's `/world` directory. Docker does not support relative paths for mount points inside the container.

Multiple containers can use the same volume in the same time period. This is useful if two containers need access to shared data. For example, if one container writes and the other reads the data.

Volume names must be unique among drivers.  This means you cannot use the same volume name with two different drivers.  If you attempt this `docker` returns an error:

```
A volume named  "hello"  already exists with the "some-other" driver. Choose a different volume name.
```

If you specify a volume name already in use on the current driver, Docker assumes you want to re-use the existing volume and does not return an error.

## Driver specific options

Some volume drivers may take options to customize the volume creation. Use the `-o` or `--opt` flags to pass driver options:

```bash
$ docker volume create --driver fake --opt tardis=blue --opt timey=wimey
```

These options are passed directly to the volume driver. Options for
different volume drivers may do different things (or nothing at all).

The built-in `local` driver on Windows does not support any options.

The built-in `local` driver on Linux accepts options similar to the linux `mount` command. You can provide multiple options by passing the `--opt` flag multiple times. Some `mount` options (such as the `o` option) can take a comma-separated list of options. Complete list of available mount options can be found [here](http://man7.org/linux/man-pages/man8/mount.8.html).

For example, the following creates a `tmpfs` volume called `foo` with a size of 100 megabyte and `uid` of 1000.

```bash
$ docker volume create --driver local --opt type=tmpfs --opt device=tmpfs --opt o=size=100m,uid=1000 --name foo
```

Another example that uses `btrfs`:

```bash
$ docker volume create --driver local --opt type=btrfs --opt device=/dev/sda2 --name foo
```

Another example that uses `nfs` to mount the `/path/to/dir` in `rw` mode from `192.168.1.1`:

```bash
$ docker volume create --driver local --opt type=nfs --opt o=addr=192.168.1.1,rw --opt device=:/path/to/dir --name foo
```


## Related information

* [volume inspect](volume_inspect.md)
* [volume ls](volume_ls.md)
* [volume rm](volume_rm.md)
* [Understand Data Volumes](../../tutorials/dockervolumes.md)
                                                                                                                                                                                                                                                                                                                                                               go/src/github.com/docker/docker/docs/reference/commandline/volume_inspect.md                        0100644 0000000 0000000 00000003157 13101060260 025743  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/volume_inspect/
description: The volume inspect command description and usage
keywords:
- volume, inspect
title: docker volume inspect
---

```markdown
Usage:  docker volume inspect [OPTIONS] VOLUME [VOLUME...]

Display detailed information on one or more volumes

Options:
  -f, --format string   Format the output using the given go template
      --help            Print usage
```

Returns information about a volume. By default, this command renders all results
in a JSON array. You can specify an alternate format to execute a
given template for each result. Go's
[text/template](http://golang.org/pkg/text/template/) package describes all the
details of the format.

Example output:

    $ docker volume create
    85bffb0677236974f93955d8ecc4df55ef5070117b0e53333cc1b443777be24d
    $ docker volume inspect 85bffb0677236974f93955d8ecc4df55ef5070117b0e53333cc1b443777be24d
    [
      {
          "Name": "85bffb0677236974f93955d8ecc4df55ef5070117b0e53333cc1b443777be24d",
          "Driver": "local",
          "Mountpoint": "/var/lib/docker/volumes/85bffb0677236974f93955d8ecc4df55ef5070117b0e53333cc1b443777be24d/_data",
          "Status": null
      }
    ]

    {% raw %}
    $ docker volume inspect --format '{{ .Mountpoint }}' 85bffb0677236974f93955d8ecc4df55ef5070117b0e53333cc1b443777be24d
    /var/lib/docker/volumes/85bffb0677236974f93955d8ecc4df55ef5070117b0e53333cc1b443777be24d/_data
    {% endraw %}

## Related information

* [volume create](volume_create.md)
* [volume ls](volume_ls.md)
* [volume rm](volume_rm.md)
* [Understand Data Volumes](../../tutorials/dockervolumes.md)
                                                                                                                                                                                                                                                                                                                                                                                                                 go/src/github.com/docker/docker/docs/reference/commandline/volume_ls.md                             0100644 0000000 0000000 00000004666 13101060260 024722  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/volume_ls/
description: The volume ls command description and usage
keywords:
- volume, list
title: docker volume ls
---

```markdown
Usage:  docker volume ls [OPTIONS]

List volumes

Aliases:
  ls, list

Options:
  -f, --filter value   Provide filter values (i.e. 'dangling=true') (default [])
                       - dangling=<boolean> a volume if referenced or not
                       - driver=<string> a volume's driver name
                       - name=<string> a volume's name
      --help           Print usage
  -q, --quiet          Only display volume names
```

Lists all the volumes Docker knows about. You can filter using the `-f` or `--filter` flag. Refer to the [filtering](volume_ls.md#filtering) section for more information about available filter options.

Example output:

    $ docker volume create --name rosemary
    rosemary
    $docker volume create --name tyler
    tyler
    $ docker volume ls
    DRIVER              VOLUME NAME
    local               rosemary
    local               tyler

## Filtering

The filtering flag (`-f` or `--filter`) format is of "key=value". If there is more
than one filter, then pass multiple flags (e.g., `--filter "foo=bar" --filter "bif=baz"`)

The currently supported filters are:

* dangling (boolean - true or false, 0 or 1)
* driver (a volume driver's name)
* name (a volume's name)

### dangling

The `dangling` filter matches on all volumes not referenced by any containers

    $ docker run -d  -v tyler:/tmpwork  busybox
    f86a7dd02898067079c99ceacd810149060a70528eff3754d0b0f1a93bd0af18
    $ docker volume ls -f dangling=true
    DRIVER              VOLUME NAME
    local               rosemary

### driver

The `driver` filter matches on all or part of a volume's driver name.

The following filter matches all volumes with a driver name containing the `local` string.

    $ docker volume ls -f driver=local
    DRIVER              VOLUME NAME
    local               rosemary
    local               tyler

### name

The `name` filter matches on all or part of a volume's name.

The following filter matches all volumes with a name containing the `rose` string.

    $ docker volume ls -f name=rose
    DRIVER              VOLUME NAME
    local               rosemary

## Related information

* [volume create](volume_create.md)
* [volume inspect](volume_inspect.md)
* [volume rm](volume_rm.md)
* [Understand Data Volumes](../../tutorials/dockervolumes.md)
                                                                          go/src/github.com/docker/docker/docs/reference/commandline/volume_rm.md                             0100644 0000000 0000000 00000001166 13101060260 024712  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/volume_rm/
description: the volume rm command description and usage
keywords:
- volume, rm
title: docker volume rm
---

```markdown
Usage:  docker volume rm VOLUME [VOLUME...]

Remove one or more volumes

Aliases:
  rm, remove

Options:
      --help   Print usage
```

Remove one or more volumes. You cannot remove a volume that is in use by a container.

    $ docker volume rm hello
    hello

## Related information

* [volume create](volume_create.md)
* [volume inspect](volume_inspect.md)
* [volume ls](volume_ls.md)
* [Understand Data Volumes](../../tutorials/dockervolumes.md)
                                                                                                                                                                                                                                                                                                                                                                                                          go/src/github.com/docker/docker/docs/reference/commandline/wait.md                                  0100644 0000000 0000000 00000000475 13101060260 023653  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/commandline/wait/
description: The wait command description and usage
keywords:
- container, stop, wait
title: docker wait
---

```markdown
Usage:  docker wait CONTAINER [CONTAINER...]

Block until a container stops, then print its exit code

Options:
      --help   Print usage
```
                                                                                                                                                                                                   go/src/github.com/docker/docker/docs/reference/glossary.md                                          0100644 0000000 0000000 00000023546 13101060260 022270  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/glossary/
description: Glossary of terms used around Docker
keywords:
- glossary, docker, terms,  definitions
title: Docker glossary
---

A list of terms used around the Docker project.

## aufs

aufs (advanced multi layered unification filesystem) is a Linux [filesystem](glossary.md#filesystem) that
Docker supports as a storage backend. It implements the
[union mount](http://en.wikipedia.org/wiki/Union_mount) for Linux file systems.

## base image

An image that has no parent is a **base image**.

## boot2docker

[boot2docker](http://boot2docker.io/) is a lightweight Linux distribution made
specifically to run Docker containers. The boot2docker management tool for Mac and Windows was deprecated and replaced by [`docker-machine`](glossary.md#machine) which you can install with the Docker Toolbox.

## btrfs

btrfs (B-tree file system) is a Linux [filesystem](glossary.md#filesystem) that Docker
supports as a storage backend. It is a [copy-on-write](http://en.wikipedia.org/wiki/Copy-on-write)
filesystem.

## build

build is the process of building Docker images using a [Dockerfile](glossary.md#dockerfile).
The build uses a Dockerfile and a "context". The context is the set of files in the
directory in which the image is built.

## cgroups

cgroups is a Linux kernel feature that limits, accounts for, and isolates
the resource usage (CPU, memory, disk I/O, network, etc.) of a collection
of processes. Docker relies on cgroups to control and isolate resource limits.

*Also known as : control groups*

## Compose

[Compose](https://github.com/docker/compose) is a tool for defining and
running complex applications with Docker. With compose, you define a
multi-container application in a single file, then spin your
application up in a single command which does everything that needs to
be done to get it running.

*Also known as : docker-compose, fig*

## container

A container is a runtime instance of a [docker image](glossary.md#image).

A Docker container consists of

- A Docker image
- Execution environment
- A standard set of instructions

The concept is borrowed from Shipping Containers, which define a standard to ship
goods globally. Docker defines a standard to ship software.

## data volume

A data volume is a specially-designated directory within one or more containers
that bypasses the Union File System. Data volumes are designed to persist data,
independent of the container's life cycle. Docker therefore never automatically
delete volumes when you remove a container, nor will it "garbage collect"
volumes that are no longer referenced by a container.


## Docker

The term Docker can refer to

- The Docker project as a whole, which is a platform for developers and sysadmins to
develop, ship, and run applications
- The docker daemon process running on the host which manages images and containers


## Docker Hub

The [Docker Hub](https://hub.docker.com/) is a centralized resource for working with
Docker and its components. It provides the following services:

- Docker image hosting
- User authentication
- Automated image builds and work-flow tools such as build triggers and web hooks
- Integration with GitHub and Bitbucket


## Dockerfile

A Dockerfile is a text document that contains all the commands you would
normally execute manually in order to build a Docker image. Docker can
build images automatically by reading the instructions from a Dockerfile.

## filesystem

A file system is the method an operating system uses to name files
and assign them locations for efficient storage and retrieval.

Examples :

- Linux : ext4, aufs, btrfs, zfs
- Windows : NTFS
- macOS : HFS+

## image

Docker images are the basis of [containers](glossary.md#container). An Image is an
ordered collection of root filesystem changes and the corresponding
execution parameters for use within a container runtime. An image typically
contains a union of layered filesystems stacked on top of each other. An image
does not have state and it never changes.

## libcontainer

libcontainer provides a native Go implementation for creating containers with
namespaces, cgroups, capabilities, and filesystem access controls. It allows
you to manage the lifecycle of the container performing additional operations
after the container is created.

## libnetwork

libnetwork provides a native Go implementation for creating and managing container
network namespaces and other network resources. It manage the networking lifecycle
of the container performing additional operations after the container is created.

## link

links provide a legacy interface to connect Docker containers running on the
same host to each other without exposing the hosts' network ports. Use the
Docker networks feature instead.

## Machine

[Machine](https://github.com/docker/machine) is a Docker tool which
makes it really easy to create Docker hosts on  your computer, on
cloud providers and inside your own data center. It creates servers,
installs Docker on them, then configures the Docker client to talk to them.

*Also known as : docker-machine*

## node

A [node](../swarm/how-swarm-mode-works/nodes.md) is a physical or virtual
machine running an instance of the Docker Engine in swarm mode.

**Manager nodes** perform swarm management and orchestration duties. By default
manager nodes are also worker nodes.

**Worker nodes** execute tasks.

## overlay network driver

Overlay network driver provides out of the box multi-host network connectivity
for docker containers in a cluster.

## overlay storage driver

OverlayFS is a [filesystem](glossary.md#filesystem) service for Linux which implements a
[union mount](http://en.wikipedia.org/wiki/Union_mount) for other file systems.
It is supported by the Docker daemon as a storage driver.

## registry

A Registry is a hosted service containing [repositories](glossary.md#repository) of [images](glossary.md#image)
which responds to the Registry API.

The default registry can be accessed using a browser at [Docker Hub](glossary.md#docker-hub)
or using the `docker search` command.

## repository

A repository is a set of Docker images. A repository can be shared by pushing it
to a [registry](glossary.md#registry) server. The different images in the repository can be
labeled using [tags](glossary.md#tag).

Here is an example of the shared [nginx repository](https://hub.docker.com/_/nginx/)
and its [tags](https://hub.docker.com/r/library/nginx/tags/)


## service

A [service](../swarm/how-swarm-mode-works/services.md) is the definition of how
you want to run your application containers in a swarm. At the most basic level
a service  defines which container image to run in the swarm and which commands
to run in the container. For orchestration purposes, the service defines the
"desired state", meaning how many containers to run as tasks and constraints for
deploying the containers.

Frequently a service is a microservice within the context of some larger
application. Examples of services might include an HTTP server, a database, or
any other type of executable program that you wish to run in a distributed
environment.

## service discovery

Swarm mode [service discovery](../swarm/networking.md) is a DNS component
internal to the swarm that automatically assigns each service on an overlay
network in the swarm a VIP and DNS entry. Containers on the network share DNS
mappings for the service via gossip so any container on the network can access
the service via its service name.

You don‚Äôt need to expose service-specific ports to make the service available to
other services on the same overlay network. The swarm‚Äôs internal load balancer
automatically distributes requests to the service VIP among the active tasks.

## swarm

A [swarm](../swarm/index.md) is a cluster of one or more Docker Engines running in [swarm mode](glossary.md#swarm-mode).

## Swarm

Do not confuse [Docker Swarm](https://github.com/docker/swarm) with the [swarm mode](glossary.md#swarm-mode) features in Docker Engine.

Docker Swarm is the name of a standalone native clustering tool for Docker.
Docker Swarm pools together several Docker hosts and exposes them as a single
virtual Docker host. It serves the standard Docker API, so any tool that already
works with Docker can now transparently scale up to multiple hosts.

*Also known as : docker-swarm*

## swarm mode

[Swarm mode](../swarm/index.md) refers to cluster management and orchestration
features embedded in Docker Engine. When you initialize a new swarm (cluster) or
join nodes to a swarm, the Docker Engine runs in swarm mode.

## tag

A tag is a label applied to a Docker image in a [repository](glossary.md#repository).
tags are how various images in a repository are distinguished from each other.

*Note : This label is not related to the key=value labels set for docker daemon*

## task

A [task](../swarm/how-swarm-mode-works/services.md#tasks-and-scheduling) is the
atomic unit of scheduling within a swarm. A task carries a Docker container and
the commands to run inside the container. Manager nodes assign tasks to worker
nodes according to the number of replicas set in the service scale.

The diagram below illustrates the relationship of services to tasks and
containers.

![services diagram](../swarm/images/services-diagram.png)

## Toolbox

Docker Toolbox is the installer for Mac and Windows users.


## Union file system

Union file systems, or UnionFS, are file systems that operate by creating layers, making them
very lightweight and fast. Docker uses union file systems to provide the building
blocks for containers.


## virtual machine

A virtual machine is a program that emulates a complete computer and imitates dedicated hardware.
It shares physical hardware resources with other users but isolates the operating system. The
end user has the same experience on a Virtual Machine as they would have on dedicated hardware.

Compared to containers, a virtual machine is heavier to run, provides more isolation,
gets its own set of resources and does minimal sharing.

*Also known as : VM*
                                                                                                                                                          go/src/github.com/docker/docker/docs/reference/index.md                                             0100644 0000000 0000000 00000000443 13101060260 021523  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/
description: Docker Engine reference
keywords:
- Engine
title: Engine reference
---

# Engine reference

* [Dockerfile reference](builder.md)
* [Docker run reference](run.md)
* [Command line reference](commandline/index.md)
* [API Reference](api/index.md)
                                                                                                                                                                                                                             go/src/github.com/docker/docker/docs/reference/run.md                                               0100644 0000000 0000000 00000215525 13101060260 021231  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        ---
redirect_from:
  - /reference/run/
description: Configure containers at runtime
keywords:
- docker, run, configure,  runtime
title: Docker run reference
---

Docker runs processes in isolated containers. A container is a process
which runs on a host. The host may be local or remote. When an operator
executes `docker run`, the container process that runs is isolated in
that it has its own file system, its own networking, and its own
isolated process tree separate from the host.

This page details how to use the `docker run` command to define the
container's resources at runtime.

## General form

The basic `docker run` command takes this form:

    $ docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]

The `docker run` command must specify an [*IMAGE*](glossary.md#image)
to derive the container from. An image developer can define image
defaults related to:

 * detached or foreground running
 * container identification
 * network settings
 * runtime constraints on CPU and memory

With the `docker run [OPTIONS]` an operator can add to or override the
image defaults set by a developer. And, additionally, operators can
override nearly all the defaults set by the Docker runtime itself. The
operator's ability to override image and Docker runtime defaults is why
[*run*](commandline/run.md) has more options than any
other `docker` command.

To learn how to interpret the types of `[OPTIONS]`, see [*Option
types*](commandline/cli.md#option-types).

> **Note**: Depending on your Docker system configuration, you may be
> required to preface the `docker run` command with `sudo`. To avoid
> having to use `sudo` with the `docker` command, your system
> administrator can create a Unix group called `docker` and add users to
> it. For more information about this configuration, refer to the Docker
> installation documentation for your operating system.


## Operator exclusive options

Only the operator (the person executing `docker run`) can set the
following options.

 - [Detached vs foreground](run.md#detached-vs-foreground)
     - [Detached (-d)](run.md#detached--d)
     - [Foreground](run.md#foreground)
 - [Container identification](run.md#container-identification)
     - [Name (--name)](run.md#name---name)
     - [PID equivalent](run.md#pid-equivalent)
 - [IPC settings (--ipc)](run.md#ipc-settings---ipc)
 - [Network settings](run.md#network-settings)
 - [Restart policies (--restart)](run.md#restart-policies---restart)
 - [Clean up (--rm)](run.md#clean-up---rm)
 - [Runtime constraints on resources](run.md#runtime-constraints-on-resources)
 - [Runtime privilege and Linux capabilities](run.md#runtime-privilege-and-linux-capabilities)

## Detached vs foreground

When starting a Docker container, you must first decide if you want to
run the container in the background in a "detached" mode or in the
default foreground mode:

    -d=false: Detached mode: Run container in the background, print new container id

### Detached (-d)

To start a container in detached mode, you use `-d=true` or just `-d` option. By
design, containers started in detached mode exit when the root process used to
run the container exits. A container in detached mode cannot be automatically
removed when it stops, this means you cannot use the `--rm` option with `-d` option.

Do not pass a `service x start` command to a detached container. For example, this
command attempts to start the `nginx` service.

    $ docker run -d -p 80:80 my_image service nginx start

This succeeds in starting the `nginx` service inside the container. However, it
fails the detached container paradigm in that, the root process (`service nginx
start`) returns and the detached container stops as designed. As a result, the
`nginx` service is started but could not be used. Instead, to start a process
such as the `nginx` web server do the following:

    $ docker run -d -p 80:80 my_image nginx -g 'daemon off;'

To do input/output with a detached container use network connections or shared
volumes. These are required because the container is no longer listening to the
command line where `docker run` was run.

To reattach to a detached container, use `docker`
[*attach*](commandline/attach.md) command.

### Foreground

In foreground mode (the default when `-d` is not specified), `docker
run` can start the process in the container and attach the console to
the process's standard input, output, and standard error. It can even
pretend to be a TTY (this is what most command line executables expect)
and pass along signals. All of that is configurable:

    -a=[]           : Attach to `STDIN`, `STDOUT` and/or `STDERR`
    -t              : Allocate a pseudo-tty
    --sig-proxy=true: Proxy all received signals to the process (non-TTY mode only)
    -i              : Keep STDIN open even if not attached

If you do not specify `-a` then Docker will [attach all standard
streams]( https://github.com/docker/docker/blob/75a7f4d90cde0295bcfb7213004abce8d4779b75/commands.go#L1797).
You can specify to which of the three standard streams (`STDIN`, `STDOUT`,
`STDERR`) you'd like to connect instead, as in:

    $ docker run -a stdin -a stdout -i -t ubuntu /bin/bash

For interactive processes (like a shell), you must use `-i -t` together in
order to allocate a tty for the container process. `-i -t` is often written `-it`
as you'll see in later examples.  Specifying `-t` is forbidden when the client
standard output is redirected or piped, such as in:

    $ echo test | docker run -i busybox cat

>**Note**: A process running as PID 1 inside a container is treated
>specially by Linux: it ignores any signal with the default action.
>So, the process will not terminate on `SIGINT` or `SIGTERM` unless it is
>coded to do so.

## Container identification

### Name (--name)

The operator can identify a container in three ways:

| Identifier type       | Example value                                                      |
| --------------------- | ------------------------------------------------------------------ |
| UUID long identifier  | "f78375b1c487e03c9438c729345e54db9d20cfa2ac1fc3494b6eb60872e74778" |
| UUID short identifier | "f78375b1c487"                                                     |
| Name                  | "evil_ptolemy"                                                     |

The UUID identifiers come from the Docker daemon. If you do not assign a
container name with the `--name` option, then the daemon generates a random
string name for you. Defining a `name` can be a handy way to add meaning to a
container. If you specify a `name`, you can use it  when referencing the
container within a Docker network. This works for both background and foreground
Docker containers.

> **Note**: Containers on the default bridge network must be linked to
> communicate by name.

### PID equivalent

Finally, to help with automation, you can have Docker write the
container ID out to a file of your choosing. This is similar to how some
programs might write out their process ID to a file (you've seen them as
PID files):

    --cidfile="": Write the container ID to the file

### Image[:tag]

While not strictly a means of identifying a container, you can specify a version of an
image you'd like to run the container with by adding `image[:tag]` to the command. For
example, `docker run ubuntu:14.04`.

### Image[@digest]

Images using the v2 or later image format have a content-addressable identifier
called a digest. As long as the input used to generate the image is unchanged,
the digest value is predictable and referenceable.

The following example runs a container from the `alpine` image with the
`sha256:9cacb71397b640eca97488cf08582ae4e4068513101088e9f96c9814bfda95e0` digest:

    $ docker run alpine@sha256:9cacb71397b640eca97488cf08582ae4e4068513101088e9f96c9814bfda95e0 date

## PID settings (--pid)

    --pid=""  : Set the PID (Process) Namespace mode for the container,
                 'container:<name|id>': joins another container's PID namespace
                 'host': use the host's PID namespace inside the container

By default, all containers have the PID namespace enabled.

PID namespace provides separation of processes. The PID Namespace removes the
view of the system processes, and allows process ids to be reused including
pid 1.

In certain cases you want your container to share the host's process namespace,
basically allowing processes within the container to see all of the processes
on the system.  For example, you could build a container with debugging tools
like `strace` or `gdb`, but want to use these tools when debugging processes
within the container.

### Example: run htop inside a container

Create this Dockerfile:

```
FROM alpine:latest
RUN apk add --update htop && rm -rf /var/cache/apk/*
CMD ["htop"]
```

Build the Dockerfile and tag the image as `myhtop`:

```bash
$ docker build -t myhtop .
```

Use the following command to run `htop` inside a container:

```
$ docker run -it --rm --pid=host myhtop
```

Joining another container's pid namespace can be used for debugging that container.

### Example

Start a container running a redis server:

```bash
$ docker run --name my-redis -d redis
```

Debug the redis container by running another container that has strace in it:

```bash
$ docker run -it --pid=container:my-redis my_strace_docker_image bash
$ strace -p 1
```

## UTS settings (--uts)

    --uts=""  : Set the UTS namespace mode for the container,
           'host': use the host's UTS namespace inside the container

The UTS namespace is for setting the hostname and the domain that is visible
to running processes in that namespace.  By default, all containers, including
those with `--network=host`, have their own UTS namespace.  The `host` setting will
result in the container using the same UTS namespace as the host.  Note that
`--hostname` is invalid in `host` UTS mode.

You may wish to share the UTS namespace with the host if you would like the
hostname of the container to change as the hostname of the host changes.  A
more advanced use case would be changing the host's hostname from a container.

## IPC settings (--ipc)

    --ipc=""  : Set the IPC mode for the container,
                 'container:<name|id>': reuses another container's IPC namespace
                 'host': use the host's IPC namespace inside the container

By default, all containers have the IPC namespace enabled.

IPC (POSIX/SysV IPC) namespace provides separation of named shared memory
segments, semaphores and message queues.

Shared memory segments are used to accelerate inter-process communication at
memory speed, rather than through pipes or through the network stack. Shared
memory is commonly used by databases and custom-built (typically C/OpenMPI,
C++/using boost libraries) high performance applications for scientific
computing and financial services industries. If these types of applications
are broken into multiple containers, you might need to share the IPC mechanisms
of the containers.

## Network settings

    --dns=[]           : Set custom dns servers for the container
    --network="bridge" : Connect a container to a network
                          'bridge': create a network stack on the default Docker bridge
                          'none': no networking
                          'container:<name|id>': reuse another container's network stack
                          'host': use the Docker host network stack
                          '<network-name>|<network-id>': connect to a user-defined network
    --network-alias=[] : Add network-scoped alias for the container
    --add-host=""      : Add a line to /etc/hosts (host:IP)
    --mac-address=""   : Sets the container's Ethernet device's MAC address
    --ip=""            : Sets the container's Ethernet device's IPv4 address
    --ip6=""           : Sets the container's Ethernet device's IPv6 address
    --link-local-ip=[] : Sets one or more container's Ethernet device's link local IPv4/IPv6 addresses

By default, all containers have networking enabled and they can make any
outgoing connections. The operator can completely disable networking
with `docker run --network none` which disables all incoming and outgoing
networking. In cases like this, you would perform I/O through files or
`STDIN` and `STDOUT` only.

Publishing ports and linking to other containers only works with the default (bridge). The linking feature is a legacy feature. You should always prefer using Docker network drivers over linking.

Your container will use the same DNS servers as the host by default, but
you can override this with `--dns`.

By default, the MAC address is generated using the IP address allocated to the
container. You can set the container's MAC address explicitly by providing a
MAC address via the `--mac-address` parameter (format:`12:34:56:78:9a:bc`).Be
aware that Docker does not check if manually specified MAC addresses are unique.

Supported networks :

<table>
  <thead>
    <tr>
      <th class="no-wrap">Network</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td class="no-wrap"><strong>none</strong></td>
      <td>
        No networking in the container.
      </td>
    </tr>
    <tr>
      <td class="no-wrap"><strong>bridge</strong> (default)</td>
      <td>
        Connect the container to the bridge via veth interfaces.
      </td>
    </tr>
    <tr>
      <td class="no-wrap"><strong>host</strong></td>
      <td>
        Use the host's network stack inside the container.
      </td>
    </tr>
    <tr>
      <td class="no-wrap"><strong>container</strong>:&lt;name|id&gt;</td>
      <td>
        Use the network stack of another container, specified via
        its <i>name</i> or <i>id</i>.
      </td>
    </tr>
    <tr>
      <td class="no-wrap"><strong>NETWORK</strong></td>
      <td>
        Connects the container to a user created network (using <code>docker network create</code> command)
      </td>
    </tr>
  </tbody>
</table>

#### Network: none

With the network is `none` a container will not have
access to any external routes.  The container will still have a
`loopback` interface enabled in the container but it does not have any
routes to external traffic.

#### Network: bridge

With the network set to `bridge` a container will use docker's
default networking setup.  A bridge is setup on the host, commonly named
`docker0`, and a pair of `veth` interfaces will be created for the
container.  One side of the `veth` pair will remain on the host attached
to the bridge while the other side of the pair will be placed inside the
container's namespaces in addition to the `loopback` interface.  An IP
address will be allocated for containers on the bridge's network and
traffic will be routed though this bridge to the container.

Containers can communicate via their IP addresses by default. To communicate by
name, they must be linked.

#### Network: host

With the network set to `host` a container will share the host's
network stack and all interfaces from the host will be available to the
container.  The container's hostname will match the hostname on the host
system. Note that `--mac-address` is invalid in `host` netmode. Even in `host`
network mode a container has its own UTS namespace by default. As such
`--hostname` is allowed in `host` network mode and will only change the
hostname inside the container.
Similar to `--hostname`, the `--add-host`, `--dns`, `--dns-search`, and
`--dns-opt` options can be used in `host` network mode. These options update
`/etc/hosts` or `/etc/resolv.conf` inside the container. No change are made to
`/etc/hosts` and `/etc/resolv.conf` on the host.

Compared to the default `bridge` mode, the `host` mode gives *significantly*
better networking performance since it uses the host's native networking stack
whereas the bridge has to go through one level of virtualization through the
docker daemon. It is recommended to run containers in this mode when their
networking performance is critical, for example, a production Load Balancer
or a High Performance Web Server.

> **Note**: `--network="host"` gives the container full access to local system
> services such as D-bus and is therefore considered insecure.

#### Network: container

With the network set to `container` a container will share the
network stack of another container.  The other container's name must be
provided in the format of `--network container:<name|id>`. Note that `--add-host`
`--hostname` `--dns` `--dns-search` `--dns-opt` and `--mac-address` are
invalid in `container` netmode, and `--publish` `--publish-all` `--expose` are
also invalid in `container` netmode.

Example running a Redis container with Redis binding to `localhost` then
running the `redis-cli` command and connecting to the Redis server over the
`localhost` interface.

    $ docker run -d --name redis example/redis --bind 127.0.0.1
    $ # use the redis container's network stack to access localhost
    $ docker run --rm -it --network container:redis example/redis-cli -h 127.0.0.1

#### User-defined network

You can create a network using a Docker network driver or an external network
driver plugin. You can connect multiple containers to the same network. Once
connected to a user-defined network, the containers can communicate easily using
only another container's IP address or name.

For `overlay` networks or custom plugins that support multi-host connectivity,
containers connected to the same multi-host network but launched from different
Engines can also communicate in this way.

The following example creates a network using the built-in `bridge` network
driver and running a container in the created network

```
$ docker network create -d bridge my-net
$ docker run --network=my-net -itd --name=container3 busybox
```

### Managing /etc/hosts

Your container will have lines in `/etc/hosts` which define the hostname of the
container itself as well as `localhost` and a few other common things. The
`--add-host` flag can be used to add additional lines to `/etc/hosts`.

    $ docker run -it --add-host db-static:86.75.30.9 ubuntu cat /etc/hosts
    172.17.0.22     09d03f76bf2c
    fe00::0         ip6-localnet
    ff00::0         ip6-mcastprefix
    ff02::1         ip6-allnodes
    ff02::2         ip6-allrouters
    127.0.0.1       localhost
    ::1	            localhost ip6-localhost ip6-loopback
    86.75.30.9      db-static

If a container is connected to the default bridge network and `linked`
with other containers, then the container's `/etc/hosts` file is updated
with the linked container's name.

If the container is connected to user-defined network, the container's
`/etc/hosts` file is updated with names of all other containers in that
user-defined network.

> **Note** Since Docker may live update the container‚Äôs `/etc/hosts` file, there
may be situations when processes inside the container can end up reading an
empty or incomplete `/etc/hosts` file. In most cases, retrying the read again
should fix the problem.

## Restart policies (--restart)

Using the `--restart` flag on Docker run you can specify a restart policy for
how a container should or should not be restarted on exit.

When a restart policy is active on a container, it will be shown as either `Up`
or `Restarting` in [`docker ps`](commandline/ps.md). It can also be
useful to use [`docker events`](commandline/events.md) to see the
restart policy in effect.

Docker supports the following restart policies:

<table>
  <thead>
    <tr>
      <th>Policy</th>
      <th>Result</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>no</strong></td>
      <td>
        Do not automatically restart the container when it exits. This is the
        default.
      </td>
    </tr>
    <tr>
      <td>
        <span style="white-space: nowrap">
          <strong>on-failure</strong>[:max-retries]
        </span>
      </td>
      <td>
        Restart only if the container exits with a non-zero exit status.
        Optionally, limit the number of restart retries the Docker
        daemon attempts.
      </td>
    </tr>
    <tr>
      <td><strong>always</strong></td>
      <td>
        Always restart the container regardless of the exit status.
        When you specify always, the Docker daemon will try to restart
        the container indefinitely. The container will also always start
        on daemon startup, regardless of the current state of the container.
      </td>
    </tr>
    <tr>
      <td><strong>unless-stopped</strong></td>
      <td>
        Always restart the container regardless of the exit status, but
        do not start it on daemon startup if the container has been put
        to a stopped state before.
      </td>
    </tr>
  </tbody>
</table>

An ever increasing delay (double the previous delay, starting at 100
milliseconds) is added before each restart to prevent flooding the server.
This means the daemon will wait for 100 ms, then 200 ms, 400, 800, 1600,
and so on until either the `on-failure` limit is hit, or when you `docker stop`
or `docker rm -f` the container.

If a container is successfully restarted (the container is started and runs
for at least 10 seconds), the delay is reset to its default value of 100 ms.

You can specify the maximum amount of times Docker will try to restart the
container when using the **on-failure** policy.  The default is that Docker
will try forever to restart the container. The number of (attempted) restarts
for a container can be obtained via [`docker inspect`](commandline/inspect.md). For example, to get the number of restarts
for container "my-container";

    {% raw %}
    $ docker inspect -f "{{ .RestartCount }}" my-container
    # 2
    {% endraw %}

Or, to get the last time the container was (re)started;

    {% raw %}
    $ docker inspect -f "{{ .State.StartedAt }}" my-container
    # 2015-03-04T23:47:07.691840179Z
    {% endraw %}


Combining `--restart` (restart policy) with the `--rm` (clean up) flag results
in an error. On container restart, attached clients are disconnected. See the
examples on using the [`--rm` (clean up)](run.md#clean-up-rm) flag later in this page.

### Examples

    $ docker run --restart=always redis

This will run the `redis` container with a restart policy of **always**
so that if the container exits, Docker will restart it.

    $ docker run --restart=on-failure:10 redis

This will run the `redis` container with a restart policy of **on-failure**
and a maximum restart count of 10.  If the `redis` container exits with a
non-zero exit status more than 10 times in a row Docker will abort trying to
restart the container. Providing a maximum restart limit is only valid for the
**on-failure** policy.

## Exit Status

The exit code from `docker run` gives information about why the container
failed to run or why it exited.  When `docker run` exits with a non-zero code,
the exit codes follow the `chroot` standard, see below:

**_125_** if the error is with Docker daemon **_itself_**

    $ docker run --foo busybox; echo $?
    # flag provided but not defined: --foo
      See 'docker run --help'.
      125

**_126_** if the **_contained command_** cannot be invoked

    $ docker run busybox /etc; echo $?
    # docker: Error response from daemon: Container command '/etc' could not be invoked.
      126

**_127_** if the **_contained command_** cannot be found

    $ docker run busybox foo; echo $?
    # docker: Error response from daemon: Container command 'foo' not found or does not exist.
      127

**_Exit code_** of **_contained command_** otherwise

    $ docker run busybox /bin/sh -c 'exit 3'; echo $?
    # 3

## Clean up (--rm)

By default a container's file system persists even after the container
exits. This makes debugging a lot easier (since you can inspect the
final state) and you retain all your data by default. But if you are
running short-term **foreground** processes, these container file
systems can really pile up. If instead you'd like Docker to
**automatically clean up the container and remove the file system when
the container exits**, you can add the `--rm` flag:

    --rm=false: Automatically remove the container when it exits (incompatible with -d)

> **Note**: When you set the `--rm` flag, Docker also removes the volumes
associated with the container when the container is removed. This is similar
to running `docker rm -v my-container`. Only volumes that are specified without a
name are removed. For example, with
`docker run --rm -v /foo -v awesome:/bar busybox top`, the volume for `/foo` will be removed,
but the volume for `/bar` will not. Volumes inherited via `--volumes-from` will be removed
with the same logic -- if the original volume was specified with a name it will **not** be removed.

## Security configuration
    --security-opt="label=user:USER"     : Set the label user for the container
    --security-opt="label=role:ROLE"     : Set the label role for the container
    --security-opt="label=type:TYPE"     : Set the label type for the container
    --security-opt="label=level:LEVEL"   : Set the label level for the container
    --security-opt="label=disable"       : Turn off label confinement for the container
    --security-opt="apparmor=PROFILE"    : Set the apparmor profile to be applied to the container
    --security-opt="no-new-privileges"   : Disable container processes from gaining new privileges
    --security-opt="seccomp=unconfined"  : Turn off seccomp confinement for the container
    --security-opt="seccomp=profile.json": White listed syscalls seccomp Json file to be used as a seccomp filter


You can override the default labeling scheme for each container by specifying
the `--security-opt` flag. Specifying the level in the following command
allows you to share the same content between containers.

    $ docker run --security-opt label=level:s0:c100,c200 -it fedora bash

> **Note**: Automatic translation of MLS labels is not currently supported.

To disable the security labeling for this container versus running with the
`--privileged` flag, use the following command:

    $ docker run --security-opt label=disable -it fedora bash

If you want a tighter security policy on the processes within a container,
you can specify an alternate type for the container. You could run a container
that is only allowed to listen on Apache ports by executing the following
command:

    $ docker run --security-opt label=type:svirt_apache_t -it centos bash

> **Note**: You would have to write policy defining a `svirt_apache_t` type.

If you want to prevent your container processes from gaining additional
privileges, you can execute the following command:

    $ docker run --security-opt no-new-privileges -it centos bash

This means that commands that raise privileges such as `su` or `sudo` will no longer work.
It also causes any seccomp filters to be applied later, after privileges have been dropped
which may mean you can have a more restrictive set of filters.
For more details, see the [kernel documentation](https://www.kernel.org/doc/Documentation/prctl/no_new_privs.txt).

## Specifying custom cgroups

Using the `--cgroup-parent` flag, you can pass a specific cgroup to run a
container in. This allows you to create and manage cgroups on their own. You can
define custom resources for those cgroups and put containers under a common
parent group.

## Runtime constraints on resources

The operator can also adjust the performance parameters of the
container:

| Option                     |  Description                                                                                                                                    |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `-m`, `--memory=""`        | Memory limit (format: `<number>[<unit>]`). Number is a positive integer. Unit can be one of `b`, `k`, `m`, or `g`. Minimum is 4M.               |
| `--memory-swap=""`         | Total memory limit (memory + swap, format: `<number>[<unit>]`). Number is a positive integer. Unit can be one of `b`, `k`, `m`, or `g`.         |
| `--memory-reservation=""`  | Memory soft limit (format: `<number>[<unit>]`). Number is a positive integer. Unit can be one of `b`, `k`, `m`, or `g`.                         |
| `--kernel-memory=""`       | Kernel memory limit (format: `<number>[<unit>]`). Number is a positive integer. Unit can be one of `b`, `k`, `m`, or `g`. Minimum is 4M.        |
| `-c`, `--cpu-shares=0`     | CPU shares (relative weight)                                                                                                                    |
| `--cpu-period=0`           | Limit the CPU CFS (Completely Fair Scheduler) period                                                                                            |
| `--cpuset-cpus=""`         | CPUs in which to allow execution (0-3, 0,1)                                                                                                     |
| `--cpuset-mems=""`         | Memory nodes (MEMs) in which to allow execution (0-3, 0,1). Only effective on NUMA systems.                                                     |
| `--cpu-quota=0`            | Limit the CPU CFS (Completely Fair Scheduler) quota                                                                                             |
| `--blkio-weight=0`         | Block IO weight (relative weight) accepts a weight value between 10 and 1000.                                                                   |
| `--blkio-weight-device=""` | Block IO weight (relative device weight, format: `DEVICE_NAME:WEIGHT`)                                                                          |
| `--device-read-bps=""`     | Limit read rate from a device (format: `<device-path>:<number>[<unit>]`). Number is a positive integer. Unit can be one of `kb`, `mb`, or `gb`. |
| `--device-write-bps=""`    | Limit write rate to a device (format: `<device-path>:<number>[<unit>]`). Number is a positive integer. Unit can be one of `kb`, `mb`, or `gb`.  |
| `--device-read-iops="" `   | Limit read rate (IO per second) from a device (format: `<device-path>:<number>`). Number is a positive integer.                                 |
| `--device-write-iops="" `  | Limit write rate (IO per second) to a device (format: `<device-path>:<number>`). Number is a positive integer.                                  |
| `--oom-kill-disable=false` | Whether to disable OOM Killer for the container or not.                                                                                         |
| `--oom-score-adj=0`        | Tune container's OOM preferences (-1000 to 1000)                                                                                                |
| `--memory-swappiness=""`   | Tune a container's memory swappiness behavior. Accepts an integer between 0 and 100.                                                            |
| `--shm-size=""`            | Size of `/dev/shm`. The format is `<number><unit>`. `number` must be greater than `0`. Unit is optional and can be `b` (bytes), `k` (kilobytes), `m` (megabytes), or `g` (gigabytes). If you omit the unit, the system uses bytes. If you omit the size entirely, the system uses `64m`. |

### User memory constraints

We have four ways to set user memory usage:

<table>
  <thead>
    <tr>
      <th>Option</th>
      <th>Result</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td class="no-wrap">
          <strong>memory=inf, memory-swap=inf</strong> (default)
      </td>
      <td>
        There is no memory limit for the container. The container can use
        as much memory as needed.
      </td>
    </tr>
    <tr>
      <td class="no-wrap"><strong>memory=L&lt;inf, memory-swap=inf</strong></td>
      <td>
        (specify memory and set memory-swap as <code>-1</code>) The container is
        not allowed to use more than L bytes of memory, but can use as much swap
        as is needed (if the host supports swap memory).
      </td>
    </tr>
    <tr>
      <td class="no-wrap"><strong>memory=L&lt;inf, memory-swap=2*L</strong></td>
      <td>
        (specify memory without memory-swap) The container is not allowed to
        use more than L bytes of memory, swap <i>plus</i> memory usage is double
        of that.
      </td>
    </tr>
    <tr>
      <td class="no-wrap">
          <strong>memory=L&lt;inf, memory-swap=S&lt;inf, L&lt;=S</strong>
      </td>
      <td>
        (specify both memory and memory-swap) The container is not allowed to
        use more than L bytes of memory, swap <i>plus</i> memory usage is limited
        by S.
      </td>
    </tr>
  </tbody>
</table>

Examples:

    $ docker run -it ubuntu:14.04 /bin/bash

We set nothing about memory, this means the processes in the container can use
as much memory and swap memory as they need.

    $ docker run -it -m 300M --memory-swap -1 ubuntu:14.04 /bin/bash

We set memory limit and disabled swap memory limit, this means the processes in
the container can use 300M memory and as much swap memory as they need (if the
host supports swap memory).

    $ docker run -it -m 300M ubuntu:14.04 /bin/bash

We set memory limit only, this means the processes in the container can use
300M memory and 300M swap memory, by default, the total virtual memory size
(--memory-swap) will be set as double of memory, in this case, memory + swap
would be 2*300M, so processes can use 300M swap memory as well.

    $ docker run -it -m 300M --memory-swap 1G ubuntu:14.04 /bin/bash

We set both memory and swap memory, so the processes in the container can use
300M memory and 700M swap memory.

Memory reservation is a kind of memory soft limit that allows for greater
sharing of memory. Under normal circumstances, containers can use as much of
the memory as needed and are constrained only by the hard limits set with the
`-m`/`--memory` option. When memory reservation is set, Docker detects memory
contention or low memory and forces containers to restrict their consumption to
a reservation limit.

Always set the memory reservation value below the hard limit, otherwise the hard
limit takes precedence. A reservation of 0 is the same as setting no
reservation. By default (without reservation set), memory reservation is the
same as the hard memory limit.

Memory reservation is a soft-limit feature and does not guarantee the limit
won't be exceeded. Instead, the feature attempts to ensure that, when memory is
heavily contended for, memory is allocated based on the reservation hints/setup.

The following example limits the memory (`-m`) to 500M and sets the memory
reservation to 200M.

```bash
$ docker run -it -m 500M --memory-reservation 200M ubuntu:14.04 /bin/bash
```

Under this configuration, when the container consumes memory more than 200M and
less than 500M, the next system memory reclaim attempts to shrink container
memory below 200M.

The following example set memory reservation to 1G without a hard memory limit.

```bash
$ docker run -it --memory-reservation 1G ubuntu:14.04 /bin/bash
```

The container can use as much memory as it needs. The memory reservation setting
ensures the container doesn't consume too much memory for long time, because
every memory reclaim shrinks the container's consumption to the reservation.

By default, kernel kills processes in a container if an out-of-memory (OOM)
error occurs. To change this behaviour, use the `--oom-kill-disable` option.
Only disable the OOM killer on containers where you have also set the
`-m/--memory` option. If the `-m` flag is not set, this can result in the host
running out of memory and require killing the host's system processes to free
memory.

The following example limits the memory to 100M and disables the OOM killer for
this container:

    $ docker run -it -m 100M --oom-kill-disable ubuntu:14.04 /bin/bash

The following example, illustrates a dangerous way to use the flag:

    $ docker run -it --oom-kill-disable ubuntu:14.04 /bin/bash

The container has unlimited memory which can cause the host to run out memory
and require killing system processes to free memory. The `--oom-score-adj`
parameter can be changed to select the priority of which containers will
be killed when the system is out of memory, with negative scores making them
less likely to be killed an positive more likely.

### Kernel memory constraints

Kernel memory is fundamentally different than user memory as kernel memory can't
be swapped out. The inability to swap makes it possible for the container to
block system services by consuming too much kernel memory. Kernel memory includesÔºö

 - stack pages
 - slab pages
 - sockets memory pressure
 - tcp memory pressure

You can setup kernel memory limit to constrain these kinds of memory. For example,
every process consumes some stack pages. By limiting kernel memory, you can
prevent new processes from being created when the kernel memory usage is too high.

Kernel memory is never completely independent of user memory. Instead, you limit
kernel memory in the context of the user memory limit. Assume "U" is the user memory
limit and "K" the kernel limit. There are three possible ways to set limits:

<table>
  <thead>
    <tr>
      <th>Option</th>
      <th>Result</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td class="no-wrap"><strong>U != 0, K = inf</strong> (default)</td>
      <td>
        This is the standard memory limitation mechanism already present before using
        kernel memory. Kernel memory is completely ignored.
      </td>
    </tr>
    <tr>
      <td class="no-wrap"><strong>U != 0, K &lt; U</strong></td>
      <td>
        Kernel memory is a subset of the user memory. This setup is useful in
        deployments where the total amount of memory per-cgroup is overcommitted.
        Overcommitting kernel memory limits is definitely not recommended, since the
        box can still run out of non-reclaimable memory.
        In this case, you can configure K so that the sum of all groups is
        never greater than the total memory. Then, freely set U at the expense of
        the system's service quality.
      </td>
    </tr>
    <tr>
      <td class="no-wrap"><strong>U != 0, K &gt; U</strong></td>
      <td>
        Since kernel memory charges are also fed to the user counter and reclamation
        is triggered for the container for both kinds of memory. This configuration
        gives the admin a unified view of memory. It is also useful for people
        who just want to track kernel memory usage.
      </td>
    </tr>
  </tbody>
</table>

Examples:

    $ docker run -it -m 500M --kernel-memory 50M ubuntu:14.04 /bin/bash

We set memory and kernel memory, so the processes in the container can use
500M memory in total, in this 500M memory, it can be 50M kernel memory tops.

    $ docker run -it --kernel-memory 50M ubuntu:14.04 /bin/bash

We set kernel memory without **-m**, so the processes in the container can
use as much memory as they want, but they can only use 50M kernel memory.

### Swappiness constraint

By default, a container's kernel can swap out a percentage of anonymous pages.
To set this percentage for a container, specify a `--memory-swappiness` value
between 0 and 100. A value of 0 turns off anonymous page swapping. A value of
100 sets all anonymous pages as swappable. By default, if you are not using
`--memory-swappiness`, memory swappiness value will be inherited from the parent.

For example, you can set:

    $ docker run -it --memory-swappiness=0 ubuntu:14.04 /bin/bash

Setting the `--memory-swappiness` option is helpful when you want to retain the
container's working set and to avoid swapping performance penalties.

### CPU share constraint

By default, all containers get the same proportion of CPU cycles. This proportion
can be modified by changing the container's CPU share weighting relative
to the weighting of all other running containers.

To modify the proportion from the default of 1024, use the `-c` or `--cpu-shares`
flag to set the weighting to 2 or higher. If 0 is set, the system will ignore the
value and use the default of 1024.

The proportion will only apply when CPU-intensive processes are running.
When tasks in one container are idle, other containers can use the
left-over CPU time. The actual amount of CPU time will vary depending on
the number of containers running on the system.

For example, consider three containers, one has a cpu-share of 1024 and
two others have a cpu-share setting of 512. When processes in all three
containers attempt to use 100% of CPU, the first container would receive
50% of the total CPU time. If you add a fourth container with a cpu-share
of 1024, the first container only gets 33% of the CPU. The remaining containers
receive 16.5%, 16.5% and 33% of the CPU.

On a multi-core system, the shares of CPU time are distributed over all CPU
cores. Even if a container is limited to less than 100% of CPU time, it can
use 100% of each individual CPU core.

For example, consider a system with more than three cores. If you start one
container `{C0}` with `-c=512` running one process, and another container
`{C1}` with `-c=1024` running two processes, this can result in the following
division of CPU shares:

    PID    container	CPU	CPU share
    100    {C0}		0	100% of CPU0
    101    {C1}		1	100% of CPU1
    102    {C1}		2	100% of CPU2

### CPU period constraint

The default CPU CFS (Completely Fair Scheduler) period is 100ms. We can use
`--cpu-period` to set the period of CPUs to limit the container's CPU usage.
And usually `--cpu-period` should work with `--cpu-quota`.

Examples:

    $ docker run -it --cpu-period=50000 --cpu-quota=25000 ubuntu:14.04 /bin/bash

If there is 1 CPU, this means the container can get 50% CPU worth of run-time every 50ms.

For more information, see the [CFS documentation on bandwidth limiting](https://www.kernel.org/doc/Documentation/scheduler/sched-bwc.txt).

### Cpuset constraint

We can set cpus in which to allow execution for containers.

Examples:

    $ docker run -it --cpuset-cpus="1,3" ubuntu:14.04 /bin/bash

This means processes in container can be executed on cpu 1 and cpu 3.

    $ docker run -it --cpuset-cpus="0-2" ubuntu:14.04 /bin/bash

This means processes in container can be executed on cpu 0, cpu 1 and cpu 2.

We can set mems in which to allow execution for containers. Only effective
on NUMA systems.

Examples:

    $ docker run -it --cpuset-mems="1,3" ubuntu:14.04 /bin/bash

This example restricts the processes in the container to only use memory from
memory nodes 1 and 3.

    $ docker run -it --cpuset-mems="0-2" ubuntu:14.04 /bin/bash

This example restricts the processes in the container to only use memory from
memory nodes 0, 1 and 2.

### CPU quota constraint

The `--cpu-quota` flag limits the container's CPU usage. The default 0 value
allows the container to take 100% of a CPU resource (1 CPU). The CFS (Completely Fair
Scheduler) handles resource allocation for executing processes and is default
Linux Scheduler used by the kernel. Set this value to 50000 to limit the container
to 50% of a CPU resource. For multiple CPUs, adjust the `--cpu-quota` as necessary.
For more information, see the [CFS documentation on bandwidth limiting](https://www.kernel.org/doc/Documentation/scheduler/sched-bwc.txt).

### Block IO bandwidth (Blkio) constraint

By default, all containers get the same proportion of block IO bandwidth
(blkio). This proportion is 500. To modify this proportion, change the
container's blkio weight relative to the weighting of all other running
containers using the `--blkio-weight` flag.

> **Note:** The blkio weight setting is only available for direct IO. Buffered IO
> is not currently supported.

The `--blkio-weight` flag can set the weighting to a value between 10 to 1000.
For example, the commands below create two containers with different blkio
weight:

    $ docker run -it --name c1 --blkio-weight 300 ubuntu:14.04 /bin/bash
    $ docker run -it --name c2 --blkio-weight 600 ubuntu:14.04 /bin/bash

If you do block IO in the two containers at the same time, by, for example:

    $ time dd if=/mnt/zerofile of=test.out bs=1M count=1024 oflag=direct

You'll find that the proportion of time is the same as the proportion of blkio
weights of the two containers.

The `--blkio-weight-device="DEVICE_NAME:WEIGHT"` flag sets a specific device weight.
The `DEVICE_NAME:WEIGHT` is a string containing a colon-separated device name and weight.
For example, to set `/dev/sda` device weight to `200`:

    $ docker run -it \
        --blkio-weight-device "/dev/sda:200" \
        ubuntu

If you specify both the `--blkio-weight` and `--blkio-weight-device`, Docker
uses the `--blkio-weight` as the default weight and uses `--blkio-weight-device`
to override this default with a new value on a specific device.
The following example uses a default weight of `300` and overrides this default
on `/dev/sda` setting that weight to `200`:

    $ docker run -it \
        --blkio-weight 300 \
        --blkio-weight-device "/dev/sda:200" \
        ubuntu

The `--device-read-bps` flag limits the read rate (bytes per second) from a device.
For example, this command creates a container and limits the read rate to `1mb`
per second from `/dev/sda`:

    $ docker run -it --device-read-bps /dev/sda:1mb ubuntu

The `--device-write-bps` flag limits the write rate (bytes per second)to a device.
For example, this command creates a container and limits the write rate to `1mb`
per second for `/dev/sda`:

    $ docker run -it --device-write-bps /dev/sda:1mb ubuntu

Both flags take limits in the `<device-path>:<limit>[unit]` format. Both read
and write rates must be a positive integer. You can specify the rate in `kb`
(kilobytes), `mb` (megabytes), or `gb` (gigabytes).

The `--device-read-iops` flag limits read rate (IO per second) from a device.
For example, this command creates a container and limits the read rate to
`1000` IO per second from `/dev/sda`:

    $ docker run -ti --device-read-iops /dev/sda:1000 ubuntu

The `--device-write-iops` flag limits write rate (IO per second) to a device.
For example, this command creates a container and limits the write rate to
`1000` IO per second to `/dev/sda`:

    $ docker run -ti --device-write-iops /dev/sda:1000 ubuntu

Both flags take limits in the `<device-path>:<limit>` format. Both read and
write rates must be a positive integer.

## Additional groups
    --group-add: Add additional groups to run as

By default, the docker container process runs with the supplementary groups looked
up for the specified user. If one wants to add more to that list of groups, then
one can use this flag:

    $ docker run --rm --group-add audio --group-add nogroup --group-add 777 busybox id
    uid=0(root) gid=0(root) groups=10(wheel),29(audio),99(nogroup),777

## Runtime privilege and Linux capabilities

    --cap-add: Add Linux capabilities
    --cap-drop: Drop Linux capabilities
    --privileged=false: Give extended privileges to this container
    --device=[]: Allows you to run devices inside the container without the --privileged flag.

By default, Docker containers are "unprivileged" and cannot, for
example, run a Docker daemon inside a Docker container. This is because
by default a container is not allowed to access any devices, but a
"privileged" container is given access to all devices (see
the documentation on [cgroups devices](https://www.kernel.org/doc/Documentation/cgroup-v1/devices.txt)).

When the operator executes `docker run --privileged`, Docker will enable
to access to all devices on the host as well as set some configuration
in AppArmor or SELinux to allow the container nearly all the same access to the
host as processes running outside containers on the host. Additional
information about running with `--privileged` is available on the
[Docker Blog](http://blog.docker.com/2013/09/docker-can-now-run-within-docker/).

If you want to limit access to a specific device or devices you can use
the `--device` flag. It allows you to specify one or more devices that
will be accessible within the container.

    $ docker run --device=/dev/snd:/dev/snd ...

By default, the container will be able to `read`, `write`, and `mknod` these devices.
This can be overridden using a third `:rwm` set of options to each `--device` flag:

    $ docker run --device=/dev/sda:/dev/xvdc --rm -it ubuntu fdisk  /dev/xvdc

    Command (m for help): q
    $ docker run --device=/dev/sda:/dev/xvdc:r --rm -it ubuntu fdisk  /dev/xvdc
    You will not be able to write the partition table.

    Command (m for help): q

    $ docker run --device=/dev/sda:/dev/xvdc:w --rm -it ubuntu fdisk  /dev/xvdc
        crash....

    $ docker run --device=/dev/sda:/dev/xvdc:m --rm -it ubuntu fdisk  /dev/xvdc
    fdisk: unable to open /dev/xvdc: Operation not permitted

In addition to `--privileged`, the operator can have fine grain control over the
capabilities using `--cap-add` and `--cap-drop`. By default, Docker has a default
list of capabilities that are kept. The following table lists the Linux capability
options which are allowed by default and can be dropped.

| Capability Key   | Capability Description                                                                                                        |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| SETPCAP          | Modify process capabilities.                                                                                                  |
| MKNOD            | Create special files using mknod(2).                                                                                          |
| AUDIT_WRITE      | Write records to kernel auditing log.                                                                                         |
| CHOWN            | Make arbitrary changes to file UIDs and GIDs (see chown(2)).                                                                  |
| NET_RAW          | Use RAW and PACKET sockets.                                                                                                   |
| DAC_OVERRIDE     | Bypass file read, write, and execute permission checks.                                                                       |
| FOWNER           | Bypass permission checks on operations that normally require the file system UID of the process to match the UID of the file. |
| FSETID           | Don't clear set-user-ID and set-group-ID permission bits when a file is modified.                                             |
| KILL             | Bypass permission checks for sending signals.                                                                                 |
| SETGID           | Make arbitrary manipulations of process GIDs and supplementary GID list.                                                      |
| SETUID           | Make arbitrary manipulations of process UIDs.                                                                                 |
| NET_BIND_SERVICE | Bind a socket to internet domain privileged ports (port numbers less than 1024).                                              |
| SYS_CHROOT       | Use chroot(2), change root directory.                                                                                         |
| SETFCAP          | Set file capabilities.                                                                                                        |

The next table shows the capabilities which are not granted by default and may be added.

| Capability Key   | Capability Description                                                                                                        |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| SYS_MODULE       | Load and unload kernel modules.                                                                                               |
| SYS_RAWIO        | Perform I/O port operations (iopl(2) and ioperm(2)).                                                                          |
| SYS_PACCT        | Use acct(2), switch process accounting on or off.                                                                             |
| SYS_ADMIN        | Perform a range of system administration operations.                                                                          |
| SYS_NICE         | Raise process nice value (nice(2), setpriority(2)) and change the nice value for arbitrary processes.                         |
| SYS_RESOURCE     | Override resource Limits.                                                                                                     |
| SYS_TIME         | Set system clock (settimeofday(2), stime(2), adjtimex(2)); set real-time (hardware) clock.                                    |
| SYS_TTY_CONFIG   | Use vhangup(2); employ various privileged ioctl(2) operations on virtual terminals.                                           |
| AUDIT_CONTROL    | Enable and disable kernel auditing; change auditing filter rules; retrieve auditing status and filtering rules.               |
| MAC_OVERRIDE     | Allow MAC configuration or state changes. Implemented for the Smack LSM.                                                      |
| MAC_ADMIN        | Override Mandatory Access Control (MAC). Implemented for the Smack Linux Security Module (LSM).                               |
| NET_ADMIN        | Perform various network-related operations.                                                                                   |
| SYSLOG           | Perform privileged syslog(2) operations.                                                                                      |
| DAC_READ_SEARCH  | Bypass file read permission checks and directory read and execute permission checks.                                          |
| LINUX_IMMUTABLE  | Set the FS_APPEND_FL and FS_IMMUTABLE_FL i-node flags.                                                                        |
| NET_BROADCAST    | Make socket broadcasts, and listen to multicasts.                                                                             |
| IPC_LOCK         | Lock memory (mlock(2), mlockall(2), mmap(2), shmctl(2)).                                                                      |
| IPC_OWNER        | Bypass permission checks for operations on System V IPC objects.                                                              |
| SYS_PTRACE       | Trace arbitrary processes using ptrace(2).                                                                                    |
| SYS_BOOT         | Use reboot(2) and kexec_load(2), reboot and load a new kernel for later execution.                                            |
| LEASE            | Establish leases on arbitrary files (see fcntl(2)).                                                                           |
| WAKE_ALARM       | Trigger something that will wake up the system.                                                                               |
| BLOCK_SUSPEND    | Employ features that can block system suspend.                                                                                |

Further reference information is available on the [capabilities(7) - Linux man page](http://man7.org/linux/man-pages/man7/capabilities.7.html)

Both flags support the value `ALL`, so if the
operator wants to have all capabilities but `MKNOD` they could use:

    $ docker run --cap-add=ALL --cap-drop=MKNOD ...

For interacting with the network stack, instead of using `--privileged` they
should use `--cap-add=NET_ADMIN` to modify the network interfaces.

    $ docker run -it --rm  ubuntu:14.04 ip link add dummy0 type dummy
    RTNETLINK answers: Operation not permitted
    $ docker run -it --rm --cap-add=NET_ADMIN ubuntu:14.04 ip link add dummy0 type dummy

To mount a FUSE based filesystem, you need to combine both `--cap-add` and
`--device`:

    $ docker run --rm -it --cap-add SYS_ADMIN sshfs sshfs sven@10.10.10.20:/home/sven /mnt
    fuse: failed to open /dev/fuse: Operation not permitted
    $ docker run --rm -it --device /dev/fuse sshfs sshfs sven@10.10.10.20:/home/sven /mnt
    fusermount: mount failed: Operation not permitted
    $ docker run --rm -it --cap-add SYS_ADMIN --device /dev/fuse sshfs
    # sshfs sven@10.10.10.20:/home/sven /mnt
    The authenticity of host '10.10.10.20 (10.10.10.20)' can't be established.
    ECDSA key fingerprint is 25:34:85:75:25:b0:17:46:05:19:04:93:b5:dd:5f:c6.
    Are you sure you want to continue connecting (yes/no)? yes
    sven@10.10.10.20's password:
    root@30aa0cfaf1b5:/# ls -la /mnt/src/docker
    total 1516
    drwxrwxr-x 1 1000 1000   4096 Dec  4 06:08 .
    drwxrwxr-x 1 1000 1000   4096 Dec  4 11:46 ..
    -rw-rw-r-- 1 1000 1000     16 Oct  8 00:09 .dockerignore
    -rwxrwxr-x 1 1000 1000    464 Oct  8 00:09 .drone.yml
    drwxrwxr-x 1 1000 1000   4096 Dec  4 06:11 .git
    -rw-rw-r-- 1 1000 1000    461 Dec  4 06:08 .gitignore
    ....

The default seccomp profile will adjust to the selected capabilities, in order to allow
use of facilities allowed by the capabilities, so you should not have to adjust this,
since Docker 1.12. In Docker 1.10 and 1.11 this did not happen and it may be necessary
to use a custom seccomp profile or use `--security-opt seccomp=unconfined` when adding
capabilities.

## Logging drivers (--log-driver)

The container can have a different logging driver than the Docker daemon. Use
the `--log-driver=VALUE` with the `docker run` command to configure the
container's logging driver. The following options are supported:

| Driver      | Description                                                                                                                   |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `none`      | Disables any logging for the container. `docker logs` won't be available with this driver.                                    |
| `json-file` | Default logging driver for Docker. Writes JSON messages to file.  No logging options are supported for this driver.           |
| `syslog`    | Syslog logging driver for Docker. Writes log messages to syslog.                                                              |
| `journald`  | Journald logging driver for Docker. Writes log messages to `journald`.                                                        |
| `gelf`      | Graylog Extended Log Format (GELF) logging driver for Docker. Writes log messages to a GELF endpoint likeGraylog or Logstash. |
| `fluentd`   | Fluentd logging driver for Docker. Writes log messages to `fluentd` (forward input).                                          |
| `awslogs`   | Amazon CloudWatch Logs logging driver for Docker. Writes log messages to Amazon CloudWatch Logs                               |
| `splunk`    | Splunk logging driver for Docker. Writes log messages to `splunk` using Event Http Collector.                                 |

The `docker logs` command is available only for the `json-file` and `journald`
logging drivers.  For detailed information on working with logging drivers, see
[Configure a logging driver](../admin/logging/overview.md).


## Overriding Dockerfile image defaults

When a developer builds an image from a [*Dockerfile*](builder.md)
or when she commits it, the developer can set a number of default parameters
that take effect when the image starts up as a container.

Four of the Dockerfile commands cannot be overridden at runtime: `FROM`,
`MAINTAINER`, `RUN`, and `ADD`. Everything else has a corresponding override
in `docker run`. We'll go through what the developer might have set in each
Dockerfile instruction and how the operator can override that setting.

 - [CMD (Default Command or Options)](run.md#cmd-default-command-or-options)
 - [ENTRYPOINT (Default Command to Execute at Runtime)](
    #entrypoint-default-command-to-execute-at-runtime)
 - [EXPOSE (Incoming Ports)](run.md#expose-incoming-ports)
 - [ENV (Environment Variables)](run.md#env-environment-variables)
 - [HEALTHCHECK](run.md#healthcheck)
 - [VOLUME (Shared Filesystems)](run.md#volume-shared-filesystems)
 - [USER](run.md#user)
 - [WORKDIR](run.md#workdir)

### CMD (default command or options)

Recall the optional `COMMAND` in the Docker
commandline:

    $ docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]

This command is optional because the person who created the `IMAGE` may
have already provided a default `COMMAND` using the Dockerfile `CMD`
instruction. As the operator (the person running a container from the
image), you can override that `CMD` instruction just by specifying a new
`COMMAND`.

If the image also specifies an `ENTRYPOINT` then the `CMD` or `COMMAND`
get appended as arguments to the `ENTRYPOINT`.

### ENTRYPOINT (default command to execute at runtime)

    --entrypoint="": Overwrite the default entrypoint set by the image

The `ENTRYPOINT` of an image is similar to a `COMMAND` because it
specifies what executable to run when the container starts, but it is
(purposely) more difficult to override. The `ENTRYPOINT` gives a
container its default nature or behavior, so that when you set an
`ENTRYPOINT` you can run the container *as if it were that binary*,
complete with default options, and you can pass in more options via the
`COMMAND`. But, sometimes an operator may want to run something else
inside the container, so you can override the default `ENTRYPOINT` at
runtime by using a string to specify the new `ENTRYPOINT`. Here is an
example of how to run a shell in a container that has been set up to
automatically run something else (like `/usr/bin/redis-server`):

    $ docker run -it --entrypoint /bin/bash example/redis

or two examples of how to pass more parameters to that ENTRYPOINT:

    $ docker run -it --entrypoint /bin/bash example/redis -c ls -l
    $ docker run -it --entrypoint /usr/bin/redis-cli example/redis --help

> **Note**: Passing `--entrypoint` will clear out any default command set on the
> image (i.e. any `CMD` instruction in the Dockerfile used to build it).

### EXPOSE (incoming ports)

The following `run` command options work with container networking:

    --expose=[]: Expose a port or a range of ports inside the container.
                 These are additional to those exposed by the `EXPOSE` instruction
    -P         : Publish all exposed ports to the host interfaces
    -p=[]      : Publish a container·æøs port or a range of ports to the host
                   format: ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort | containerPort
                   Both hostPort and containerPort can be specified as a
                   range of ports. When specifying ranges for both, the
                   number of container ports in the range must match the
                   number of host ports in the range, for example:
                       -p 1234-1236:1234-1236/tcp

                   When specifying a range for hostPort only, the
                   containerPort must not be a range.  In this case the
                   container port is published somewhere within the
                   specified hostPort range. (e.g., `-p 1234-1236:1234/tcp`)

                   (use 'docker port' to see the actual mapping)

    --link=""  : Add link to another container (<name or id>:alias or <name or id>)

With the exception of the `EXPOSE` directive, an image developer hasn't
got much control over networking. The `EXPOSE` instruction defines the
initial incoming ports that provide services. These ports are available
to processes inside the container. An operator can use the `--expose`
option to add to the exposed ports.

To expose a container's internal port, an operator can start the
container with the `-P` or `-p` flag. The exposed port is accessible on
the host and the ports are available to any client that can reach the
host.

The `-P` option publishes all the ports to the host interfaces. Docker
binds each exposed port to a random port on the host. The range of
ports are within an *ephemeral port range* defined by
`/proc/sys/net/ipv4/ip_local_port_range`. Use the `-p` flag to
explicitly map a single port or range of ports.

The port number inside the container (where the service listens) does
not need to match the port number exposed on the outside of the
container (where clients connect). For example, inside the container an
HTTP service is listening on port 80 (and so the image developer
specifies `EXPOSE 80` in the Dockerfile). At runtime, the port might be
bound to 42800 on the host. To find the mapping between the host ports
and the exposed ports, use `docker port`.

If the operator uses `--link` when starting a new client container in the
default bridge network, then the client container can access the exposed
port via a private networking interface.
If `--link` is used when starting a container in a user-defined network as
described in [*Docker network overview*](../userguide/networking/index.md),
it will provide a named alias for the container being linked to.

### ENV (environment variables)

When a new container is created, Docker will set the following environment
variables automatically:

| Variable | Value |
| -------- | ----- |
| `HOME` | Set based on the value of `USER` |
| `HOSTNAME` | The hostname associated with the container |
| `PATH` | Includes popular directories, such as `:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin` |
| `TERM` | `xterm` if the container is allocated a pseudo-TTY |

Additionally, the operator can **set any environment variable** in the
container by using one or more `-e` flags, even overriding those mentioned
above, or already defined by the developer with a Dockerfile `ENV`:

    $ docker run -e "deep=purple" --rm ubuntu /bin/bash -c export
    declare -x HOME="/"
    declare -x HOSTNAME="85bc26a0e200"
    declare -x OLDPWD
    declare -x PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    declare -x PWD="/"
    declare -x SHLVL="1"
    declare -x deep="purple"

Similarly the operator can set the **hostname** with `-h`.

### HEALTHCHECK

```
  --health-cmd            Command to run to check health
  --health-interval       Time between running the check
  --health-retries        Consecutive failures needed to report unhealthy
  --health-timeout        Maximum time to allow one check to run
  --no-healthcheck        Disable any container-specified HEALTHCHECK
```

Example:

    {% raw %}
    $ docker run --name=test -d \
        --health-cmd='stat /etc/passwd || exit 1' \
        --health-interval=2s \
        busybox sleep 1d
    $ sleep 2; docker inspect --format='{{.State.Health.Status}}' test
    healthy
    $ docker exec test rm /etc/passwd
    $ sleep 2; docker inspect --format='{{json .State.Health}}' test
    {
      "Status": "unhealthy",
      "FailingStreak": 3,
      "Log": [
        {
          "Start": "2016-05-25T17:22:04.635478668Z",
          "End": "2016-05-25T17:22:04.7272552Z",
          "ExitCode": 0,
          "Output": "  File: /etc/passwd\n  Size: 334       \tBlocks: 8          IO Block: 4096   regular file\nDevice: 32h/50d\tInode: 12          Links: 1\nAccess: (0664/-rw-rw-r--)  Uid: (    0/    root)   Gid: (    0/    root)\nAccess: 2015-12-05 22:05:32.000000000\nModify: 2015..."
        },
        {
          "Start": "2016-05-25T17:22:06.732900633Z",
          "End": "2016-05-25T17:22:06.822168935Z",
          "ExitCode": 0,
          "Output": "  File: /etc/passwd\n  Size: 334       \tBlocks: 8          IO Block: 4096   regular file\nDevice: 32h/50d\tInode: 12          Links: 1\nAccess: (0664/-rw-rw-r--)  Uid: (    0/    root)   Gid: (    0/    root)\nAccess: 2015-12-05 22:05:32.000000000\nModify: 2015..."
        },
        {
          "Start": "2016-05-25T17:22:08.823956535Z",
          "End": "2016-05-25T17:22:08.897359124Z",
          "ExitCode": 1,
          "Output": "stat: can't stat '/etc/passwd': No such file or directory\n"
        },
        {
          "Start": "2016-05-25T17:22:10.898802931Z",
          "End": "2016-05-25T17:22:10.969631866Z",
          "ExitCode": 1,
          "Output": "stat: can't stat '/etc/passwd': No such file or directory\n"
        },
        {
          "Start": "2016-05-25T17:22:12.971033523Z",
          "End": "2016-05-25T17:22:13.082015516Z",
          "ExitCode": 1,
          "Output": "stat: can't stat '/etc/passwd': No such file or directory\n"
        }
      ]
    }
    {% endraw %}

The health status is also displayed in the `docker ps` output.

### TMPFS (mount tmpfs filesystems)

```bash
--tmpfs=[]: Create a tmpfs mount with: container-dir[:<options>],
            where the options are identical to the Linux
            'mount -t tmpfs -o' command.
```

The example below mounts an empty tmpfs into the container with the `rw`,
`noexec`, `nosuid`, and `size=65536k` options.

    $ docker run -d --tmpfs /run:rw,noexec,nosuid,size=65536k my_image

### VOLUME (shared filesystems)

    -v, --volume=[host-src:]container-dest[:<options>]: Bind mount a volume.
    The comma-delimited `options` are [rw|ro], [z|Z],
    [[r]shared|[r]slave|[r]private], and [nocopy].
    The 'host-src' is an absolute path or a name value.

    If neither 'rw' or 'ro' is specified then the volume is mounted in
    read-write mode.

    The `nocopy` modes is used to disable automatic copying requested volume
    path in the container to the volume storage location.
    For named volumes, `copy` is the default mode. Copy modes are not supported
    for bind-mounted volumes.

    --volumes-from="": Mount all volumes from the given container(s)

> **Note**:
> When using systemd to manage the Docker daemon's start and stop, in the systemd
> unit file there is an option to control mount propagation for the Docker daemon
> itself, called `MountFlags`. The value of this setting may cause Docker to not
> see mount propagation changes made on the mount point. For example, if this value
> is `slave`, you may not be able to use the `shared` or `rshared` propagation on
> a volume.

The volumes commands are complex enough to have their own documentation
in section [*Manage data in
containers*](../tutorials/dockervolumes.md). A developer can define
one or more `VOLUME`'s associated with an image, but only the operator
can give access from one container to another (or from a container to a
volume mounted on the host).

The `container-dest` must always be an absolute path such as `/src/docs`.
The `host-src` can either be an absolute path or a `name` value. If you
supply an absolute path for the `host-dir`, Docker bind-mounts to the path
you specify. If you supply a `name`, Docker creates a named volume by that `name`.

A `name` value must start with an alphanumeric character,
followed by `a-z0-9`, `_` (underscore), `.` (period) or `-` (hyphen).
An absolute path starts with a `/` (forward slash).

For example, you can specify either `/foo` or `foo` for a `host-src` value.
If you supply the `/foo` value, Docker creates a bind-mount. If you supply
the `foo` specification, Docker creates a named volume.

### USER

`root` (id = 0) is the default user within a container. The image developer can
create additional users. Those users are accessible by name.  When passing a numeric
ID, the user does not have to exist in the container.

The developer can set a default user to run the first process with the
Dockerfile `USER` instruction. When starting a container, the operator can override
the `USER` instruction by passing the `-u` option.

    -u="", --user="": Sets the username or UID used and optionally the groupname or GID for the specified command.

    The followings examples are all valid:
    --user=[ user | user:group | uid | uid:gid | user:gid | uid:group ]

> **Note:** if you pass a numeric uid, it must be in the range of 0-2147483647.

### WORKDIR

The default working directory for running binaries within a container is the
root directory (`/`), but the developer can set a different default with the
Dockerfile `WORKDIR` command. The operator can override this with:

    -w="": Working directory inside the container
                                                                                                                                                                           go/src/github.com/docker/docker/docs/security/                                                      0040755 0000000 0000000 00000000000 13101060260 020005  5                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        go/src/github.com/docker/docker/docs/security/apparmor.md                                           0100644 0000000 0000000 00000021146 13101060260 022151  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!-- [metadata]>
+++
title = "AppArmor security profiles for Docker"
description = "Enabling AppArmor in Docker"
keywords = ["AppArmor, security, docker, documentation"]
[menu.main]
parent= "smn_secure_docker"
weight=5
+++
<![end-metadata]-->

# AppArmor security profiles for Docker

AppArmor (Application Armor) is a Linux security module that protects an
operating system and its applications from security threats. To use it, a system
administrator associates an AppArmor security profile with each program. Docker
expects to find an AppArmor policy loaded and enforced.

Docker automatically loads container profiles. The Docker binary installs
a `docker-default` profile in the `/etc/apparmor.d/docker` file. This profile
is used on containers, _not_ on the Docker Daemon.

A profile for the Docker Engine daemon exists but it is not currently installed
with the `deb` packages. If you are interested in the source for the daemon
profile, it is located in
[contrib/apparmor](https://github.com/docker/docker/tree/master/contrib/apparmor)
in the Docker Engine source repository.

## Understand the policies

The `docker-default` profile is the default for running containers. It is
moderately protective while providing wide application compatibility. The
profile is the following:

```
#include <tunables/global>


profile docker-default flags=(attach_disconnected,mediate_deleted) {

  #include <abstractions/base>


  network,
  capability,
  file,
  umount,

  deny @{PROC}/{*,**^[0-9*],sys/kernel/shm*} wkx,
  deny @{PROC}/sysrq-trigger rwklx,
  deny @{PROC}/mem rwklx,
  deny @{PROC}/kmem rwklx,
  deny @{PROC}/kcore rwklx,

  deny mount,

  deny /sys/[^f]*/** wklx,
  deny /sys/f[^s]*/** wklx,
  deny /sys/fs/[^c]*/** wklx,
  deny /sys/fs/c[^g]*/** wklx,
  deny /sys/fs/cg[^r]*/** wklx,
  deny /sys/firmware/efi/efivars/** rwklx,
  deny /sys/kernel/security/** rwklx,
}
```

When you run a container, it uses the `docker-default` policy unless you
override it with the `security-opt` option. For example, the following
explicitly specifies the default policy:

```bash
$ docker run --rm -it --security-opt apparmor=docker-default hello-world
```

## Load and unload profiles

To load a new profile into AppArmor for use with containers:

```bash
$ apparmor_parser -r -W /path/to/your_profile
```

Then, run the custom profile with `--security-opt` like so:

```bash
$ docker run --rm -it --security-opt apparmor=your_profile hello-world
```

To unload a profile from AppArmor:

```bash
# stop apparmor
$ /etc/init.d/apparmor stop
# unload the profile
$ apparmor_parser -R /path/to/profile
# start apparmor
$ /etc/init.d/apparmor start
```

### Resources for writing profiles

The syntax for file globbing in AppArmor is a bit different than some other
globbing implementations. It is highly suggested you take a look at some of the
below resources with regard to AppArmor profile syntax.

- [Quick Profile Language](http://wiki.apparmor.net/index.php/QuickProfileLanguage)
- [Globbing Syntax](http://wiki.apparmor.net/index.php/AppArmor_Core_Policy_Reference#AppArmor_globbing_syntax)

## Nginx example profile

In this example, you create a custom AppArmor profile for Nginx. Below is the
custom profile.

```
#include <tunables/global>


profile docker-nginx flags=(attach_disconnected,mediate_deleted) {
  #include <abstractions/base>

  network inet tcp,
  network inet udp,
  network inet icmp,

  deny network raw,

  deny network packet,

  file,
  umount,

  deny /bin/** wl,
  deny /boot/** wl,
  deny /dev/** wl,
  deny /etc/** wl,
  deny /home/** wl,
  deny /lib/** wl,
  deny /lib64/** wl,
  deny /media/** wl,
  deny /mnt/** wl,
  deny /opt/** wl,
  deny /proc/** wl,
  deny /root/** wl,
  deny /sbin/** wl,
  deny /srv/** wl,
  deny /tmp/** wl,
  deny /sys/** wl,
  deny /usr/** wl,

  audit /** w,

  /var/run/nginx.pid w,

  /usr/sbin/nginx ix,

  deny /bin/dash mrwklx,
  deny /bin/sh mrwklx,
  deny /usr/bin/top mrwklx,


  capability chown,
  capability dac_override,
  capability setuid,
  capability setgid,
  capability net_bind_service,

  deny @{PROC}/{*,**^[0-9*],sys/kernel/shm*} wkx,
  deny @{PROC}/sysrq-trigger rwklx,
  deny @{PROC}/mem rwklx,
  deny @{PROC}/kmem rwklx,
  deny @{PROC}/kcore rwklx,
  deny mount,
  deny /sys/[^f]*/** wklx,
  deny /sys/f[^s]*/** wklx,
  deny /sys/fs/[^c]*/** wklx,
  deny /sys/fs/c[^g]*/** wklx,
  deny /sys/fs/cg[^r]*/** wklx,
  deny /sys/firmware/efi/efivars/** rwklx,
  deny /sys/kernel/security/** rwklx,
}
```

1. Save the custom profile to disk in the
`/etc/apparmor.d/containers/docker-nginx` file.

    The file path in this example is not a requirement. In production, you could
    use another.

2. Load the profile.

    ```bash
    $ sudo apparmor_parser -r -W /etc/apparmor.d/containers/docker-nginx
    ```

3. Run a container with the profile.

    To run nginx in detached mode:

    ```bash
    $ docker run --security-opt "apparmor=docker-nginx" \
        -p 80:80 -d --name apparmor-nginx nginx
    ```

4. Exec into the running container

    ```bash
    $ docker exec -it apparmor-nginx bash
    ```

5. Try some operations to test the profile.

    ```bash
    root@6da5a2a930b9:~# ping 8.8.8.8
    ping: Lacking privilege for raw socket.

    root@6da5a2a930b9:/# top
    bash: /usr/bin/top: Permission denied

    root@6da5a2a930b9:~# touch ~/thing
    touch: cannot touch 'thing': Permission denied

    root@6da5a2a930b9:/# sh
    bash: /bin/sh: Permission denied

    root@6da5a2a930b9:/# dash
    bash: /bin/dash: Permission denied
    ```


Congrats! You just deployed a container secured with a custom apparmor profile!


## Debug AppArmor

You can use `dmesg` to debug problems and `aa-status` check the loaded profiles.

### Use dmesg

Here are some helpful tips for debugging any problems you might be facing with
regard to AppArmor.

AppArmor sends quite verbose messaging to `dmesg`. Usually an AppArmor line
looks like the following:

```
[ 5442.864673] audit: type=1400 audit(1453830992.845:37): apparmor="ALLOWED" operation="open" profile="/usr/bin/docker" name="/home/jessie/docker/man/man1/docker-attach.1" pid=10923 comm="docker" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
```

In the above example, you can see `profile=/usr/bin/docker`. This means the
user has the `docker-engine` (Docker Engine Daemon) profile loaded.

> **Note:** On version of Ubuntu > 14.04 this is all fine and well, but Trusty
> users might run into some issues when trying to `docker exec`.

Look at another log line:

```
[ 3256.689120] type=1400 audit(1405454041.341:73): apparmor="DENIED" operation="ptrace" profile="docker-default" pid=17651 comm="docker" requested_mask="receive" denied_mask="receive"
```

This time the profile is `docker-default`, which is run on containers by
default unless in `privileged` mode. This line shows that apparmor has denied
`ptrace` in the container. This is exactly as expected.

### Use aa-status

If you need to check which profiles are loaded,  you can use `aa-status`. The
output looks like:

```bash
$ sudo aa-status
apparmor module is loaded.
14 profiles are loaded.
1 profiles are in enforce mode.
   docker-default
13 profiles are in complain mode.
   /usr/bin/docker
   /usr/bin/docker///bin/cat
   /usr/bin/docker///bin/ps
   /usr/bin/docker///sbin/apparmor_parser
   /usr/bin/docker///sbin/auplink
   /usr/bin/docker///sbin/blkid
   /usr/bin/docker///sbin/iptables
   /usr/bin/docker///sbin/mke2fs
   /usr/bin/docker///sbin/modprobe
   /usr/bin/docker///sbin/tune2fs
   /usr/bin/docker///sbin/xtables-multi
   /usr/bin/docker///sbin/zfs
   /usr/bin/docker///usr/bin/xz
38 processes have profiles defined.
37 processes are in enforce mode.
   docker-default (6044)
   ...
   docker-default (31899)
1 processes are in complain mode.
   /usr/bin/docker (29756)
0 processes are unconfined but have a profile defined.
```

The above output shows that the `docker-default` profile running on various
container PIDs is in `enforce` mode. This means AppArmor is actively blocking
and auditing in `dmesg` anything outside the bounds of the `docker-default`
profile.

The output above also shows the `/usr/bin/docker` (Docker Engine daemon) profile
is running in `complain` mode. This means AppArmor _only_ logs to `dmesg`
activity outside the bounds of the profile. (Except in the case of Ubuntu
Trusty, where some interesting behaviors are enforced.)

## Contribute Docker's AppArmor code

Advanced users and package managers can find a profile for `/usr/bin/docker`
(Docker Engine Daemon) underneath
[contrib/apparmor](https://github.com/docker/docker/tree/master/contrib/apparmor)
in the Docker Engine source repository.

The `docker-default` profile for containers lives in
[profiles/apparmor](https://github.com/docker/docker/tree/master/profiles/apparmor).
                                                                                                                                                                                                                                                                                                                                                                                                                          go/src/github.com/docker/docker/docs/security/certificates.md                                       0100644 0000000 0000000 00000007001 13101060260 022767  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--[metadata]>
+++
aliases = ["/engine/articles/certificates/"]
title = "Using certificates for repository client verification"
description = "How to set up and use certificates with a registry to verify access"
keywords = ["Usage, registry, repository, client, root, certificate, docker, apache, ssl, tls, documentation, examples, articles,  tutorials"]
[menu.main]
parent = "smn_secure_docker"
+++
<![end-metadata]-->

# Using certificates for repository client verification

In [Running Docker with HTTPS](https.md), you learned that, by default,
Docker runs via a non-networked Unix socket and TLS must be enabled in order
to have the Docker client and the daemon communicate securely over HTTPS.  TLS ensures authenticity of the registry endpoint and that traffic to/from registry is encrypted.

This article demonstrates how to ensure the traffic between the Docker registry (i.e., *a server*) and the Docker daemon (i.e., *a client*) traffic is encrypted and a properly authenticated using *certificate-based client-server authentication*.

We will show you how to install a Certificate Authority (CA) root certificate
for the registry and how to set the client TLS certificate for verification.

## Understanding the configuration

A custom certificate is configured by creating a directory under
`/etc/docker/certs.d` using the same name as the registry's hostname (e.g.,
`localhost`). All `*.crt` files are added to this directory as CA roots.

> **Note:**
> In the absence of any root certificate authorities, Docker
> will use the system default (i.e., host's root CA set).

The presence of one or more `<filename>.key/cert` pairs indicates to Docker
that there are custom certificates required for access to the desired
repository.

> **Note:**
> If there are multiple certificates, each will be tried in alphabetical
> order. If there is an authentication error (e.g., 403, 404, 5xx, etc.), Docker
> will continue to try with the next certificate.

The following illustrates a configuration with multiple certs:

```
    /etc/docker/certs.d/        <-- Certificate directory
    ‚îî‚îÄ‚îÄ localhost               <-- Hostname
       ‚îú‚îÄ‚îÄ client.cert          <-- Client certificate
       ‚îú‚îÄ‚îÄ client.key           <-- Client key
       ‚îî‚îÄ‚îÄ localhost.crt        <-- Certificate authority that signed
                                    the registry certificate
```

The preceding example is operating-system specific and is for illustrative
purposes only. You should consult your operating system documentation for
creating an os-provided bundled certificate chain.


## Creating the client certificates

You will use OpenSSL's `genrsa` and `req` commands to first generate an RSA
key and then use the key to create the certificate.   

    $ openssl genrsa -out client.key 4096
    $ openssl req -new -x509 -text -key client.key -out client.cert

> **Note:**
> These TLS commands will only generate a working set of certificates on Linux.
> The version of OpenSSL in Mac OS X is incompatible with the type of
> certificate Docker requires.

## Troubleshooting tips

The Docker daemon interprets ``.crt` files as CA certificates and `.cert` files
as client certificates. If a CA certificate is accidentally given the extension
`.cert` instead of the correct `.crt` extension, the Docker daemon logs the
following error message:

```
Missing key KEY_NAME for client certificate CERT_NAME. Note that CA certificates should use the extension .crt.
```

## Related Information

* [Use trusted images](index.md)
* [Protect the Docker daemon socket](https.md)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               go/src/github.com/docker/docker/docs/security/https/                                                0040755 0000000 0000000 00000000000 13101060260 021147  5                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        go/src/github.com/docker/docker/docs/security/https/Dockerfile                                      0100644 0000000 0000000 00000000210 13101060260 023127  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        FROM debian

RUN apt-get update && apt-get install -yq openssl

ADD make_certs.sh /


WORKDIR /data
VOLUME ["/data"]
CMD /make_certs.sh
                                                                                                                                                                                                                                                                                                                                                                                        go/src/github.com/docker/docker/docs/security/https/Makefile                                        0100644 0000000 0000000 00000001651 13101060260 022607  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        
HOST:=boot2docker

makescript:
	./parsedocs.sh > make_certs.sh

build: clean makescript
	docker build -t makecerts .

cert: build
	docker run --rm -it -v $(CURDIR):/data -e HOST=$(HOST) -e YOUR_PUBLIC_IP=$(shell ip a | grep "inet " | sed "s/.*inet \([0-9.]*\)\/.*/\1/" | xargs echo | sed "s/ /,IP:/g") makecerts

certs: cert

run:
	sudo dockerd -D --tlsverify --tlscacert=ca.pem --tlscert=server-cert.pem --tlskey=server-key.pem -H=0.0.0.0:6666 --pidfile=$(pwd)/docker.pid --graph=$(pwd)/graph

client:
	sudo docker --tls --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem   -H=$(HOST):6666 version
	sudo docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem   -H=$(HOST):6666 info
	sudo curl https://$(HOST):6666/images/json --cert ./cert.pem --key ./key.pem --cacert ./ca.pem

clean:
	rm -f ca-key.pem ca.pem ca.srl cert.pem client.csr extfile.cnf key.pem server-cert.pem server-key.pem server.csr extfile.cnf
                                                                                       go/src/github.com/docker/docker/docs/security/https/README.md                                       0100644 0000000 0000000 00000001576 13101060260 022434  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--[metadata]>
+++
draft = true
+++
<![end-metadata]-->



This is an initial attempt to make it easier to test the examples in the https.md
doc.

At this point, it has to be a manual thing, and I've been running it in boot2docker.

My process is as following:

    $ boot2docker ssh
    root@boot2docker:/# git clone https://github.com/docker/docker
    root@boot2docker:/# cd docker/docs/articles/https
    root@boot2docker:/# make cert

lots of things to see and manually answer, as openssl wants to be interactive

**NOTE:** make sure you enter the hostname (`boot2docker` in my case) when prompted for `Computer Name`)

    root@boot2docker:/# sudo make run

Start another terminal:

    $ boot2docker ssh
    root@boot2docker:/# cd docker/docs/articles/https
    root@boot2docker:/# make client

The last will connect first with `--tls` and then with `--tlsverify`, both should succeed.
                                                                                                                                  go/src/github.com/docker/docker/docs/security/https/make_certs.sh                                   0100755 0000000 0000000 00000002521 13101060260 023620  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        #!/bin/sh
openssl genrsa -aes256 -out ca-key.pem 2048
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
openssl genrsa -out server-key.pem 2048
openssl req -subj "/CN=$HOST" -new -key server-key.pem -out server.csr
echo subjectAltName = IP:$YOUR_PUBLIC_IP > extfile.cnf
openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem       -CAcreateserial -out server-cert.pem -extfile extfile.cnf
openssl genrsa -out key.pem 2048
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile.cnf
openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca-key.pem       -CAcreateserial -out cert.pem -extfile extfile.cnf
rm -v client.csr server.csr
chmod -v 0400 ca-key.pem key.pem server-key.pem
chmod -v 0444 ca.pem server-cert.pem cert.pem
# docker -d --tlsverify --tlscacert=ca.pem --tlscert=server-cert.pem --tlskey=server-key.pem       -H=0.0.0.0:7778
# docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem       -H=$HOST:7778 version
mkdir -pv ~/.docker
cp -v {ca,cert,key}.pem ~/.docker
export DOCKER_HOST=tcp://$HOST:7778 DOCKER_TLS_VERIFY=1
# docker ps
export DOCKER_CERT_PATH=~/.docker/zone1/
# docker --tlsverify ps
# curl https://$HOST:7778/images/json       --cert ~/.docker/cert.pem       --key ~/.docker/key.pem       --cacert ~/.docker/ca.pem
                                                                                                                                                                               go/src/github.com/docker/docker/docs/security/https/parsedocs.sh                                    0100755 0000000 0000000 00000000451 13101060260 023466  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        #!/bin/sh

echo "#!/bin/sh"
cat ../https.md | awk '{if (sub(/\\$/,"")) printf "%s", $0; else print $0}' \
        | grep '   $ ' \
        | sed 's/    $ //g' \
        | sed 's/2375/7777/g' \
        | sed 's/2376/7778/g' \
        | sed 's/^docker/# docker/g' \
        | sed 's/^curl/# curl/g'
                                                                                                                                                                                                                       go/src/github.com/docker/docker/docs/security/https.md                                              0100644 0000000 0000000 00000020353 13101060260 021471  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--[metadata]>
+++
aliases = ["/engine/articles/https/"]
title = "Protect the Docker daemon socket"
description = "How to setup and run Docker with HTTPS"
keywords = ["docker, docs, article, example, https, daemon, tls, ca,  certificate"]
[menu.main]
parent = "smn_secure_docker"
+++
<![end-metadata]-->

# Protect the Docker daemon socket

By default, Docker runs via a non-networked Unix socket. It can also
optionally communicate using an HTTP socket.

If you need Docker to be reachable via the network in a safe manner, you can
enable TLS by specifying the `tlsverify` flag and pointing Docker's
`tlscacert` flag to a trusted CA certificate.

In the daemon mode, it will only allow connections from clients
authenticated by a certificate signed by that CA. In the client mode,
it will only connect to servers with a certificate signed by that CA.

> **Warning**:
> Using TLS and managing a CA is an advanced topic. Please familiarize yourself
> with OpenSSL, x509 and TLS before using it in production.

> **Warning**:
> These TLS commands will only generate a working set of certificates on Linux.
> Mac OS X comes with a version of OpenSSL that is incompatible with the
> certificates that Docker requires.

## Create a CA, server and client keys with OpenSSL

> **Note**: replace all instances of `$HOST` in the following example with the
> DNS name of your Docker daemon's host.

First generate CA private and public keys:

    $ openssl genrsa -aes256 -out ca-key.pem 4096
    Generating RSA private key, 4096 bit long modulus
    ............................................................................................................................................................................................++
    ........++
    e is 65537 (0x10001)
    Enter pass phrase for ca-key.pem:
    Verifying - Enter pass phrase for ca-key.pem:
    $ openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
    Enter pass phrase for ca-key.pem:
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [AU]:
    State or Province Name (full name) [Some-State]:Queensland
    Locality Name (eg, city) []:Brisbane
    Organization Name (eg, company) [Internet Widgits Pty Ltd]:Docker Inc
    Organizational Unit Name (eg, section) []:Sales
    Common Name (e.g. server FQDN or YOUR name) []:$HOST
    Email Address []:Sven@home.org.au

Now that we have a CA, you can create a server key and certificate
signing request (CSR). Make sure that "Common Name" (i.e., server FQDN or YOUR
name) matches the hostname you will use to connect to Docker:

> **Note**: replace all instances of `$HOST` in the following example with the
> DNS name of your Docker daemon's host.

    $ openssl genrsa -out server-key.pem 4096
    Generating RSA private key, 4096 bit long modulus
    .....................................................................++
    .................................................................................................++
    e is 65537 (0x10001)
    $ openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr

Next, we're going to sign the public key with our CA:

Since TLS connections can be made via IP address as well as DNS name, they need
to be specified when creating the certificate. For example, to allow connections
using `10.10.10.20` and `127.0.0.1`:

    $ echo subjectAltName = IP:10.10.10.20,IP:127.0.0.1 > extfile.cnf

    $ openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem \
      -CAcreateserial -out server-cert.pem -extfile extfile.cnf
    Signature ok
    subject=/CN=your.host.com
    Getting CA Private Key
    Enter pass phrase for ca-key.pem:

For client authentication, create a client key and certificate signing
request:

    $ openssl genrsa -out key.pem 4096
    Generating RSA private key, 4096 bit long modulus
    .........................................................++
    ................++
    e is 65537 (0x10001)
    $ openssl req -subj '/CN=client' -new -key key.pem -out client.csr

To make the key suitable for client authentication, create an extensions
config file:

    $ echo extendedKeyUsage = clientAuth > extfile.cnf

Now sign the public key:

    $ openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem \
      -CAcreateserial -out cert.pem -extfile extfile.cnf
    Signature ok
    subject=/CN=client
    Getting CA Private Key
    Enter pass phrase for ca-key.pem:

After generating `cert.pem` and `server-cert.pem` you can safely remove the
two certificate signing requests:

    $ rm -v client.csr server.csr

With a default `umask` of 022, your secret keys will be *world-readable* and
writable for you and your group.

In order to protect your keys from accidental damage, you will want to remove their
write permissions. To make them only readable by you, change file modes as follows:

    $ chmod -v 0400 ca-key.pem key.pem server-key.pem

Certificates can be world-readable, but you might want to remove write access to
prevent accidental damage:

    $ chmod -v 0444 ca.pem server-cert.pem cert.pem

Now you can make the Docker daemon only accept connections from clients
providing a certificate trusted by our CA:

    $ dockerd --tlsverify --tlscacert=ca.pem --tlscert=server-cert.pem --tlskey=server-key.pem \
      -H=0.0.0.0:2376

To be able to connect to Docker and validate its certificate, you now
need to provide your client keys, certificates and trusted CA:

> **Note**: replace all instances of `$HOST` in the following example with the
> DNS name of your Docker daemon's host.

    $ docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem \
      -H=$HOST:2376 version

> **Note**:
> Docker over TLS should run on TCP port 2376.

> **Warning**:
> As shown in the example above, you don't have to run the `docker` client
> with `sudo` or the `docker` group when you use certificate authentication.
> That means anyone with the keys can give any instructions to your Docker
> daemon, giving them root access to the machine hosting the daemon. Guard
> these keys as you would a root password!

## Secure by default

If you want to secure your Docker client connections by default, you can move
the files to the `.docker` directory in your home directory -- and set the
`DOCKER_HOST` and `DOCKER_TLS_VERIFY` variables as well (instead of passing
`-H=tcp://$HOST:2376` and `--tlsverify` on every call).

    $ mkdir -pv ~/.docker
    $ cp -v {ca,cert,key}.pem ~/.docker
    $ export DOCKER_HOST=tcp://$HOST:2376 DOCKER_TLS_VERIFY=1

Docker will now connect securely by default:

    $ docker ps

## Other modes

If you don't want to have complete two-way authentication, you can run
Docker in various other modes by mixing the flags.

### Daemon modes

 - `tlsverify`, `tlscacert`, `tlscert`, `tlskey` set: Authenticate clients
 - `tls`, `tlscert`, `tlskey`: Do not authenticate clients

### Client modes

 - `tls`: Authenticate server based on public/default CA pool
 - `tlsverify`, `tlscacert`: Authenticate server based on given CA
 - `tls`, `tlscert`, `tlskey`: Authenticate with client certificate, do not
   authenticate server based on given CA
 - `tlsverify`, `tlscacert`, `tlscert`, `tlskey`: Authenticate with client
   certificate and authenticate server based on given CA

If found, the client will send its client certificate, so you just need
to drop your keys into `~/.docker/{ca,cert,key}.pem`. Alternatively,
if you want to store your keys in another location, you can specify that
location using the environment variable `DOCKER_CERT_PATH`.

    $ export DOCKER_CERT_PATH=~/.docker/zone1/
    $ docker --tlsverify ps

### Connecting to the secure Docker port using `curl`

To use `curl` to make test API requests, you need to use three extra command line
flags:

    $ curl https://$HOST:2376/images/json \
      --cert ~/.docker/cert.pem \
      --key ~/.docker/key.pem \
      --cacert ~/.docker/ca.pem

## Related information

* [Using certificates for repository client verification](certificates.md)
* [Use trusted images](trust/index.md)
                                                                                                                                                                                                                                                                                     go/src/github.com/docker/docker/docs/security/index.md                                              0100644 0000000 0000000 00000002411 13101060260 021431  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!-- [metadata]>
+++
title = "Secure Engine"
description = "Sec"
keywords = ["seccomp, security, docker, documentation"]
[menu.main]
identifier="smn_secure_docker"
parent= "engine_use"
+++
<![end-metadata]-->

# Secure Engine

This section discusses the security features you can configure and use within your Docker Engine installation.

* You can configure Docker's trust features so that your users can push and pull trusted images. To learn how to do this, see [Use trusted images](trust/index.md) in this section.

* You can protect the Docker daemon socket and ensure only trusted Docker client connections. For more information, [Protect the Docker daemon socket](https.md)

* You can use certificate-based client-server authentication to verify a Docker daemon has the rights to access images on a registry. For more information, see [Using certificates for repository client verification](certificates.md).

* You can configure secure computing mode (Seccomp) policies to secure system calls in a container. For more information, see [Seccomp security profiles for Docker](seccomp.md).

* An AppArmor profile for Docker is installed with the official *.deb* packages. For information about this profile and overriding it, see [AppArmor security profiles for Docker](apparmor.md).
                                                                                                                                                                                                                                                       go/src/github.com/docker/docker/docs/security/non-events.md                                         0100644 0000000 0000000 00000012413 13101060260 022421  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--[metadata]>
+++
title = "Docker Security Non-events"
description = "Review of security vulnerabilities Docker mitigated"
keywords = ["Docker, Docker documentation,  security, security non-events"]
[menu.main]
parent = "smn_secure_docker"
+++
<![end-metadata]-->

# Docker Security Non-events

This page lists security vulnerabilities which Docker mitigated, such that
processes run in Docker containers were never vulnerable to the bug‚Äîeven before
it was fixed. This assumes containers are run without adding extra capabilities
or not run as `--privileged`.

The list below is not even remotely complete. Rather, it is a sample of the few
bugs we've actually noticed to have attracted security review and publicly
disclosed vulnerabilities. In all likelihood, the bugs that haven't been
reported far outnumber those that have. Luckily, since Docker's approach to
secure by default through apparmor, seccomp, and dropping capabilities, it
likely mitigates unknown bugs just as well as it does known ones.

Bugs mitigated:

* [CVE-2013-1956](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2013-1956),
[1957](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2013-1957),
[1958](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2013-1958),
[1959](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2013-1959),
[1979](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2013-1979),
[CVE-2014-4014](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-4014),
[5206](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-5206),
[5207](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-5207),
[7970](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-7970),
[7975](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-7975),
[CVE-2015-2925](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-2925),
[8543](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-8543),
[CVE-2016-3134](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-3134),
[3135](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-3135), etc.:
The introduction of unprivileged user namespaces lead to a huge increase in the
attack surface available to unprivileged users by giving such users legitimate
access to previously root-only system calls like `mount()`. All of these CVEs
are examples of security vulnerabilities due to introduction of user namespaces.
Docker can use user namespaces to set up containers, but then disallows the
process inside the container from creating its own nested namespaces through the
default seccomp profile, rendering these vulnerabilities unexploitable.
* [CVE-2014-0181](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-0181),
[CVE-2015-3339](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-3339):
These are bugs that require the presence of a setuid binary. Docker disables
setuid binaries inside containers via the `NO_NEW_PRIVS` process flag and
other mechanisms.
* [CVE-2014-4699](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-4699):
A bug in `ptrace()` could allow privilege escalation. Docker disables `ptrace()`
inside the container using apparmor, seccomp and by dropping `CAP_PTRACE`.
Three times the layers of protection there!
* [CVE-2014-9529](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-9529):
A series of crafted `keyctl()` calls could cause kernel DoS / memory corruption.
Docker disables `keyctl()` inside containers using seccomp.
* [CVE-2015-3214](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-3214),
[4036](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-4036): These are
bugs in common virtualization drivers which could allow a guest OS user to
execute code on the host OS. Exploiting them requires access to virtualization
devices in the guest. Docker hides direct access to these devices when run
without `--privileged`. Interestingly, these seem to be cases where containers
are "more secure" than a VM, going against common wisdom that VMs are
"more secure" than containers.
* [CVE-2016-0728](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-0728):
Use-after-free caused by crafted `keyctl()` calls could lead to privilege
escalation. Docker disables `keyctl()` inside containers using the default
seccomp profile.
* [CVE-2016-2383](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-2383):
A bug in eBPF -- the special in-kernel DSL used to express things like seccomp
filters -- allowed arbitrary reads of kernel memory. The `bpf()` system call
is blocked inside Docker containers using (ironically) seccomp.
* [CVE-2016-3134](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-3134),
[4997](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-4997),
[4998](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-4998):
A bug in setsockopt with `IPT_SO_SET_REPLACE`, `ARPT_SO_SET_REPLACE`,  and
`ARPT_SO_SET_REPLACE` causing memory corruption / local privilege escalation.
These arguments are blocked by `CAP_NET_ADMIN`, which Docker does not allow by
default.


Bugs *not* mitigated:

* [CVE-2015-3290](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-3290),
[5157](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-5157): Bugs in
the kernel's non-maskable interrupt handling allowed privilege escalation.
Can be exploited in Docker containers because the `modify_ldt()` system call is
not currently blocked using seccomp.
                                                                                                                                                                                                                                                     go/src/github.com/docker/docker/docs/security/seccomp.md                                            0100644 0000000 0000000 00000024032 13101060260 021756  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!-- [metadata]>
+++
title = "Seccomp security profiles for Docker"
description = "Enabling seccomp in Docker"
keywords = ["seccomp, security, docker, documentation"]
[menu.main]
parent= "smn_secure_docker"
weight=90
+++
<![end-metadata]-->

# Seccomp security profiles for Docker

Secure computing mode (Seccomp) is a Linux kernel feature. You can use it to
restrict the actions available within the container. The `seccomp()` system
call operates on the seccomp state of the calling process. You can use this
feature to restrict your application's access.

This feature is available only if Docker has been built with seccomp and the
kernel is configured with `CONFIG_SECCOMP` enabled. To check if your kernel
supports seccomp:

```bash
$ cat /boot/config-`uname -r` | grep CONFIG_SECCOMP=
CONFIG_SECCOMP=y
```

> **Note**: seccomp profiles require seccomp 2.2.1 and are only
> available starting with Debian 9 "Stretch", Ubuntu 15.10 "Wily",
> Fedora 22, CentOS 7 and Oracle Linux 7. To use this feature on Ubuntu 14.04, Debian Wheezy, or
> Debian Jessie, you must download the [latest static Docker Linux binary](../installation/binaries.md).
> This feature is currently *not* available on other distributions.

## Passing a profile for a container

The default seccomp profile provides a sane default for running containers with
seccomp and disables around 44 system calls out of 300+. It is moderately protective while providing wide application
compatibility. The default Docker profile (found [here](https://github.com/docker/docker/blob/master/profiles/seccomp/default.json)) has a JSON layout in the following form:

```json
{
	"defaultAction": "SCMP_ACT_ERRNO",
	"architectures": [
		"SCMP_ARCH_X86_64",
		"SCMP_ARCH_X86",
		"SCMP_ARCH_X32"
	],
	"syscalls": [
		{
			"name": "accept",
			"action": "SCMP_ACT_ALLOW",
			"args": []
		},
		{
			"name": "accept4",
			"action": "SCMP_ACT_ALLOW",
			"args": []
		},
		...
	]
}
```

When you run a container, it uses the default profile unless you override
it with the `security-opt` option. For example, the following explicitly
specifies the default policy:

```
$ docker run --rm -it --security-opt seccomp=/path/to/seccomp/profile.json hello-world
```

### Significant syscalls blocked by the default profile

Docker's default seccomp profile is a whitelist which specifies the calls that
are allowed. The table below lists the significant (but not all) syscalls that
are effectively blocked because they are not on the whitelist. The table includes
the reason each syscall is blocked rather than white-listed.

| Syscall             | Description                                                                                                                           |
|---------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| `acct`              | Accounting syscall which could let containers disable their own resource limits or process accounting. Also gated by `CAP_SYS_PACCT`. |
| `add_key`           | Prevent containers from using the kernel keyring, which is not namespaced.                                   |
| `adjtimex`          | Similar to `clock_settime` and `settimeofday`, time/date is not namespaced.                                  |
| `bpf`               | Deny loading potentially persistent bpf programs into kernel, already gated by `CAP_SYS_ADMIN`.              |
| `clock_adjtime`     | Time/date is not namespaced.                                                                                 |
| `clock_settime`     | Time/date is not namespaced.                                                                                 |
| `clone`             | Deny cloning new namespaces. Also gated by `CAP_SYS_ADMIN` for CLONE_* flags, except `CLONE_USERNS`.         |
| `create_module`     | Deny manipulation and functions on kernel modules.                                                           |
| `delete_module`     | Deny manipulation and functions on kernel modules. Also gated by `CAP_SYS_MODULE`.                           |
| `finit_module`      | Deny manipulation and functions on kernel modules. Also gated by `CAP_SYS_MODULE`.                           |
| `get_kernel_syms`   | Deny retrieval of exported kernel and module symbols.                                                        |
| `get_mempolicy`     | Syscall that modifies kernel memory and NUMA settings. Already gated by `CAP_SYS_NICE`.                      |
| `init_module`       | Deny manipulation and functions on kernel modules. Also gated by `CAP_SYS_MODULE`.                           |
| `ioperm`            | Prevent containers from modifying kernel I/O privilege levels. Already gated by `CAP_SYS_RAWIO`.             |
| `iopl`              | Prevent containers from modifying kernel I/O privilege levels. Already gated by `CAP_SYS_RAWIO`.             |
| `kcmp`              | Restrict process inspection capabilities, already blocked by dropping `CAP_PTRACE`.                          |
| `kexec_file_load`   | Sister syscall of `kexec_load` that does the same thing, slightly different arguments.                       |
| `kexec_load`        | Deny loading a new kernel for later execution.                                                               |
| `keyctl`            | Prevent containers from using the kernel keyring, which is not namespaced.                                   |
| `lookup_dcookie`    | Tracing/profiling syscall, which could leak a lot of information on the host.                                |
| `mbind`             | Syscall that modifies kernel memory and NUMA settings. Already gated by `CAP_SYS_NICE`.                      |
| `mount`             | Deny mounting, already gated by `CAP_SYS_ADMIN`.                                                             |
| `move_pages`        | Syscall that modifies kernel memory and NUMA settings.                                                       |
| `name_to_handle_at` | Sister syscall to `open_by_handle_at`. Already gated by `CAP_SYS_NICE`.                                      |
| `nfsservctl`        | Deny interaction with the kernel nfs daemon.                                                                 |
| `open_by_handle_at` | Cause of an old container breakout. Also gated by `CAP_DAC_READ_SEARCH`.                                     |
| `perf_event_open`   | Tracing/profiling syscall, which could leak a lot of information on the host.                                |
| `personality`       | Prevent container from enabling BSD emulation. Not inherently dangerous, but poorly tested, potential for a lot of kernel vulns. |
| `pivot_root`        | Deny `pivot_root`, should be privileged operation.                                                           |
| `process_vm_readv`  | Restrict process inspection capabilities, already blocked by dropping `CAP_PTRACE`.                          |
| `process_vm_writev` | Restrict process inspection capabilities, already blocked by dropping `CAP_PTRACE`.                          |
| `ptrace`            | Tracing/profiling syscall, which could leak a lot of information on the host. Already blocked by dropping `CAP_PTRACE`. |
| `query_module`      | Deny manipulation and functions on kernel modules.                                                            |
| `quotactl`          | Quota syscall which could let containers disable their own resource limits or process accounting. Also gated by `CAP_SYS_ADMIN`. |
| `reboot`            | Don't let containers reboot the host. Also gated by `CAP_SYS_BOOT`.                                           |
| `request_key`       | Prevent containers from using the kernel keyring, which is not namespaced.                                    |
| `set_mempolicy`     | Syscall that modifies kernel memory and NUMA settings. Already gated by `CAP_SYS_NICE`.                       |
| `setns`             | Deny associating a thread with a namespace. Also gated by `CAP_SYS_ADMIN`.                                    |
| `settimeofday`      | Time/date is not namespaced. Also gated by `CAP_SYS_TIME`.                                                    |
| `stime`             | Time/date is not namespaced. Also gated by `CAP_SYS_TIME`.                                                    |
| `swapon`            | Deny start/stop swapping to file/device. Also gated by `CAP_SYS_ADMIN`.                                       |
| `swapoff`           | Deny start/stop swapping to file/device. Also gated by `CAP_SYS_ADMIN`.                                       |
| `sysfs`             | Obsolete syscall.                                                                                             |
| `_sysctl`           | Obsolete, replaced by /proc/sys.                                                                              |
| `umount`            | Should be a privileged operation. Also gated by `CAP_SYS_ADMIN`.                                              |
| `umount2`           | Should be a privileged operation.                                                                             |
| `unshare`           | Deny cloning new namespaces for processes. Also gated by `CAP_SYS_ADMIN`, with the exception of `unshare --user`. |
| `uselib`            | Older syscall related to shared libraries, unused for a long time.                                            |
| `userfaultfd`       | Userspace page fault handling, largely needed for process migration.                                          |
| `ustat`             | Obsolete syscall.                                                                                             |
| `vm86`              | In kernel x86 real mode virtual machine. Also gated by `CAP_SYS_ADMIN`.                                       |
| `vm86old`           | In kernel x86 real mode virtual machine. Also gated by `CAP_SYS_ADMIN`.                                       |

## Run without the default seccomp profile

You can pass `unconfined` to run a container without the default seccomp
profile.

```
$ docker run --rm -it --security-opt seccomp=unconfined debian:jessie \
    unshare --map-root-user --user sh -c whoami
```
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      go/src/github.com/docker/docker/docs/security/security.md                                           0100644 0000000 0000000 00000032331 13101060260 022175  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--[metadata]>
+++
aliases = ["/engine/articles/security/"]
title = "Docker security"
description = "Review of the Docker Daemon attack surface"
keywords = ["Docker, Docker documentation,  security"]
[menu.main]
parent = "smn_secure_docker"
weight =-99
+++
<![end-metadata]-->

# Docker security

There are four major areas to consider when reviewing Docker security:

 - the intrinsic security of the kernel and its support for
   namespaces and cgroups;
 - the attack surface of the Docker daemon itself;
 - loopholes in the container configuration profile, either by default,
   or when customized by users.
 - the "hardening" security features of the kernel and how they
   interact with containers.

## Kernel namespaces

Docker containers are very similar to LXC containers, and they have
similar security features. When you start a container with
`docker run`, behind the scenes Docker creates a set of namespaces and control
groups for the container.

**Namespaces provide the first and most straightforward form of
isolation**: processes running within a container cannot see, and even
less affect, processes running in another container, or in the host
system.

**Each container also gets its own network stack**, meaning that a
container doesn't get privileged access to the sockets or interfaces
of another container. Of course, if the host system is setup
accordingly, containers can interact with each other through their
respective network interfaces ‚Äî just like they can interact with
external hosts. When you specify public ports for your containers or use
[*links*](../userguide/networking/default_network/dockerlinks.md)
then IP traffic is allowed between containers. They can ping each other,
send/receive UDP packets, and establish TCP connections, but that can be
restricted if necessary. From a network architecture point of view, all
containers on a given Docker host are sitting on bridge interfaces. This
means that they are just like physical machines connected through a
common Ethernet switch; no more, no less.

How mature is the code providing kernel namespaces and private
networking? Kernel namespaces were introduced [between kernel version
2.6.15 and
2.6.26](http://man7.org/linux/man-pages/man7/namespaces.7.html).
This means that since July 2008 (date of the 2.6.26 release
), namespace code has been exercised and scrutinized on a large
number of production systems. And there is more: the design and
inspiration for the namespaces code are even older. Namespaces are
actually an effort to reimplement the features of [OpenVZ](
http://en.wikipedia.org/wiki/OpenVZ) in such a way that they could be
merged within the mainstream kernel. And OpenVZ was initially released
in 2005, so both the design and the implementation are pretty mature.

## Control groups

Control Groups are another key component of Linux Containers. They
implement resource accounting and limiting. They provide many
useful metrics, but they also help ensure that each container gets
its fair share of memory, CPU, disk I/O; and, more importantly, that a
single container cannot bring the system down by exhausting one of those
resources.

So while they do not play a role in preventing one container from
accessing or affecting the data and processes of another container, they
are essential to fend off some denial-of-service attacks. They are
particularly important on multi-tenant platforms, like public and
private PaaS, to guarantee a consistent uptime (and performance) even
when some applications start to misbehave.

Control Groups have been around for a while as well: the code was
started in 2006, and initially merged in kernel 2.6.24.

## Docker daemon attack surface

Running containers (and applications) with Docker implies running the
Docker daemon. This daemon currently requires `root` privileges, and you
should therefore be aware of some important details.

First of all, **only trusted users should be allowed to control your
Docker daemon**. This is a direct consequence of some powerful Docker
features. Specifically, Docker allows you to share a directory between
the Docker host and a guest container; and it allows you to do so
without limiting the access rights of the container. This means that you
can start a container where the `/host` directory will be the `/` directory
on your host; and the container will be able to alter your host filesystem
without any restriction. This is similar to how virtualization systems
allow filesystem resource sharing. Nothing prevents you from sharing your
root filesystem (or even your root block device) with a virtual machine.

This has a strong security implication: for example, if you instrument Docker
from a web server to provision containers through an API, you should be
even more careful than usual with parameter checking, to make sure that
a malicious user cannot pass crafted parameters causing Docker to create
arbitrary containers.

For this reason, the REST API endpoint (used by the Docker CLI to
communicate with the Docker daemon) changed in Docker 0.5.2, and now
uses a UNIX socket instead of a TCP socket bound on 127.0.0.1 (the
latter being prone to cross-site request forgery attacks if you happen to run
Docker directly on your local machine, outside of a VM). You can then
use traditional UNIX permission checks to limit access to the control
socket.

You can also expose the REST API over HTTP if you explicitly decide to do so.
However, if you do that, being aware of the above mentioned security
implication, you should ensure that it will be reachable only from a
trusted network or VPN; or protected with e.g., `stunnel` and client SSL
certificates. You can also secure them with [HTTPS and
certificates](https.md).

The daemon is also potentially vulnerable to other inputs, such as image
loading from either disk with 'docker load', or from the network with
'docker pull'. As of Docker 1.3.2, images are now extracted in a chrooted
subprocess on Linux/Unix platforms, being the first-step in a wider effort
toward privilege separation. As of Docker 1.10.0, all images are stored and
accessed by the cryptographic checksums of their contents, limiting the
possibility of an attacker causing a collision with an existing image.

Eventually, it is expected that the Docker daemon will run restricted
privileges, delegating operations well-audited sub-processes,
each with its own (very limited) scope of Linux capabilities,
virtual network setup, filesystem management, etc. That is, most likely,
pieces of the Docker engine itself will run inside of containers.

Finally, if you run Docker on a server, it is recommended to run
exclusively Docker in the server, and move all other services within
containers controlled by Docker. Of course, it is fine to keep your
favorite admin tools (probably at least an SSH server), as well as
existing monitoring/supervision processes, such as NRPE and collectd.

## Linux kernel capabilities

By default, Docker starts containers with a restricted set of
capabilities. What does that mean?

Capabilities turn the binary "root/non-root" dichotomy into a
fine-grained access control system. Processes (like web servers) that
just need to bind on a port below 1024 do not have to run as root: they
can just be granted the `net_bind_service` capability instead. And there
are many other capabilities, for almost all the specific areas where root
privileges are usually needed.

This means a lot for container security; let's see why!

Your average server (bare metal or virtual machine) needs to run a bunch
of processes as root. Those typically include SSH, cron, syslogd;
hardware management tools (e.g., load modules), network configuration
tools (e.g., to handle DHCP, WPA, or VPNs), and much more. A container is
very different, because almost all of those tasks are handled by the
infrastructure around the container:

 - SSH access will typically be managed by a single server running on
   the Docker host;
 - `cron`, when necessary, should run as a user
   process, dedicated and tailored for the app that needs its
   scheduling service, rather than as a platform-wide facility;
 - log management will also typically be handed to Docker, or by
   third-party services like Loggly or Splunk;
 - hardware management is irrelevant, meaning that you never need to
   run `udevd` or equivalent daemons within
   containers;
 - network management happens outside of the containers, enforcing
   separation of concerns as much as possible, meaning that a container
   should never need to perform `ifconfig`,
   `route`, or ip commands (except when a container
   is specifically engineered to behave like a router or firewall, of
   course).

This means that in most cases, containers will not need "real" root
privileges *at all*. And therefore, containers can run with a reduced
capability set; meaning that "root" within a container has much less
privileges than the real "root". For instance, it is possible to:

 - deny all "mount" operations;
 - deny access to raw sockets (to prevent packet spoofing);
 - deny access to some filesystem operations, like creating new device
   nodes, changing the owner of files, or altering attributes (including
   the immutable flag);
 - deny module loading;
 - and many others.

This means that even if an intruder manages to escalate to root within a
container, it will be much harder to do serious damage, or to escalate
to the host.

This won't affect regular web apps; but malicious users will find that
the arsenal at their disposal has shrunk considerably! By default Docker
drops all capabilities except [those
needed](https://github.com/docker/docker/blob/master/oci/defaults_linux.go#L64-L79),
a whitelist instead of a blacklist approach. You can see a full list of
available capabilities in [Linux
manpages](http://man7.org/linux/man-pages/man7/capabilities.7.html).

One primary risk with running Docker containers is that the default set
of capabilities and mounts given to a container may provide incomplete
isolation, either independently, or when used in combination with
kernel vulnerabilities.

Docker supports the addition and removal of capabilities, allowing use
of a non-default profile. This may make Docker more secure through
capability removal, or less secure through the addition of capabilities.
The best practice for users would be to remove all capabilities except
those explicitly required for their processes.

## Other kernel security features

Capabilities are just one of the many security features provided by
modern Linux kernels. It is also possible to leverage existing,
well-known systems like TOMOYO, AppArmor, SELinux, GRSEC, etc. with
Docker.

While Docker currently only enables capabilities, it doesn't interfere
with the other systems. This means that there are many different ways to
harden a Docker host. Here are a few examples.

 - You can run a kernel with GRSEC and PAX. This will add many safety
   checks, both at compile-time and run-time; it will also defeat many
   exploits, thanks to techniques like address randomization. It doesn't
   require Docker-specific configuration, since those security features
   apply system-wide, independent of containers.
 - If your distribution comes with security model templates for
   Docker containers, you can use them out of the box. For instance, we
   ship a template that works with AppArmor and Red Hat comes with SELinux
   policies for Docker. These templates provide an extra safety net (even
   though it overlaps greatly with capabilities).
 - You can define your own policies using your favorite access control
   mechanism.

Just like there are many third-party tools to augment Docker containers
with e.g., special network topologies or shared filesystems, you can
expect to see tools to harden existing Docker containers without
affecting Docker's core.

As of Docker 1.10 User Namespaces are supported directly by the docker
daemon. This feature allows for the root user in a container to be mapped
to a non uid-0 user outside the container, which can help to mitigate the
risks of container breakout. This facility is available but not enabled
by default.

Refer to the [daemon command](../reference/commandline/dockerd.md#daemon-user-namespace-options)
in the command line reference for more information on this feature.
Additional information on the implementation of User Namespaces in Docker
can be found in <a href="https://integratedcode.us/2015/10/13/user-namespaces-have-arrived-in-docker/" target="_blank">this blog post</a>.

## Conclusions

Docker containers are, by default, quite secure; especially if you take
care of running your processes inside the containers as non-privileged
users (i.e., non-`root`).

You can add an extra layer of safety by enabling AppArmor, SELinux,
GRSEC, or your favorite hardening solution.

Last but not least, if you see interesting security features in other
containerization systems, these are simply kernels features that may
be implemented in Docker as well. We welcome users to submit issues,
pull requests, and communicate via the mailing list.

## Related Information

* [Use trusted images](../security/trust/index.md)
* [Seccomp security profiles for Docker](../security/seccomp.md)
* [AppArmor security profiles for Docker](../security/apparmor.md)
* [On the Security of Containers (2014)](https://medium.com/@ewindisch/on-the-security-of-containers-2c60ffe25a9e)
* [Docker swarm mode overlay network security model](../userguide/networking/overlay-security-model.md)
                                                                                                                                                                                                                                                                                                       go/src/github.com/docker/docker/docs/security/trust/                                                0040755 0000000 0000000 00000000000 13101060260 021166  5                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        go/src/github.com/docker/docker/docs/security/trust/content_trust.md                                0100644 0000000 0000000 00000030036 13101060260 024422  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--[metadata]>
+++
title = "Content trust in Docker"
description = "Enabling content trust in Docker"
keywords = ["content, trust, security, docker,  documentation"]
[menu.main]
parent= "smn_content_trust"
weight=-1
+++
<![end-metadata]-->

# Content trust in Docker

When transferring data among networked systems, *trust* is a central concern. In
particular, when communicating over an untrusted medium such as the internet, it
is critical to ensure the integrity and the publisher of all the data a system
operates on. You use Docker Engine to push and pull images (data) to a public or private registry. Content trust
gives you the ability to verify both the integrity and the publisher of all the
data received from a registry over any channel.

## Understand trust in Docker

Content trust allows operations with a remote Docker registry to enforce
client-side signing and verification of image tags. Content trust provides the
ability to use digital signatures for data sent to and received from remote
Docker registries. These signatures allow client-side verification of the
integrity and publisher of specific image tags.

Currently, content trust is disabled by default. You must enable it by setting
the `DOCKER_CONTENT_TRUST` environment variable. Refer to the
[environment variables](../../reference/commandline/cli.md#environment-variables)
and [Notary](../../reference/commandline/cli.md#notary) configuration
for the docker client for more options.

Once content trust is enabled, image publishers can sign their images. Image consumers can
ensure that the images they use are signed. Publishers and consumers can be
individuals alone or in organizations. Docker's content trust supports users and
automated processes such as builds.

### Image tags and content trust

An individual image record has the following identifier:

```
[REGISTRY_HOST[:REGISTRY_PORT]/]REPOSITORY[:TAG]
```

A particular image `REPOSITORY` can have multiple tags. For example, `latest` and
 `3.1.2` are both tags on the `mongo` image. An image publisher can build an image
 and tag combination many times changing the image with each build.

Content trust is associated with the `TAG` portion of an image. Each image
repository has a set of keys that image publishers use to sign an image tag.
Image publishers have discretion on which tags they sign.

An image repository can contain an image with one tag that is signed and another
tag that is not. For example, consider [the Mongo image
repository](https://hub.docker.com/r/library/mongo/tags/). The `latest`
tag could be unsigned while the `3.1.6` tag could be signed. It is the
responsibility of the image publisher to decide if an image tag is signed or
not. In this representation, some image tags are signed, others are not:

![Signed tags](images/tag_signing.png)

Publishers can choose to sign a specific tag or not. As a result, the content of
an unsigned tag and that of a signed tag with the same name may not match. For
example, a publisher can push a tagged image `someimage:latest` and sign it.
Later, the same publisher can push an unsigned `someimage:latest` image. This second
push replaces the last unsigned tag `latest` but does not affect the signed `latest` version.
The ability to choose which tags they can sign, allows publishers to iterate over
the unsigned version of an image before officially signing it.

Image consumers can enable content trust to ensure that images they use were
signed. If a consumer enables content trust, they can only pull, run, or build
with trusted images. Enabling content trust is like wearing a pair of
rose-colored glasses. Consumers "see" only signed images tags and the less
desirable, unsigned image tags are "invisible" to them.

![Trust view](images/trust_view.png)

To the consumer who has not enabled content trust, nothing about how they
work with Docker images changes. Every image is visible regardless of whether it
is signed or not.


### Content trust operations and keys

When content trust is enabled, `docker` CLI commands that operate on tagged images must
either have content signatures or explicit content hashes. The commands that
operate with content trust are:

* `push`
* `build`
* `create`
* `pull`
* `run`

For example, with content trust enabled a `docker pull someimage:latest` only
succeeds if `someimage:latest` is signed. However, an operation with an explicit
content hash always succeeds as long as the hash exists:

```bash
$ docker pull someimage@sha256:d149ab53f8718e987c3a3024bb8aa0e2caadf6c0328f1d9d850b2a2a67f2819a
```

Trust for an image tag is managed through the use of signing keys. A key set is
created when an operation using content trust is first invoked. A key set consists
of the following classes of keys:

- an offline key that is the root of content trust for an image tag
- repository or tagging keys that sign tags
- server-managed keys such as the timestamp key, which provides freshness
	security guarantees for your repository

The following image depicts the various signing keys and their relationships:

![Content trust components](images/trust_components.png)

>**WARNING**: Loss of the root key is **very difficult** to recover from.
>Correcting this loss requires intervention from [Docker
>Support](https://support.docker.com) to reset the repository state. This loss
>also requires **manual intervention** from every consumer that used a signed
>tag from this repository prior to the loss.

You should backup the root key somewhere safe. Given that it is only required
to create new repositories, it is a good idea to store it offline in hardware.
For details on securing, and backing up your keys, make sure you
read how to [manage keys for content trust](trust_key_mng.md).

## Survey of typical content trust operations

This section surveys the typical trusted operations users perform with Docker
images. Specifically, we will be going through the following steps to help us exercise
these various trusted operations:

* Build and push an unsigned image
* Pull an unsigned image
* Build and push a signed image
* Pull the signed image pushed above
* Pull unsigned image pushed above

### Enable and disable content trust per-shell or per-invocation

In a shell, you can enable content trust by setting the `DOCKER_CONTENT_TRUST`
environment variable. Enabling per-shell is useful because you can have one
shell configured for trusted operations and another terminal shell for untrusted
operations. You can also add this declaration to your shell profile to have it
turned on always by default.

To enable content trust in a `bash` shell enter the following command:

```bash
export DOCKER_CONTENT_TRUST=1
```

Once set, each of the "tag" operations requires a key for a trusted tag.

In an environment where `DOCKER_CONTENT_TRUST` is set, you can use the
`--disable-content-trust` flag to run individual operations on tagged images
without content trust on an as-needed basis.

Consider the following Dockerfile that uses an untrusted base image:

```
$  cat Dockerfile
FROM docker/trusttest:latest
RUN echo
```

In order to build a container successfully using this Dockerfile, one can do:

```
$  docker build --disable-content-trust -t <username>/nottrusttest:latest .
Sending build context to Docker daemon 42.84 MB
...
Successfully built f21b872447dc
```

The same is true for all the other commands, such as `pull` and `push`:

```
$  docker pull --disable-content-trust docker/trusttest:latest
...
$  docker push --disable-content-trust <username>/nottrusttest:latest
...
```

To invoke a command with content trust enabled regardless of whether or how the `DOCKER_CONTENT_TRUST` variable is set:

```bash
$  docker build --disable-content-trust=false -t <username>/trusttest:testing .
```

All of the trusted operations support the `--disable-content-trust` flag.


### Push trusted content

To create signed content for a specific image tag, simply enable content trust
and push a tagged image. If this is the first time you have pushed an image
using content trust on your system, the session looks like this:

```bash
$ docker push <username>/trusttest:testing
The push refers to a repository [docker.io/<username>/trusttest] (len: 1)
9a61b6b1315e: Image already exists
902b87aaaec9: Image already exists
latest: digest: sha256:d02adacee0ac7a5be140adb94fa1dae64f4e71a68696e7f8e7cbf9db8dd49418 size: 3220
Signing and pushing trust metadata
You are about to create a new root signing key passphrase. This passphrase
will be used to protect the most sensitive key in your signing system. Please
choose a long, complex passphrase and be careful to keep the password and the
key file itself secure and backed up. It is highly recommended that you use a
password manager to generate the passphrase and keep it safe. There will be no
way to recover this key. You can find the key in your config directory.
Enter passphrase for new root key with id a1d96fb:
Repeat passphrase for new root key with id a1d96fb:
Enter passphrase for new repository key with id docker.io/<username>/trusttest (3a932f1):
Repeat passphrase for new repository key with id docker.io/<username>/trusttest (3a932f1):
Finished initializing "docker.io/<username>/trusttest"
```
When you push your first tagged image with content trust enabled, the  `docker`
client recognizes this is your first push and:

 - alerts you that it will create a new root key
 - requests a passphrase for the root key
 - generates a root key in the `~/.docker/trust` directory
 - requests a passphrase for the repository key
 - generates a repository key for in the `~/.docker/trust` directory

The passphrase you chose for both the root key and your repository key-pair
should be randomly generated and stored in a *password manager*.

> **NOTE**: If you omit the `testing` tag, content trust is skipped. This is true
even if content trust is enabled and even if this is your first push.

```bash
$ docker push <username>/trusttest
The push refers to a repository [docker.io/<username>/trusttest] (len: 1)
9a61b6b1315e: Image successfully pushed
902b87aaaec9: Image successfully pushed
latest: digest: sha256:a9a9c4402604b703bed1c847f6d85faac97686e48c579bd9c3b0fa6694a398fc size: 3220
No tag specified, skipping trust metadata push
```

It is skipped because as the message states, you did not supply an image `TAG`
value. In Docker content trust, signatures are associated with tags.

Once you have a root key on your system, subsequent images repositories
you create can use that same root key:

```bash
$ docker push docker.io/<username>/otherimage:latest
The push refers to a repository [docker.io/<username>/otherimage] (len: 1)
a9539b34a6ab: Image successfully pushed
b3dbab3810fc: Image successfully pushed
latest: digest: sha256:d2ba1e603661a59940bfad7072eba698b79a8b20ccbb4e3bfb6f9e367ea43939 size: 3346
Signing and pushing trust metadata
Enter key passphrase for root key with id a1d96fb:
Enter passphrase for new repository key with id docker.io/<username>/otherimage (bb045e3):
Repeat passphrase for new repository key with id docker.io/<username>/otherimage (bb045e3):
Finished initializing "docker.io/<username>/otherimage"
```

The new image has its own repository key and timestamp key. The `latest` tag is signed with both of
these.


### Pull image content

A common way to consume an image is to `pull` it. With content trust enabled, the Docker
client only allows `docker pull` to retrieve signed images. Let's try to pull the image
you signed and pushed earlier:

```
$  docker pull <username>/trusttest:testing
Using default tag: latest
Pull (1 of 1): <username>/trusttest:testing@sha256:d149ab53f871
...
Tagging <username>/trusttest@sha256:d149ab53f871 as docker/trusttest:testing
```

In the following example, the command does not specify a tag, so the system uses
the `latest` tag by default again and the `docker/trusttest:latest` tag is not signed.

```bash
$ docker pull docker/trusttest
Using default tag: latest
no trust data available
```

Because the tag `docker/trusttest:latest` is not trusted, the `pull` fails.

## Related information

* [Manage keys for content trust](trust_key_mng.md)
* [Automation with content trust](trust_automation.md)
* [Delegations for content trust](trust_delegation.md)
* [Play in a content trust sandbox](trust_sandbox.md)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  go/src/github.com/docker/docker/docs/security/trust/deploying_notary.md                             0100644 0000000 0000000 00000002503 13101060260 025073  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        <!--[metadata]>
+++
title = "Deploying Notary"
description = "Deploying Notary"
keywords = ["trust, security, notary, deployment"]
[menu.main]
parent= "smn_content_trust"
+++
<![end-metadata]-->

# Deploying Notary Server with Compose

The easiest way to deploy Notary Server is by using Docker Compose. To follow the procedure on this page, you must have already [installed Docker Compose](/compose/install.md).

1. Clone the Notary repository

        git clone git@github.com:docker/notary.git

2. Build and start Notary Server with the sample certificates.

        docker-compose up -d


    For more detailed documentation about how to deploy Notary Server see the [instructions to run a Notary service](/notary/running_a_service.md) as well as https://github.com/docker/notary for more information.
3. Make sure that your Docker or Notary client trusts Notary Server's certificate before you try to interact with the Notary server.

See the instructions for [Docker](../../reference/commandline/cli.md#notary) or
for [Notary](https://github.com/docker/notary#using-notary) depending on which one you are using.

## If you want to use Notary in production

Please check back here for instructions after Notary Server has an official
stable release. To get a head start on deploying Notary in production see
https://github.com/docker/notary.
                                                                                                                                                                                             go/src/github.com/docker/docker/docs/security/trust/images/                                         0040755 0000000 0000000 00000000000 13101060260 022433  5                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        go/src/github.com/docker/docker/docs/security/trust/images/tag_signing.png                          0100644 0000000 0000000 00000221260 13101060260 025432  0                                                                                                    ustar 00                                                                0000000 0000000                                                                                                                                                                        âPNG

   IHDR    ©   ˘eÙΩ   sRGB ÆŒÈ  @ IDATxÏù	ú≈˘ø_Óc‰æA`9πPåbP"jDç*?çxD≈œøx$1ƒàEQTPQ9ï[éÂå≤
»%ÏrÉˇ~∫∑gòŸ›Ÿù£{˙©|∆ÓÆÆÆzÎ©Y2ıÌ∑ﬁ*ı´ïÑ@ Ä   @ Ä JH†t	üÁq@ Ä   @ Ä  ` 2EÄ   @ Ä   @ .‚ÇëJ  @ Ä   @ @d‡; @ Ä   @ Ä@\ 2ƒ#ï@ Ä   @ Ä  Ä»¿w Ä   @ Ä   Å∏@dàF*Å   @ Ä   @ ëÅÔ   @ Ä   @ q!Ä»åT@ Ä   @ Ä "ﬂ@ Ä   @ Ä ‚B ë!.©Ä   @ Ä   DæÄ   @ Ä   ƒÖ "C\0R	  @ Ä   @ à|  @ Ä   @ àDÜ∏`§@ Ä   @ Ä ¯@ Ä   @ Ä  àq¡H%Ä   @ Ä    2Ä   @ Ä   @ .‚ÇëJ  @ Ä   @ @d‡; @ Ä   @ Ä@\ 2ƒ#ï@ Ä   @ Ä  Ä»¿w Ä   @ Ä   Å∏@dàF*Å   @ Ä   @ ëÅÔ   @ Ä   @ q!Ä»åT@ Ä   @ Ä "ﬂ@ Ä   @ Ä ‚B ë!.©Ä   @ Ä   DæÄ   @ Ä   ƒÖ "C\0R	  @ Ä   @ à|  @ Ä   @ àDÜ∏`§@ Ä   @ Ä ¯@ Ä   @ Ä  àq¡H%Ä   @ Ä   î  @ ÈE`◊ﬁ≤-wOR:U•Ry©Zπ|R⁄¢@ Ä ºO ë¡˚cÑÖÄ   Å"»ŒŸ&#^ô!s≤7˘ô‚<£À±r¶ı9Øgã‚V¡sÄ   §DÜ4P∫@ ¡%êù≥]Ü=ˇôÃ\˛S¬!¸Æ{siV∑™åüûç»êp⁄4 @ b2¯g¨∞Ä  ï¿aÅaZ“Üv«÷íøø∑@ÚˆÓèj7  @ <Ç7ÊÙÄ “åÄ
◊=?Mf%…É¡ìÊKÓnÜ4˚*—@ Ä@â	 2î!@ Ä RG`Âè€Â⁄Á¶ Ïnƒ9'e…ÒMj»ﬂŒö  @ ~%Ä»‡◊ë√n@ <Æy6yC€∆5‰i]"±Ü¿˘  @ àB ë!
≤! @ ^&`Üg,Å!;ÒÉzdIõFÍ¡Ä¿‡ÂÔ∂A Ä º@ ë¡£ÄÄ   Å$S`8∑Gi›∞AcäB Ä ÇL ë!»£Oﬂ! @¿wVYK$˛ÙÃß2'{c¬mwÀÉa◊ﬁ	oè  @ ?Dˇè!=Ä   ÅÄXı”vπ˙ü ‹ïâŒÎŸBZ6∞<ÚÌ¢õÄ   Å¯@dàGjÅ   $î¿Œ›˚d¡öüÂÇì[öO"ÎíUGñ˛∞Un{È+ŸΩÜD≤¶n@ Ä@∫@dH∑•?Ä  êñæYπI>òª.)}+_Æåº=cCRh”  @ Ω 2§◊x“@ HS?lﬁ)o~ïùîﬁ5©ù){˜LJ[4@ Ä@z(ù^›°7Ä   $ì@˝…lé∂  @ 8<<>@ò@ *Å¨˙’‰Ã.MÂÅ7fãn´Kj`âóûvú¥;∂V,èQÄ   è@d¯ a  @¿M‡íﬂ'9[rÂÛ≈Î›Ÿr˝ŸÂÀÔ~îÖk…ø˘º‰ΩŸk$;g[H˛Có˜î'&ŒóÕ;vá‰ıBÜø¸Æì<7y°Ã^±°®èôr≠Uó>À´üØêáá 2ƒè¬Ä   è@d¯ a  @‡høùÂ‰ËΩRŒï}9◊æ€±ÖµµÂüví◊>_≥¿p\£÷≥eÃ'ﬂIùc*«÷0•! @ <DœB ÒVZ[’Õœﬁ(∫Eû&ΩŒ›µOÍ’ î˙53Mû;∑™Î\õL˛§àÄ-"DíÏ{°¶EŒµ ËçÇ4ã–j§ÂÅ·’œ,Å!;6Ü6çU`Ë$£?^"ﬂÆ⁄$ø=°iXÌ\B Ä  ‡wà~AÏá@1®Ä0yÊjôgMÙ£◊SÑ@ˆFlh]ONÌ‘DN±‹ùIÄ@*	Dï£ î.%Â îñÚeÀ8y˚ì_÷ /s$ﬂˆ,xG	[`˜Ÿ2ôc	ì±$ty≈ø?Z"ÛVoäÂQ B Ä  ‡#à>,LÖ@I	¸d≠„˝˛Bôæ‡˚Ë¬B!çh?ÕX%ì≠è
z∂ê=≤p(Ñ∑!/’3+»Ô∫g…9'e9U˛Î£E“ºﬁ1“≠U=Ÿ≤sèì€K_I´Ü’Âˆ¡µ‰óºΩN˛∞Á?ìNÕÎ»»Àz û}BÚùã∞≠GΩ^ô∂4fÅ°mì√aPπÑ   §!ÅRøZ)˚Eó  ıTxÍÕπFpe;ßôï K˚¨⁄íeM"4’µ¢æ◊©û!k¨hÒyGñP,≤\õEy˚òYπº\ÿß≠µœë  Åƒ¯œ¥er›s”$≥Rπ"7∞oˇ!QØÖX”sª»WKt‚-®¿†^/∫TÊÆåÕÉAÜøÏ,/|∏HÊØ	J©À%ﬁº˝¨XÕ£<  @ &Ä'Éá” ∫,‚©	séÚ\P!aPÔ÷“!´é%.TãÿT«uÚÛ˚>]hâ3ó¨óOÁÆì‹#Ñä£'-0"∆ùWÙí.÷€T êπª˜'¶‚(µÍNÍ¡0ˆì•ÚÕ™ÿÜ„õ‘4œ˛”Ñ	Qö#Ä   ü@d˘ b>¢–âˇﬂ,óhçπ‡N**\“øùÑÓÖúÎs˙πfP˘dÓZ7eâl‹ögû“•◊èö"7Ó&É˚¥)§&nC ^'`ÔÒR1Üv«ûüå¿‡ıq∆>@ Ä@<	 2ƒì&uA¿#T`ˆƒ≥KÑmíz.‹tQ˜bãv=ÓcøÆÕD?*4LúûÌx6®ÁDˆ˙≠2bH/wqŒ! Åà¥ˇDQÃ8∂NU9µ]C≥’§ÓKRÅ·/øÎ,œZ1`Æ]"K=îÖ   @¿¸7fXÅ	Ëˆì#_˛:D`‘ªï\⁄ø}Lkπl$ÏÊ•ñgÑä˜[AÊVÁl3w50§⁄ÚÚàÅa•πÑ JB‡™~«À“∂»¨Â°^J7üwÇº7kµd[±T‹iƒÖ›D∑õ\∑iá;[⁄[Ó}ñÏ∞D…‘®Vπ»ZNıÊW+M@I*Y‘§;Pl-yÏøﬂ 0Â  @ iD ë!çìÆ@¿ˆ`–£ùÜ_‹› ˆu¢éÍ)ÒÏ˛2ÍıŸfÖ∂cx4$ä:ıó@î≠+KE…èT9kkÀÕøÏë“V}Yı"«lâVe≥∫«»rK`ƒÉ!!Ú! @ ÈM ë!Ω«óﬁåÄ∆`HÖ¿‡∆¨¢Ü
∫ÑBìz4hBh0¯O@u≥qT,Ç√—ã*^˝bôå≥< bM˝:7ëÍôc}åÚÄ   §	DÜ4H∫çÉ‡ÚxœUßHk=u*í.ü–`êRì
Ω;6ñﬁùö§¬⁄Ñ@Z–	|ùjï•±µ§¡Ná,Q·òå
Rœ⁄zv˜ﬁv∂¸∞yß‘µ ∂i\√‹∑o®óA≠™ïDc'‰Ì—Úñ»k)Y∏é¯	6#éÄ   è "CÒ∏Ò<E@≈Ö	Só96È$?UÉmÑz4ËV{∫›•&çÒ∂µµefÂÚvéÄ@1T(WZŒ:±©tjVÀyzÙ«ﬂIïäÂ‰¸û-dÀŒ›N˛˝÷Ú•Ìy{•kÀ∫≤5wèìØ"√V´\œ„ÍÀû˝ÛÛ]"Cô“•M˛ï}€ äúÌ2cŸèN9=~n˘¿⁄ vπ‰ï@ Ä là6	é1Å«~ÌXﬂ£]#+»c;Á:ï'*4\1rìŸuBóqº¯˛≥Ωe*m¢m¯ù¿CÊFÏ¬çˇ˛"b˛›„fFÃøÈ≈ÈÛ£göu—osÄ   Xø¶  ‡[XK~⁄íkÏœ¨T^Æ‘Ÿ3}…¨TNTh∞ìz[h0H ‡S&÷ÉOm«l@ Ä íB ë!)òiâ!†ﬁc¨}ËÌ§[Uj–E/%]∂°ﬁv?u©} +nC¥Xí7í@ Ä ,,ó‡k ¯b¡˜!^É¨}ÌΩòT¸∞c3LûπZÜÏ$ıkfz—TlÇÄÁ	\’ÔxYjyÕZ˛Sà≠7üwÇº7{çdÁl…øÛ¬nÚ™µKƒ∫M;BÚ⁄[Ó}ñÏpmyR‡»ÖéÏ—¶ÅÙÌ‘ÿπ˝≤%∂nX]ö‘©*[vÑ∆Äp
q@ Ä@ 	 2rÿÈt∫ònâv“âº.ObÍÿ¢ét»™#ãVo2ÊÈn*4ê  ÔxıÛç|‡ç9Û…Ñ   @ ÿÇ=˛Ùﬁ«t©ƒópz–Øk3Á‹ã'gtkÓà”-ªº8Jÿ‰;∫L!⁄Ü"w¶‡JtL  @ (*b2ïÂ ‡1∫T¬NYñ€≤◊b1ÿ∂Ÿ«ì¨ÿv“‡èv∞J;è# P•¢CàEyà•l1l‰@ Ä E OÜ@7ùM'Ó•^˜bPÓ∫î√ΩdbﬁärVœÈ4$ÙI!PøzÜÙ8ÆæúŸÂXßΩOY"m◊ê&µ´»÷ù{ú¸{_õ%ö÷í,kóóù{ˆ;˘7ºπtkUWΩÚdŸw‡PHæsq‰‰˙≥; óﬂ˝(◊˛rÎn´Œó>Y*x:Ñ`·Ä  xàÅˇ
 ¿ØÊØ‹Ëòﬁﬁäw‡á‘¡äÕ`«eòüç»‡á1√FÔeáñª«ÕåhÏïO}1ˇÃªﬂâòsf¡´-bÆé  @ 7Dè÷îÄ.7–òö2+ïó¨Ü’|AB∑≤gΩq’§qHÄ@Ïr∂‰∆Ù–ÆΩ"ñèñ±∞…å¢&î“Âzè@ Ä Dà…¿∑ >$0œÚ∞ì_º‘^CT—§"âä%$@¿/¢≈n∞Üh˜˝“?ÏÑ   @ dàEÍÄ@í	∏„1Ëˆê~J*äÃ\≤ﬁò¨bIKk9	(:Å´˙/K-Ån÷ÚüB∫˘º‰ΩŸk$;g[H˛ùvìWß-óu?Ô…|hoπˇıY≤„àWT»M◊EÛz«H˜÷ıeÀé›NÓ≠/}%õ’çÀêÁäıp„øøp p@ Ä@0	 2s‹Èµœ	ÃœŒè«–√µkÉ∫’´}#GdP±‰¬>m˝`66B¿ﬂ,'É(ã
Ì◊]Qb=\˛ƒîBü•   @ ¡#Ä»º1ß«>'‡^*°€Vz}Î p‹Ì≥j;Yn±ƒ…‰àÅÄ.Q∞ó+∏ã†(ÿ%ıxtä¿ëBnO˜s˚t_r@ Ä b2EÄÄœ∏óJËñê~K·¬àª?~ÎˆB *ï/+ÀI’ Â≠OŸ#«ÚR±\≥U¨…œ®`Ú’æj÷y√öô“¥NUif}ö÷ÆjÃÆb≈G—-/5øiùcÃ1RtK]ût©D„ZU¬≥πÜ   @ ‡d¯ÄÓ˚èÄ˚Ì«u˝◊À‚û÷.ÔL_alWœåﬁùö¯≤ÅT®ñQ^ÆÏ€Vú–‘i˛ââÛ§ô;aÿYe{Ó^'¯ËÈR©BY9Á§Ê≤=/?ˇ°	sÂK§∏‡‰ñ≤wæGÇÊGNº%"$Ä   ÅÄ@d¯ÄÓ˚ã@¯é'˘,ÉMªÉ¨“‹¢â}ü# ù¿ÉQÑÄ°OÒ°Îüˇ,b˛EèMéò93Ú"ã»e…Ö   @ »X.‰—ßÔæ#‡é«ê’∞∫qçˆ]',É›€nÍ6ñ?m…ıc7∞¡#ÄCC∆úC Ä b$Ä'Cå¿(ÅTpã~å«`≥À¨TN‘˛E´7ô¨y+6»Y=[ÿ∑9B Ë’∂ÅÏ¥∂ù\¥nsH©^mÎÀˇ6ÌîıõCEªÀNk#~ªN6ª∂†‘5ˇ’œóÀ°_VtÀ„õ‘îç€w9ÌÈ≤
ç”◊AùC∂¿º˜µYNN  @ &DÜ`é;Ωˆ)Å/¸‡XÆK¸ú‘~[dòo≈e@dÛhb{2	t±∫/Ø?™…æVlì?˛Ó®¸6ç´ë!¸Üä*2ñFΩ3/bëøºyƒ|2! @ 6DÜ`è?Ω˜]R‡^V‡^r‡£n8¶ˆ∞Ç?éõ≤ƒ\O_ò/û88Å b&`"'®cBC(‰DYŒ-?f£y Ä   Å¥"@LÜ¥N:ìŒtIÅùt©Å.9s jXÕÍCy”ÖÄñ~Ó∂C ô".tà£¿†}©WΩ≤˘Ñ˜KÛkU≠ûÕ5  @ 'Ä'C¿ø tﬂ?tIÅù¸æTB˚°K%Í÷»ê‹ú}¶[o¢e„v9B Qd’?F~µ‚([ß™S‚#+ÊBÀ’DóLlŸ±«…ü4gç¥µ‚)ËVïπª˜;˘Ø|∂L¥ûKO;Œ™À…ÕOóüﬁVﬁôπJ6lÀè…†en¯]gâ∂î"ºÆ! @ DÜ‡å5=ı9˜Vè∫Ã`—™MrF∑Ê“∑kSœ˜,oœ~cÔÍúmÊh«bp>}¡˜raü∂Ó,Œ! ÅﬁùπZé…® •¬<˛˚’*S:<?öpˇÎ≥#‘N  @ (DÜíÒ„i$ç¿)ùÀÑ©˘ou¢ÆüW¶,ñ~]õYÇC3©S=#iˆµ°â”≥Âü#és◊—•U=˜%Á$›¡·√o÷…l◊Ú(Q∑Ze©öqxy—gÇ>jôâ≥VÎ·®ÙÂw9GÂiF¥¸àÖ…Ñ   @ E$Ä»PDPÉ@™	‹8∏õËD¸É´‰KW†ƒç[ÛL Eın–`ä*6Ùh◊0’Êöˆg.…â*0‘´ô)-Uó.≠Îô~±T¬CÜ)$†√àWf»Î_¨8 
]
qnèGÂ'#„ÿ:UDw¥®c	v˙zÈè“–˙Óf˝õÙÀÆΩG≤K…◊K#ˆs! @ HàÈ?∆Ù0çÙ∂÷[ÎGwôòlâ„-œÜ‹›ách7g.Yo>Y´Àc√Nóåä©πÊ«Ì2 Âé≠¢BoÀ£e£FX®o]ì  Å√T`∏Û?3‰çÈG©f¥¯[L¸áJÂÛ2®»∞‰õ•yΩ™!±R=Z¥@ H=Å¸_©∑  Å"–	˙–ÅùÃG=&[AŸ‹14ˆ¡?≠ΩÌá_‹Ωà5∆∑ò∆`PÅ¡@tâˇå(ôïª{«∑5jÉÄø	ƒ*0‹|ﬁ	ÚﬁÏ5ím˝ùª”Có˜í'¨•IõwÏvgÀìWü*wçõ"î+SZû˛”o‰∫Á¶ÖîçtÒœ…ã"eÀco}1üL@ Ä ÇM ë!ÿ„OÔ”Ä¿Y=[à~‘ª·©Òsú•üÃ]kzól°A=ÓÛ•Ë2;=r›i6épPÅ·éˇ|-„≠ÿ%%OÆm"J^5@ Ä   Åb(]¨ßxınxÙ∫”e@è,«6Üçö"ÍYêå§√≠œNÓ“Àƒ\HF˚¥?PÅ·ˆóK"0Ñm/awﬁΩ'•ùgé≈!n=ˇD≥=fHU÷≈√÷ﬂv≠™√≥πÜ   @ ‡˛†˚ÈG`ƒ'á∫tb»ì¨Xâ»¶Å'Ø{¸#gâÑíUÅAΩ,HÄ@(ÅMGÜ	_›É°bÖpÁ√(¢A¯ñN”QD	Á~qNQgqÏ‡@ Ä ºB ¸ãWÏ¬@†ThPœÜ—Ô/4µhl]¬–¡äÛ∫«u´K›FS„/∏óGh]"¡∂î%DM[{ˆîùª˜À’˝€ôOQ:Z-£ÇÃ\˛ì)⁄¶q©}L%Ÿ≤cœëG5ÒNhQWÆ?ª£Ï⁄{¿©Ú±∑æëÆ≠Í =ü$˚rÚÔyu¶úhï◊8Ó§K7HÄ   @†$JBèg!‡a≤≥µ=‰ﬂû˚ÃÒ.PA‡rÀ´A∑∫<˜‘VFt(n>ùªN^ô≤8D\–∫ZX€RÍ≤vè(.YûKw∂Ê eO|$Î6Ó(rWOÎ–Hz∂i` ?ÚÊ‹àœ]ˇœœ"Ê≤˛Ê√”˛Éád¿Ω√≥#^Wµ∂÷µ∂Øtã9VòLk˜ö˙’3§Bπ2ŒsöOÇ   @ ÿÇ=˛Ù>Õ	®'¡€ù/OMòcÌ@±⁄È≠Ω’e›FhËhΩ—Ï–¢vÅoa—™M≤–˙,∂ƒ
{ÁªRı^∏∞O≥„Öù«8ö¿!kïCÆÂ…∞cW˛ˆ≥Gó
ÕŸµÁÄÿ°VZãëR¥¸›&Ïg£Â€˜Ì„1ñ≈'∑î≠π{Ì,πÔµYR€.=Ì8Ÿµ/ﬂsBÛIÄ   õ "C∞«üﬁÄÄÓ:!÷m›>27lR£K>Ÿ∫VÏù(áäÕTs»®˜CQR´˛*ï+ò].b(
1 ù@ıÃ
ÇR≤-◊^ˆpòHıÃä≤wˇÅœÅT≤˙sâãùúJ≥hÄ   è@dË¿`JB@≈ÑÒ”ñ…‰´Ã§?ñ∫‘C°®¬Çª^≥Ö¶Â1°^Ω;51OÈÿÿ]Ñs@¿E‡/øÎ,/ZS∑Ö≠0∏˜íì‰ˆ±_πJÜû6ÆYEµ	˘aÛŒêçkWë›V<ÜpÖS€7íoWm4ﬁˆÂ îñûm»ã◊€Y! @ Ä@\ 2ƒ#ï@¿;4ÿ„¯©KèÚZP’K°}VmkiD]«[Aó>Ë2à¬ÑÖgwY€b.¥&.ãWˇ,∫ÉÖ;M_ΩËß•†ÓÜ¡]	 ÈÜ√9äJ@7èà∞y√ÖV<ï˜f≠9™ñk€^ûò8ˇ®¸A'eë!¸∆Öß¥Bdá¬5  @ %&Ä»PbÑT o–ò£'-8 sA≈Åæ]õJøÆÕ%´a˛2€Íé-ÍàÙ∑Øƒ∂áƒ[®g≈m–ÿëRèvM∂Æ/W±‚ù/VÑà+ÿ*◊èöb<Tl`E$ä‰A@‰WÎ•¬ÖÉ√™†{¶û€[F-ú:9Å   @ q Ä»àTÅT–•OY—ÊuiÑ;©0p©µEûÓ$ëY©ú˚VÅÁëÑà∞nj˝*8ËG„<ºbπÄœZí„àÍ’0/{É‹pAW≥å¢∞˙∏Å hhm3€Ÿ⁄V∂Q≠Lßª≥Wl0;9Ë∂ì{ˆ<Ï…A/pàxÂÅÖâàë	@ Ä b&Ä»32ÄÄwhÑø=ˇô®«Äù‘sa¯≈›ÕÑﬂŒKÊQ≈çõ≠ˆ’ªaúµ≈ÂƒÈŸ¶yC|˘kŸ`âCœÓòLìhû$∞ﬁä©p\√ÍRœ⁄•¡N*2,˝~ã¥m\Sˆ8dgÀˇ6ÂowŸ¥nU9—ZÚ§€Jödi
_.Õ1b≈I«’ó_ÚÚwÅ¯Úª—ÚgùÿLvªvÅ¯õu“ƒä·ªÓÕù6Ù‰ΩŸG/√)¿  @ (Ñ "C!Ä∏ØPaaÿSBb/®◊Ç
±x.$™j√5É∫Oä'ﬁòm<¥-]“°∂?rÌiâjöz!‡˜ø>;¢ùëÚ˚Y¡TÌ4ﬂäÉR∑Z%)S:ﬂ5AEÕolyET∑∂ú¥ìäc>˛Œæté˚í>\Ï\s@ Ä ‚E ë!^$©I$.0®˜¬]Wû,&æBÌ(JSj”≥√œî&Œs∂ ‘Â#-ØÜCz•
 @ .£?^‚∫ ?}Ú›£É>Í›Is"{'DÀœØë3@ Ä  ;DÜÿôÒRJ@ó∏=T`xÙ∫”#uL©°Æ∆’´A=,4}2w≠9j	Õøqp7sÕ 4∫‰A”7÷.-Ó-ﬂ]Üs@ Ä  ‡U•ΩjvA G£¿‡ÓÖ
˝∫6s≤&L]&Ñ¨tnrÅ4'–†fÜ‘è∞sK˚¶5•|π2Q{ˇWkR++ñCx“¸ZU+ÖgÀìWüz‘™reJÀﬂˇÙõ£ í@ Ä JJ ë°§yI$‚˚á„ÿMz›É¡∂”}<î≤ëìı¥µ3Ü∞$A E#‡é≈‡~¢v’ä÷FòEOe-°Å@ Ä ‚MÄ_Ò&J}Hç√†o˛Ì§Aã≥›§˝|*èáÉSñ7&®w∆”Ê¶“⁄ÜÄ?	î ¸hw‡Ë˚G@ Ä  êƒdHgZÅ@â	∏'‚≤Í»†ﬁ≠J\g™*–X®Ú∂Á¶4‰ºÏ“•UΩTôDªH::e’ñ˝iªîµmÂA©cmMY-≥¢T≠\Œ±©fï£óA»Ø±¯-8Uq@ Ä J ë!°x©Ò!†qtÆI=⁄A„S{jj—]'4>ÉREîóGLç1¥
Åò∫…®Xﬁ|ÏÊ∑Áîèæ˘ülÕê|˚æ€4Æ!ï óïMøÏr≤u; éÕjÀê>m%wœæê¸.ñ(y”†dﬂ~[Ã¯UFΩ3O:4≠%˚}Wß¨Xã-˘Ô7ÆkN! @ Ä@Ïbg∆H:ÅgÆv⁄‘ây›¡‚ú>:π¥;Gd–Â ˙iiM†HÅ‹=˚Âµ/ñGÏÍ¬u?á‰˜Î‘ƒπ~˛ÉEŒπ˚‰ûWgπ/ùÛ´û˛ƒ9∑Oˆ<$Cû¸ÿæ‰@ Ä ‚F ë!n(©â!†Am/m¡œÀ$¬	©X“£]#ôπdΩπ5~ÍRq≈…·≈∏Ü@Z®Y•¢È◊ñù{B˙-ﬂ.æÂea˘´⁄n	9FÀ)ƒ  @ àë ÅcFq$õÄNºÌ§ÚtÒb∞˚‰M¶[Ó„íÅ Ë’∂ÅÙlSˇ®Æ˛Æ{si›èû£¿ê@ ÄÄ/ 2¯bò02»&ªñJ∏'‰È¬Dc3ÿ¬â
_XA I+¸c¥¯çvèz
@ ÄÄ_	 2¯u‰∞;4FÅ˝f_>ÍÑ<SOÀC√N+◊oµO9B ¢Ì;ivèà¶@ΩÑ   @¿à…‡ø1√‚ »∂D;5oPÕ>MªcK<yg˙
”/VH’Z5¨.?∫dB∑∞,[¶årmQ©y$@ Ä  ‡à~%l,Å˘G∂≠T :O◊‰PÊgoL◊n“/ÑXid<˛ÿZ“÷µ£ ˇ6ÌêÖk7ãn;ÈŒﬂÎl?RÄ   @¿s<7$Å|+◊os.“Yd–ò˙Ÿ∏5œÙWw”Ë“™û”wN êéñ~øUñ~?'b◊>˙v]Hæ{Àê\@ Ä   è &É«s ‡&‡^:–¡z≥ôŒ©nıåtÓ}É   @ Ä@  2bòÈ$ºO √
liß˘+6ÿß! @ Ä   @d—`aj∞¸¥%7PŒjòæÅ-5êtÄ   @ –=¸tﬁÀ‹"CñÅû@ Ä   @¿Îº>Bÿã@F≈rÅ‚‡X’q:ÅÄhﬂ¨V¿zLw! @ ÈO ë!˝«ò¶Åº=˚”†EÔ¬Œ]˚ä^òíÄÄ/	úﬁ±±\–´•/m«h@ Ä ¢@dàŒÜ;H)Å˙53ùˆWÁlìqSñ8◊Èv≤Ê«Ì2qz∂”≠.≠Ÿæ“Å¡	“êÄ
è^q≤¥i\#{Gó  @ ¡&Ä»ÏÒß˜&†"√‡>mUd∏ıŸi≤i[ûìÁ˜ı––~]˜¯Gíª˚∞˜B=´ﬂgıh·˜Æa? Ö@Ü(d»Ü   §Å≤È—zÅÙ$gwí\kÈ¿‰ô´M≠ﬁ$ó?0Iz¥k$Ω⁄7íÌ˙2^Éz.ºÛ≈
ôπ$«¥Éô÷6ñè^{ödVŒﬂŒ2=Gñ^A ò˙vj"]ﬁÜ`?ΩÜ   ÅÄ@d»@”M–…ˆÀ•Xè¶.s:1s…zkÇæ^‰uëYu§Cã√›Ö¬ãA"UYì≥]tŸG∏∞`w™s´∫r„‡n“˜i	G§[`h€Ñ%i5∞tÄ  F ë!ó"ù|ÎÇß&Ãë˘ŸCL‘	º~d ·lıhﬁ†ö‘≠ëa>ıjdJùïÕÕDâ¶}´Öº›˚çê†ç-ZµIt9Ñ
%]1ÙÏérVœ„ ‡c˝:7ë/Î%>DLá   ë "CAQ©&†o¯ü~¶Ëˆéìg¨í¨%¨Û§±Ã§ˇ
ã€!◊Fà®ûíWÿEQÑÉ¬ÍP!§wß∆2¿∫¥"»caº∏?PÅa‰e=¸<àÿ@ àÅ "C∞(
/–ÄêCv2Ê≠ÿ`y7lêÏ∂ ™ı{Ñ€øqkûË'—IΩZ6™.∫kÑä
,âH4qÍáÄ7ú—˘Xy‡≤r|ìöﬁ0+  @ H8DÜÑ#¶$éÄ
∫Ã¿Ω‘`•%6®¯†GM*>®w√O[Ú"z>ƒ√:ıLhŸ∏∫©JÑ*÷µ
ıke‚©¿‘Å8xËPâZÌﬂÂXπˇRÜA‰a@ ÄÄ	 2¯p–0–Iæ~z[Q‹KÛ,à‚§Vçj∞Dq¿ÒJ@†LÈR%x:πèvhZKtô…ÂNkÄ   /(ı´ïº`6@ Ä Ç@`”ˆ]Úç5◊
åZ‘‘¨nU©PÆå,èqITQÎ/◊ÕZ÷¥q[û¸ÔÁù·∑
Ω÷‡éU+ïì&µ´ZñÄ   §DÜÙSz@ Ä   @ H	Å“)iïF! @ Ä   @ H;ài7§t(àˆÏŸ#;vîR•J9ü™U´ ∏q„ÑQA¸F–g@ Ä   §Ü ÅS√ùV!wπππ2k÷,©U´ñVÆ\)êö5k o˚€∏∑GÖÄ@r‰ÂÂIŸ≤e•BÖ
…iêV  @ Ä@	‡…Px<
/–IHõ6m$++KZ¥haÑÖ´ØæZñ.]jÃ\¥hë¸Ò∆”aË–°≤uÎ·-.◊≠['ÉíÎÆªNÍ÷≠+k÷¨ëgûy∆Òàx˛˘ÁÂ–ë≠ÏÊÃôR«∆çM›Z«Âó_.£Fç2œıÈ”G/^Ï%<ÿ_P§±c«öøßÃÃL©X±¢‹v€m¢Ç	Ä   xô "ÉóG€ #ÅΩ{˜ ¡ÉÂ¿ÅF\x˜›w•]ªv≤a√≥ú‚Ø˝´¨_øﬁºUaAÀÈGÀizË°á$;;[}ÙQYµjïÃú9”àﬂ~˚≠πÓﬁΩªh*DËçﬁΩ{;uºÚ +&˘ÚÂF‰∏ÛŒ;q"∆nPÅ'p˚Ì∑À]w›%*ÏÌ‹πSVØ^-ü}ˆô\|Ò≈Êo<Ä  @ ÄÄg	 2xvh0±–7ùuÍ‘1n’Â ï3'úpÇút“IÚÂó_JÛÊÕÂºÛŒ}+z„ç7öºÔøˇﬁ4¢œ=¯‡É¢:°Ÿ∑oü®wÇ
?˛¯£tÓ‹Yfœû-4eö5k&ˇ˙◊ød˚ˆÌ≤`¡ßéë#GJÎ÷≠Âñ[nëˇ˝Ô±uÄ“ÄÄ!†ü
}ü~˙©tÌ⁄’¸ÕÍﬂÔÑ	åX∏ˇ·≠/Ú,“øu)4Nã
Kñ,ë≥œ>€\?¸√F®–øqÕSAPÀùyÊôŒﬂÌ|`<õ4ø[∑n2oﬁ<c[A^K˜ﬁ{ØºÒ∆Œ(.[∂L.π‰#D:ôú@ Ä  êˆ“~àÈ`PhLtôÇNt¢2yÚd9ÊòcÃBΩ4>Cµj’å†\t…Ñ∫e´P©R%ÉÍ‹sœï?˛Òè“∑o_©R•ä‹p√¢À"Jó.-ßûz™©Kñ)S∆ƒ–s≠CÎ’Úˆµ9·?Ä@Ã∂m€fDA‹©i”¶Ú¿ò•˙˜]êg—;Ôº#ªvÌíÔæ˚ŒxA¥oﬂ^ÆΩˆZQÒ‡é;Ó0ˇ>®ì^´∞®b¢.ß:„å3åp®‚Éz'©ÁSø~˝å0i{IEÛZ“ÁÔπÁGT¯ÔˇkñoÈR.  @ ¡!Ä»ú±¶ßiN@»wË–¡x®ÁÅ∆f∞ì.£¯Õo~„,m–7°3fÃp 4lÿP ó/oäˇ¸ÛœÚß?˝…,á–7•+V¨0o'5.Éûªì.ô∞ì∆sP!ÇîåÄ.Y“	ª
y—RQ<ãFå!m€∂5Kú˛á?»Ygùebµú~˙È≤c«Sµz1©R˝˙ıÂ˛˚Ô7ﬁI*N|˝ı◊Fp®^Ω∫úr )¶¨z5h≤ü	˜Z:Ì¥”Ãr+ıê“4¶ƒ‡¡ÉÕ3¸Ä   Å‡`Fú±¶ß †o#%>ˇ¸sô:u™âì⁄kØIœû=ù7éø¸ÚãÛÿ{ÔΩg<‘3Bﬂ~Ínö4®‰øˇ˝o3˘–	ƒã/æhñUw‹qÊæªì¡  Åb–eN*"ÑyTè!]û¥{˜ÓB=ã‹ﬁIjDó.]å-*®H†IÎ´WØûÒd“k€;IE!µlFFÜ&‘SISA^K˙o≈UW]%_|ÒÖT¯¥ˇ}0Û@ Ä A ∆@3ù:ﬁzÎ-ÈﬂøøA°À4à\Ì⁄µÕõK]Ra']ø=m⁄4G\–Ì/ØºÚJ©Q£Üº˛˙ÎrÚ…'õ¢:Q˘Ë£èú	äª-~m◊œ(òÄ
õ6míπsÁäzÿI4daûEnÔ${wª˜µäâ∫l¬ˆdRQΩ>˝Ù”&éÉz+Ëv∏Í›dßÇºñÜ"7ﬂ|≥(ˇÚóøò1ˆs! @ <Ç1ŒÙ2Õ	h–G] †ÆÕ—íÇ”e¨QΩt˘Ñ¶ñ-[ ÙÈ”ù•U´VïÒ„«õ∑®˙&U„:®¿†È¢ã.2n–:1—8∫,CSx·◊¶ˇÅ äD†Q£FÚ»#èò≠e?˛¯cÛ7;k÷,òQÉ≥j‡’xx©ßÇ∆jy˚Ì∑EóP©wí&˝w§rÂ f9ï∆k–@Æ999ÊﬂΩ_ê◊“â'ûh˛Ì3få0@ãì  @ <6‡t7ÿÙm•˝∆≤0:…àî*T®`∂¿åtè<@ >Ünº lÔ#≠ı÷[oïªÔæ€,cPèÜ¢zÖ«Jq_´G“3œ<cv†–s]V•A`ÔªÔ>'¨∆lP!rÛÊÕ¶s·^JÓk˝w„Í´Ø6;c4i“$>0®Ä   _(e≠Ø¸’Wc,  @  4Œäz©8®K·IΩìtπÉ∆Nà5È2›IFcµ®wíz1πìáT— ñ›!Ù'Öz<]p¡Ú˚ﬂˇﬁ]ÁÄ   Ñ À%2–tÄ ¸G@É1Í‰?í¿†ΩQœ¢‚˙¨ä˚AÖÅpÅAÔk^,Énü´^4“ÌÅ°uë  @ <Ç3÷ÙÄ  ‡–]*V≠ZeÇ4:ô%8Qœ]n—µkW≥%f	™‚Q@ Ä |L ë¡«ÉáÈÄ   @ Ä   /`πÑóF[  @ Ä   @ >&Ä»‡„¡√t@ Ä   @ ÄÄó 2xi4∞Ä   @ Ä  ‡cà><Lá   @ Ä   xâ@Y/É-¡"P™T©`uòﬁB Ä  w∫+	Ä ºC ë¡;cHK¯a»aß”!`ˇ;ÄÇÖ@†¯w£ê(@ …X.ëd‡4@ ˘æ˛˙k9r§|˛˘Á˘ôúA Ä   ¯ñ@)Î>fæ>Æo¯˙˘{±Ò `ˇ;¿…x–§ã ø%Ç5ﬁÙ<¸1NX	@ -	Ãö5Àx2Lù:5-˚Gß  @ Ä@–‡…¥˜Py˚‡°¡¿§ê û)ÑO”9~K¯| 1HKx2§Â∞“)@ ˛ 0wÓ\„…Ò«˚√`¨Ñ   @ (ê û‚·f"	ˆ!ët©˛!Ä'É∆
K!‡5¸ñ⁄à`  <¯@ Ä@ Ãõ7œx2|¯·á)≥ÅÜ! @ Ä ‚G OÜ¯±§¶	ˆ!F`á@ö¿ì!MñnA 	¯-ë»4@ Fx2ƒå‚Ä  ?,0ûÔøˇ~¸*•&@ Ä   Åî¿ì!eËiò∑|  %Ä'ﬂ@†∏¯-Q\r<@ qdH[jÜ   ÅB,Y≤ƒx2º˚ÓªÖî‰6  @ ÄÄ 2¯aî∞±P∑ﬁz´Ë€åHüé; M7›$ﬂ|ÛM°ıî¥Äm«≈_,á*Vuê∑ﬁzKÚÚÚäı<A¿O⁄µk'#FåêsŒ9«Ofc+  @ Ä@àQ¿êÌ/M»-Z$O>˘§tÌ⁄U>˚Ï≥ÑvlÀñ-¶˛úú«<ñgœû-≠[∑ñÎÆªNˆÌ€À£îÖÄ/	,[∂Ãx2º˝ˆ€æ¥£! @ Ä B	îΩ‰
˛$P¶L«_|Q™WØnÆu¢>a¬yÁùwÃı=˜‹#ßúräî-õòØ˛E]$Ω{˜ñ™U´JÈ“±kxˇ˙◊ødÕö5RßN©P°Ç”'N êÆ⁄¥ic<“µÙÄ   ç@bfZA£H=C†Q£F¢K*WÆÏÿt˛˘ÁKßNùdÈ“•≤b≈
Ÿπsß#Bhﬁ3œ<#ÍA†IÇ?ˇ˘œ“ºysÁy=Qoà«\æ˚Ó;QAC≈
ÙÌ´^?¿R©R%QOÜ~¯¡àvªvÌíW^yE∆éÎx'úp¬	r·Ö ÈßünñxhYG∆åc€¥iì6L∫uÎ&õ7oñm€∂Iè=‰ßü~íó_~Yj◊Æ-ˇ¯«?d¸¯Ò≤uÎVS«}˜›'ôôôÊymÛˆ€o7∂’Ø__Ü^,—√T∆ ê@+WÆî7ﬁxCZµje˛&ÿUC Ä   $Å ªK$2MD&œà–˘À_Ã§[= t“¢ÄùT –∏öT<–@s*|¯·á2`¿ ªX»q⁄¥ir⁄ißôºO?˝T˙ıÎrﬂ}°m._æ‹Cá5B¡¿Åç˜ƒ˛˝˚çp1wÓ\˜#Œπ
CÜ1◊W\qÖúõ÷IØ^Ωå¿†bHx“6_zÈ%yÙ—GÕ≠3f!B/¥=(4=¯‡Ér«wòs˛/`w	/é
6A¿‚˘[¬=∆J@ ﬁ'ª?∑˜˚ÑÖ&† øˇ˝ÔÂÃ3œ4ü∫uÎ:ÉbQ@Ü;v»ı◊_oHU©R≈ºIµóThÊˇ˝ﬂˇ…Ó›ªE=n∏·SNˇsÔΩ˜ Ãô3£äNY˝·≥n›:3·◊Lç°û*®0°È˛˚Ô7ÌËπ⁄ÏNÍ}«?˛1diá⁄™}–%YYYr…%ó8è∏£ÛOû<Ÿ…WOºJ`ıÍ’&&Éz3ê  @ Ä ¸OÄÂ˛CzF‡ìO>	À9|©ÅÓ˛†iŒú9&ˆÅûÎr	]∫†I„7<ÿ‹”•∫¸¿ˆ"PQ‚ÓªÔ6K˛˚ﬂˇØ˚ûy∏êˇËíâä+œÜ7ﬂ|SZ∂liñ=ÿÒ!4ûÉ
∫Bó}® °qFçÂ‘<k÷,i€∂≠Yv°œÈzvıv¯˙ÎØÂ’W_ï;Ôº”,ë–~h≤≈ßN ‡1*ñÈÓ$@ Ä   ÅÙ Ä»ê„H/\zË!˘Ò«çx`gÎr
ç£`'çq`ßßü~ZÙ£iﬁºyv∂l@3uBØﬁ	öt9Fü>}¬dF¯OÕö5ç◊ÇzXh›◊^{≠SJ=tÉ;˛√¡ÉÕ}XπwÔ^„ua?p÷Ygôù'Ù∫|˘Ú&[ÌªÊökå»∞~˝z≥lCÛlÒCw©p˜¡Æã#ºB@Ω}TÄk⁄¥©\vŸe^1Àv‰Ó⁄'+◊o5∂ŒÀﬁhéıkfJ˝öíY©º¥l\√˝HÖë+ÿ*πª˜…O[Ú¨OÆ1°K´∫ÊÿπUΩTòDõÄ   Å¥!Ä»ê6CIGîÄz ËÚ¸®ÒÏòˇ˚ﬂçÁÅzh≤≈=wzmß˘ÛÁÀo~Û˚“ôÿ;E8— çﬂ~˚≠¸˚ﬂˇ6û	ÓGFè-ì&M21"¥ú&˜.Ó≤zÆK%‹v€˜˚ˆÌkü ˚Ôø/ˆí]íqÍ©ß:˜8ÅÄ	®∏Ä'C—GFÖÖÈêÈæ7üÇûT¡°wß&rJß∆“Öâ≥ÃÀﬁ _.8ÃŒ‹¸Fª.îõ˘tl,ôïã∫Æ€úB Ä  P DÜ‡pÀl ~˚€ﬂ Ω˜ﬁk>⁄ço–Ω{wi÷¨ôÿÅÊ4ˇı◊_[|Xªv≠ÒÇhÿ∞°h<áúú-b“‘©SÂ +Ø4BÄÓ¯¡ÿ∑¢5ˆC^^ûY"°u©áÖ.’xÌµ◊å˜Åz8¨Zµ ,õpW¢û
·[Xj=ëí⁄y’UWôÄì∫ƒ¬N|≤^=ﬁ»Ÿ<8zì¿˜ﬂoû6i“ƒ	ÇÍMKSo’Ñ©À‰≈˜à
EI:ë?u©˘®»p’¿éÅT\3i°ä¬MÀÿ"é
7Ó&zdıQ A Ä O ë!_ÅÙpÀ-∑òm&uá	›∫RΩ4¿„I'ù‰t\À¥k◊ŒLÙ56ÉΩƒÇÃÚÑ:ò-,50ùä∫lAüY≥fçSG¥›nRójh“]Ù9›NSókhMˆ“=∑óK¸ÚÀ/2e î£Ñ-û‘ª·ÚÀ/w∂ø¥Ôk^$œ˚>GxÅÄäx2<Í⁄ˇ∑Á?s‹˙›•≥VóåäÂ§y√jfâƒÍúmí∑{ø¨˘qªY`ó’âˆºQ‰¬>meËŸÒv^≈ò—Ô/4"ãÕ¡>ÍríÊ™IF•r¢uÈƒöúÌí∑gø(C;i#«~%£'-êGÆ=ç%(6éÄ   Å 2 á[˛!`OŒ√-VQ@∑âÏ“•ãπ•ÀtÁ}Àˇ√ÀÌ∑ﬂ.À†}˚ˆ!èjºÕ”¿ãØ¡ﬁŒrÃò1GMÊCªP	[d–†å˙q'ÃhoØ©˘ç76∑U9ÔºÛLP«8è∏=0úLÎ§k◊Æ& §ãA„<tÓ‹Ÿ]ÑsxíÄz˜Ë“°òùS<id
ç˙`∆*y˙Õπ!ﬁukd»†ﬁ≠•g;À„ :èñf.…ëØØóOÁÆuä®gÉ
œﬁ‘?≠ÖÜ=1ET†qß~]õIœˆç§á≈.Z⁄∏5OfXÏ&N_!zÆIΩB¥æCzôe—û%Ä   ∂∞‰[êÏ8nØ ªc:Ÿ~Í©ßÏKπÒ∆Õ∂ë˚€ﬂÃR	Á∆ë]r†¬Ç
ö4.√¬Öù†tÎ`⁄¥ir”M7y"ˇ†ªGh≤Ì—XÍÒ†À¬”m∑›f