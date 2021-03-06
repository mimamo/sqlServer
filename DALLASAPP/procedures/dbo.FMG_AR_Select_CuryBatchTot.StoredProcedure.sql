USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_AR_Select_CuryBatchTot]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
** Proc Name: FMG_AR_Select_CuryBatchTot
** Narrative: SELECT CURYCRTOT FROM BATCH TABLE
** Inputs   : Batch Number
** Outputs  :
** Called by: 0801000 Application Update1_NewLevel()
*
*/

CREATE PROCEDURE [dbo].[FMG_AR_Select_CuryBatchTot] @Parm1 VARCHAR(10) AS
SELECT CuryCrTot
  FROM batch
 WHERE Module='AR' AND batnbr= @Parm1
GO
