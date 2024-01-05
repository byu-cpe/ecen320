---
layout: page
toc: false
title: TA Hours
icon: far fa-calendar
---

# TA/Office Hrs Schedule
<!--
<iframe src="https://calendar.google.com/calendar/embed?height=600&amp;wkst=1&amp;bgcolor=%23ffffff&amp;ctz=America%2FDenver&amp;src=Z3N1M2ljNm9qa2VpNWNtcWp1bms5NXFxa2NAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ&amp;color=%23c53f00&amp;mode=WEEK" style="border:solid 1px #777" width="800" height="600" frameborder="0" scrolling="no"></iframe>
-->

![](../../images/TAHours.png)

# Zoom Links
The links below are where each TA will hold their TA hours via Zoom. When the calendar above indicates a TA is holding hours, find them in the lab during lab hours, or click the corresponding link below to connect to that TA during their office hours.

<table>
    <tr>
        <th>Name</th>
        <th>Zoom Link</th>
    </tr>
    {% for itm in site.data.zoom %}
    <tr class="{{ itm.name | downcase }}" style="color: {{ section.color }}">
        <td class="name" style="color: {{ itm.color }}">{{ itm.name }}</td>
        {% if itm.zoom contains "EB423" %}
        <td class="zoom">{{ itm.zoom }}</td>
        {% else %}
        <td class="zoom"><a href = '{{ itm.zoom }}'>{{ itm.zoom }}</a></td>
        {% endif %}
        <td class="insession"><div id = "{{ itm.handle }}"><img src = "{% link icon/lucy-van-pelt-1-.jpg %}" style="width:75px;"></div></td>
    </tr>
    {% endfor %}
</table>

<script>
var time = new Date();
var current_hour = time.getHours();
var current_day = time.getDay();

{% for ta in site.data.zoom %}
    var x = document.getElementById("{{ ta.handle }}");
    x.style.display = "none";
{% endfor %}

{% for ta in site.data.zoom %}
  var x = document.getElementById("{{ ta.handle }}");
  {% for hour in ta.hours %}
    if(current_day == {{ hour.day }} && current_hour >= {{ hour.start_time }} && current_hour < {{ hour.end_time }}) {
      x.style.display = "block";
    }
  {% endfor %}
{% endfor %}

</script>

# TA Assignments for Grading Labs
If you have questions on your graded labs, here are the TAs to talk to:
* Bryan Despain -- Lab Reports and Pass-offs
* Christian Hales -- Lab Reports and Pass-offs

Contact information can be found in Learning Suite "EC EN 220 -> Home -> Class Info"
