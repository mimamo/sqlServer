USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pb_02710]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pb_02710] @RI_ID SMALLINT
AS

    if exists (select S4Future3 from PCSetup where S4Future3 = 'A' or S4Future3 = 'S')
        UPDATE RptRunTime SET ShortAnswer04 = 'TRUE' WHERE RI_ID = @RI_ID
GO
