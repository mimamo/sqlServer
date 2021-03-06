USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_ProjCustomers]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_ProjCustomers]

as

select distinct 
rtrim(p.project) as 'Project',
left(p.project,3) as 'CustID',
rtrim(c.[name]) as 'CustName'
from pjproj p
join customer c on left(p.project,3)=c.custid
GO
