USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HDisc_MiscCharge]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850HDisc_MiscCharge] @CpnyId varchar(10), @EDIPOID varchar(10) As
Select * From ED850HDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And Indicator = 'C'
GO
