USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xq_vw_xqaud01]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xq_vw_xqaud01]

as

select * from xqaud01
UNION ALL
select * from xqaud02
UNION ALL
select * from xqaud03
UNION ALL
select * from xqaud04
UNION ALL
select * from xqaud05
UNION ALL
select * from xqaud06
UNION ALL
select * from xqaud07
UNION ALL
select * from xqaud08
UNION ALL
select * from xqaud09
UNION ALL
select * from xqaud10
GO
