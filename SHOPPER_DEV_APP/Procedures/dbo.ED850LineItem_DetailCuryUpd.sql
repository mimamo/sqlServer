USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_DetailCuryUpd]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LineItem_DetailCuryUpd] @CpnyId varchar(10), @EDIPOID varchar(10), @CuryId varchar(4),
@CuryEffDate smalldatetime, @CuryMultDiv varchar(1), @CuryRate float, @CuryRateType varchar(6) As
Update ED850LDisc Set CuryId = @CuryId, CuryEffDate = @CuryEffDate, CuryMultDiv = @CuryMultDiv,
CuryRate = @CuryRate, CuryRateType = @CuryRateType Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
Update ED850LSSS Set CuryId = @CuryId, CuryEffDate = @CuryEffDate, CuryMultDiv = @CuryMultDiv,
CuryRate = @CuryRate, CuryRateType = @CuryRateType Where CpnyId = @CpnyId And EDIPOID = @EDIPOID
GO
