USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xq_Voucher_Projects]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xq_Voucher_Projects] 
as 
select distinct vendid, trantype, refnbr, projectid 
from aptran 
where projectid > '0'
GO
