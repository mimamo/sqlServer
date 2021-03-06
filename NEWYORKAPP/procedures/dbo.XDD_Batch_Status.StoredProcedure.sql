USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDD_Batch_Status]    Script Date: 12/21/2015 16:01:23 ******/
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
