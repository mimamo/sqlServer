USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HDisc_CountBad]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850HDisc_CountBad] @CpnyId varchar(10), @EDIPOID varchar(10), @CustId varchar(15) As
Select Count(*) From ED850HDisc Where CpnyId = @CpnyId And EDIPOID = @EDIPOID And SpecChgCode Not In (Select SpecChgCode From EDDiscCode Where Direction = 'I' And CustId In ('*',@CustId))
GO
