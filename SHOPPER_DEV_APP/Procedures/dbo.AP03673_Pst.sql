USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP03673_Pst]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AP03673_Pst    Script Date: 4/7/98 12:54:32 PM ******/
--apptable
CREATE PROC [dbo].[AP03673_Pst] @RI_ID smallint
AS
        DELETE FROM AP03673_Wrk WHERE RI_ID = @RI_ID
GO
