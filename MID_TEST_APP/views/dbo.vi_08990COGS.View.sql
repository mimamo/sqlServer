USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vi_08990COGS]    Script Date: 12/21/2015 14:26:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[vi_08990COGS] AS

SELECT d.cpnyid, d.custid, cogs = CASE WHEN d.DocType = 'CM' THEN extcost * -1 ELSE extcost END, 
       fiscyr = SUBSTRING(d.perpost,1,4), period = SUBSTRING(d.perpost,5,2)
  FROM ardoc d  JOIN artran t 
                  ON d.custid = t.custid AND d.doctype = t.trantype AND
                     d.RefNbr = t.RefNbr
 WHERE d.DocClass IN ('A', 'N') AND t.extcost <> 0 AND t.S4Future09 = 1
GO
