--Problem 1

select distinct u.id, u.fname, u.lname, x.role, v.name, v.year
from actor u, casts x, movie v,
   (select xy.pid, xy.mid
    from casts xy
    group by xy.pid, xy.mid
    having count(distinct xy.role) > 4) y
where u.id = x.pid and x.pid = y.pid and x.mid = y.mid and x.mid = v.id and v.year = 2010
order by u.lname, u.fname;
go


--Problem 2

select z.year, count(*) AS "Number of Movies"
from movie z
where not exists (select *
                  from actor x, casts xy
                  where x.id = xy.pid and xy.mid = z.id and x.gender!='F')
group by z.year;
go



--Problem 3

select a.year, a.c*100.00/b.c as Percentage, b.c as Total_Overall
from (select z.year, count(*) as c
      from movie z
      where not exists (select *
                        from actor x, casts xy
                        where x.id = xy.pid and xy.mid = z.id and x.gender!='F')
      group by z.year) a,
     (select z.year, count(*) as c from movie z group by z.year) b
where a.year=b.year
order by a.year;
go



--Problem 4

select x.name, count(distinct xy.pid) as cast
from movie x, casts xy
where x.id = xy.mid
group by x.id, x.name
having count(distinct xy.pid) >= all
       (select count(distinct uv.pid)
        from casts uv
        group by uv.mid);
go

--Problem 5

select y.year, count(*)
from (select distinct x.year from movie x) y,
     movie z
where y.year <= z.year and z.year < y.year+10
group by y.year
having not exists (select y1.year
                   from (select distinct x1.year from movie x1) y1, movie z1
                   where y1.year <= z1.year and z1.year < y1.year+10
                   group by y1.year
                   having count(z1.id) > count(z.id));
go

--Problem 6

select count(distinct a1.id) AS "# of Actors"
from actor a1, casts c1, casts c2, 
		(select distinct a.id from actor a, 
		casts c1, casts c2, actor kb 
		where kb.fname = 'Kevin' and kb.lname = 'Bacon' 
			and kb.id = c2.pid 
			and c2.mid = c1.mid 
			and c1.pid = a.id 
			and kb.id != a.id) 
kb1 where kb1.id = c2.pid and c2.mid = c1.mid and c1.pid = a1.id 
and  not exists 
		(select distinct a.id from actor a, casts c1, casts c2, actor kb 
		where kb.fname = 'Kevin' and kb.lname = 'Bacon' 
			and kb.id = c2.pid 
			and c2.mid = c1.mid 
			and c1.pid = a.id 
			and a1.id = a.id);



 go
