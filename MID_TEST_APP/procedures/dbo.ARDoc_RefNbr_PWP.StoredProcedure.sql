USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_RefNbr_PWP]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_RefNbr_PWP    Script Date: 06/7/06 ******/
Create Procedure [dbo].[ARDoc_RefNbr_PWP] @parm1 varchar ( 10) as
SELECT *
  FROM ARDoc
 WHERE RefNbr LIKE @parm1
   AND DocType = 'IN' AND DocBal <> 0
 ORDER BY RefNbr DESC
GO
