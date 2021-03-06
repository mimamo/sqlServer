USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_CreationDate]    Script Date: 12/21/2015 14:34:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Header_CreationDate] @FromDate smallint, @ToDate smallint

AS

Select * from ED850Header A, ED850HeaderExt B
where a.cpnyid = b.cpnyid and a.edipoid = b.edipoid
and b.CreationDate Between @FromDate and @ToDate
and ordnbr > ' '
order by a.EDIPOID
GO
