USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOHeader_All]    Script Date: 12/21/2015 13:35:59 ******/
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
