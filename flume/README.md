# flume

[flume download](http://www.apache.org/dist/flume/1.8.0/).
[flume](https://flume.apache.org/download.html).
[flume docker](https://hub.docker.com/r/bigcontainer/flume/).

```yaml
cat /opt/flume/flume.conf
agent.sources = s1
agent.channels = c1
agent.sinks = k1

agent.sources.s1.type = http
agent.sources.s1.handler = org.apache.flume.source.http.JSONHandler
agent.sources.s1.channels = c1
agent.sources.s1.bind = 0.0.0.0
agent.sources.s1.port = 1234

agent.channels.c1.type = memory

# Each sink's type must be defined
agent.sinks.k1.type = logger

# Specify the channel the sink should use
agent.sinks.k1.channel = c1
```