USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJDOCNUM_TRAN]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[WOPJDOCNUM_TRAN]
AS
   SELECT      LastUsed_Tran
   FROM        PJdocnum
   WHERE       id = '16'
GO
