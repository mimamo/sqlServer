USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xqwip_denver]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqwip_denver] 
as 
select project, sum(wipamt) wipamt 
from xwrk_DenverWIP 
group by project
GO
