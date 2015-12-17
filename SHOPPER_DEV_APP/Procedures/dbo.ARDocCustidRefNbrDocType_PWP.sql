USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDocCustidRefNbrDocType_PWP]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDocCustidRefNbrDocType_PWP    Script Date: 06/7/06 ******/
Create proc [dbo].[ARDocCustidRefNbrDocType_PWP] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 2) As

SELECT ARCpnyID = CpnyID, ARDocType = Doctype, ARProject = ProjectID, ARRefNbr = RefNbr,
       Custid, ARDocBal = DocBal, ARDueDate = DueDate
  FROM Ardoc
 WHERE ardoc.custid = @parm1
   AND ardoc.refnbr = @parm2
   AND ardoc.doctype = @parm3
GO
