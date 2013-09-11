---
layout: post_list
title: Blog
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

<a href="{{site.baseurl }}/rss.xml">Subscribe to RSS feed</a>

