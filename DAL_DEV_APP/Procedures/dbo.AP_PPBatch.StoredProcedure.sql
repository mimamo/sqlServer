USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP_PPBatch]    Script Date: 12/21/2015 13:35:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_PPBatch]
	@BatNbr varchar(10)
AS

SELECT * FROM Batch
WHERE BatNbr LIKE @BatNbr
AND editscrnnbr = '03070'
AND status <> 'V'
ORDER BY BatNbr
GO
