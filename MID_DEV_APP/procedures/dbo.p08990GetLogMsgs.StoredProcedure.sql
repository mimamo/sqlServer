USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990GetLogMsgs]    Script Date: 12/21/2015 14:17:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[p08990GetLogMsgs] as

Select * from WrkIChk order by custid
GO
