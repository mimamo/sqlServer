USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_Unposted_CuryId]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Header_Unposted_CuryId] @CuryId varchar(4) As
Select CpnyId, EDIPOID From ED850Header Where UpdateStatus = 'OK' And CuryId = @CuryId And Exists
(Select * From EDInbound Where EDInbound.CustId = ED850Header.CustId And EDInbound.Trans In ('850','875') And EDInbound.ConvMeth In ('CH','CO','CI'))
Union
Select CpnyId, EDIPOID From ED850Header Where UpdateStatus = 'OK' And CuryId <> @CuryId And Exists
(Select * From EDInbound Where EDInbound.CustId = ED850Header.CustId And EDInbound.Trans In ('850','875') And EDInbound.ConvMeth In ('CH','CO','CI'))
GO
