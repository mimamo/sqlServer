USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDD_Batch_Status]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDD_Batch_Status]
	@Module		varchar(2),
	@BatNbr		varchar(10)
AS
  	Select 		Status
  	FROM 		Batch (nolock)
  	WHERE 		Module = @Module
  			and BatNbr LIKE @BatNbr
GO
