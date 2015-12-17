USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xUpdate_Variance]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xUpdate_Variance] 
	@parm1 Varchar (16) 
as

Update xEstRevInq
set Variance = Actual - RevisedEst
where Project = @parm1
GO
