USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[pjsumhrs]    Script Date: 12/21/2015 16:06:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[pjsumhrs] as
select	employee,
		fiscalno,
	round(sum(round(directhrs,2)),2) directhrs,
	round(sum(round(indirecthrs,2)),2) indirecthrs
from pjallutl
group by employee, fiscalno
GO
