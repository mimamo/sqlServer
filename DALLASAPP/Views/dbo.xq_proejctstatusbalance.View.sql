USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xq_proejctstatusbalance]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xq_proejctstatusbalance]
as

select 

xq_projectenddatestatus.project,
[End Date],  
status,
[Billed To Date]=
case
when 
xq_projectsum.[Billed To Date] is null then 0
else
xq_projectsum.[Billed To Date]
END

from
xq_projectsum right outer join  xq_projectenddatestatus 
on 

xq_projectsum.project=
xq_projectenddatestatus.project
GO
