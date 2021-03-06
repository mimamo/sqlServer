USE [DALLASAPP]
GO
/****** Object:  View [dbo].[x_PJCODE_Product]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[x_PJCODE_Product]

as
select 
p.project as 'Project', 
substring(p.project,4,3) as 'Product', 
c.code_value_desc as 'Product Desc'
from pjproj p 
join pjcode c on substring(p.project,4,3)=c.code_value and c.code_type='0PRD'
GO
