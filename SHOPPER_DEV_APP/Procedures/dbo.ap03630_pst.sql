USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ap03630_pst]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ap03630_pst    Script Date: 4/7/98 12:54:32 PM ******/
--apptable
CREATE PROC [dbo].[ap03630_pst] @RI_ID smallint
AS
        DELETE FROM ap03630mc_wrk WHERE RI_ID = @RI_ID
GO
