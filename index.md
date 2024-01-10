---
layout: base.njk
---

<style>
@keyframes fadeInLeft {
  0% {
    opacity: 0;
    transform: translateX(-40px);
  }

  100% {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes fadeInRight {
  0% {
    opacity: 0;
    transform: translateX(40px);
  }

  66% {
    opacity: 0;
    transform: translateX(40px);
  }

  100% {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes fadeInUp {
  0% {
    opacity: 0;
    transform: translateY(10px);
  }

  66% {
    opacity: 0;
    transform: translateY(10px);
  }

  100% {
    opacity: 1;
    transform: translateY(0);
  }
}
.fullWidth {
  margin-left: -33.33%;
  margin-right: -33.33%;
}
.fullHeight {
  margin-top: 33%;
  margin-bottom: 33%;
}
.heroTitle {
  font-size: 4em;
  text-align: center;
}
.mono {
  display: inline-block;
  animation: 2s fadeInLeft;
  font-family: ui-monospace, 
             Menlo, Monaco, 
             "Cascadia Mono", "Segoe UI Mono", 
             "Roboto Mono", 
             "Oxygen Mono", 
             "Ubuntu Monospace", 
             "Source Code Pro",
             "Fira Mono", 
             "Droid Sans Mono", 
             "Courier New", monospace;;
  letter-spacing: -5px;
  background: #333;
  color: #fff;
  padding: 5px 15px 5px 5px;
  border-radius: 10px;
}
.serif {
  font-size: 4.5rem;
  display: inline-block;
  animation: 2s fadeInRight;
  letter-spacing: -2px;
  margin-left: 0.3em;
  font-style: italic;
}
.fadeUp {
  animation: 3s fadeInUp;
}
.skills {
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;
}
@media (max-width: 731px) {
  .fullWidth {
    margin-left: 0;
    margin-right: 0;
  }
  .mono, .serif {
    font-size: 3.5rem;
  }
  .serif {
    margin: 1rem 0 0 0;
  }
  .skills {
    flex-direction: column;
    align-items: center;
  }
}
article {
  margin-bottom: 4rem;
}
</style>

<div class="fullWidth fullHeight">
  <div style="text-align: center">
    <h2 class="heroTitle"><div class="mono">Full Stack</div><div class="serif">Front end specialist</div></h2>
  </div>
  <div class="fadeUp skills">
    <div>20 years programming experience</div>
    <div>Comp sci fundamentals</div>
    <div>Highly scalable applications</div>
    <div>Pragmatic</div>
  </div>
</div>

<h2>Blog</h2>

{%- for post in collections.post reversed -%}

<article>
  <a href="{{ post.url }}"><h2>{{ post.data.title }}</h2></a>
  <p>{{ post.date | formatDate }}</p>
  <p>{{ post.data.summary }}</p>
</article>
{%- endfor -%}
