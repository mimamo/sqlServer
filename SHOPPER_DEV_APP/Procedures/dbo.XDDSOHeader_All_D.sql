USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDSOHeader_All_D]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[XDDSOHeader_All_D]
	@OrdNbr		varchar(15)
AS
SELECT * FROM SOHeader  
WHERE OrdNbr LIKE @OrdNbr  
ORDER BY OrdNbr DESC
GO
