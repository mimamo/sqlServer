USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HSSS_AllDMG]    Script Date: 12/21/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850HSSS_AllDMG] @CpnyId varchar(10), @EDIPOID varchar(15), @LineNbrMin smallint, @LineNbrMax smallint As
Select * From ED850HSSS Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And LineNbr Between @LineNbrMin And @LineNbrMax
GO
