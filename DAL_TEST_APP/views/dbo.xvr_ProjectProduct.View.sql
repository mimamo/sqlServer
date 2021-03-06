USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_ProjectProduct]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_ProjectProduct]

as

select 
project as 'Project', 
substring(project,4,3) as 'Product', 
code_value_desc as 'ProductDesc' 
from pjproj p
join pjcode c on substring(project,4,3)=c.code_value and c.code_type='0PRD'
GO
