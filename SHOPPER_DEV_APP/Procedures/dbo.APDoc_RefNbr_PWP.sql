USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_RefNbr_PWP]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_RefNbr_PWP    Script Date: 06/7/06 ******/
Create Procedure [dbo].[APDoc_RefNbr_PWP] @parm1 varchar ( 10) as
SELECT a.*
  FROM APDoc a JOIN Terms t
          ON a.Terms = t.TermsID
 WHERE RefNbr LIKE @parm1
   AND t.DiscType = 'P'
   AND a.Doctype IN ('AC','VO')
   AND a.DocBal > 0
ORDER BY RefNbr DESC
GO
