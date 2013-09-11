---
layout: post_list
title: Updates
---

<div class="post-list">
	{% for post in site.posts %}
	  <div class="post">
	  	<a href="{{site.baseurl }}{{ post.url }}">{{ post.title }}</a>
	  	{{ post.description }}
	    <span class="text-muted">{{  post.date | date_to_long_string }}</span>
	  </div>
	{% endfor %}
</div>

<hr>

[Subscribe to RSS Feed]({{ site.baseurl}}/rss.xml)
