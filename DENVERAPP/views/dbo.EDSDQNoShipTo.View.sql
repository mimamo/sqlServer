USE [DENVERAPP]
GO
/****** Object:  View [dbo].[EDSDQNoShipTo]    Script Date: 12/21/2015 15:42:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[EDSDQNoShipTo] As
Select Distinct A.CpnyId, A.EDIPOID, B.CustId, A.Storenbr From ED850SDQ A Inner Join ED850Header B On A.CpnyId = B.CpnyId And A.EDIPOID = B.EDIPOID
Where A.StoreNbr Not In (Select EDIShipToRef From EDSTCustomer C Where C.CustId = B.CustId) And B.UpdateStatus = 'BI'
GO
