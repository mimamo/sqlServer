USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Cpny_CustId_Cls_bydate]    Script Date: 12/21/2015 14:05:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Cpny_CustId_Cls_bydate    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_Cpny_CustId_Cls_bydate] @parm1 varchar ( 15), @parm2 varchar ( 10) as
    SELECT DISTINCT d.*
      FROM ardoc d LEFT OUTER JOIN ARTran t
                     ON d.Custid = t.Custid
                    AND d.Refnbr = t.SiteID
                    AND d.Doctype = t.CostType
     WHERE d.custid = @parm1
       AND d.Rlsed = 1
       AND d.doctype IN ('FI','IN','DM', 'NC')
       AND d.curydocbal > 0
       AND d.cpnyid Like @parm2
       AND t.Custid IS NULL
       AND ISNULL(t.DRCR,'U') = 'U'
    order by d.CustId, d.Rlsed, d.DueDate, d.Refnbr
GO
