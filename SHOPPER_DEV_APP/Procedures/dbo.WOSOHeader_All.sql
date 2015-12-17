USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOHeader_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOSOHeader_All]
   @OrdNbr	varchar(15)
AS
   SELECT	*
   FROM		SOHeader
   WHERE	OrdNbr LIKE @OrdNbr and
                Status = 'O'
GO
