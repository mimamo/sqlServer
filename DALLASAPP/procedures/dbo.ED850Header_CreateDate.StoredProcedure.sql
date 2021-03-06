USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_CreateDate]    Script Date: 12/21/2015 13:44:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Header_CreateDate] @FromDate smalldatetime, @ToDate smalldatetime

AS

Select ED850Header.* from ED850Header, ED850HeaderExt
where ED850Header.cpnyid = ED850HeaderExt.cpnyid and ED850Header.edipoid = ED850HeaderExt.edipoid
and ED850HeaderExt.CreationDate Between @FromDate and @ToDate and ED850Header.UpdateStatus in ('OK','OC','IN','CE')
order by ED850Header.EDIPOID
GO
