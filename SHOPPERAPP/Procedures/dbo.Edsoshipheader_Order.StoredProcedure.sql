USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Edsoshipheader_Order]    Script Date: 12/21/2015 16:13:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Edsoshipheader_Order] @FromDate smalldatetime, @ToDate smalldatetime AS
select soshipheader.ordnbr, soshipheader.cpnyid, soshipheader.invcnbr, edsoshipheader.lastedidate, soshipheader.custid,
 soshipheader.custordnbr, soshipheader.orddate,edsoshipheader.shipperid
from soshipheader, edsoshipheader
where soshipheader.shipperid = edsoshipheader.shipperid and soshipheader.cpnyid = edsoshipheader.cpnyid
and edsoshipheader.lastedidate >= @FromDate and edsoshipheader.lastedidate <= @ToDate
order by edsoshipheader.lastedidate desc
GO
