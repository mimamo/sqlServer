USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[vr_40742_SOHeader]    Script Date: 12/21/2015 13:56:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vr_40742_SOHeader] as
select RI_ID, ShortAnswer00, ShortAnswer01, SOHeader.* 
from SOHeader
cross join RptRuntime
where ReportNbr in ('40742', '40745')
GO
