USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LSSS_MaxLine]    Script Date: 12/21/2015 13:44:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LSSS_MaxLine] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select Max(LineId), Max(LineNbr) From ED850LSSS Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
