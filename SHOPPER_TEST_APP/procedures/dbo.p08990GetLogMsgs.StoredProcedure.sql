USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990GetLogMsgs]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[p08990GetLogMsgs] as

Select * from WrkIChk order by custid
GO
