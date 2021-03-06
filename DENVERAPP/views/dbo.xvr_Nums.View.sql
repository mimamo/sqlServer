USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_Nums]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_Nums]
as
with   cte0 as (select 1 as c union all select 1), 
       cte1 as (select 1 as c from cte0 a, cte0 b), 
       cte2 as (select 1 as c from cte1 a, cte1 b), 
       cte3 as (select 1 as c from cte2 a, cte2 b), 
       cte4 as (select 1 as c from cte3 a, cte3 b), 
       cte5 as (select 1 as c from cte4 a, cte4 b), 
       nums as (select row_number() over (order by c) as n from cte5)
       select n from nums
GO
