USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[vp_SOSchedPO]    Script Date: 12/21/2015 16:06:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create view [dbo].[vp_SOSchedPO] as

	Select	SOSched.*
	From	SOSched

	join	SOHeader (nolock)
	on		SOHeader.CpnyID = SOSched.CpnyID 
	and		SOHeader.OrdNbr = SOSched.OrdNbr

	join	SOType (nolock)
	on		SOType.CpnyID = SOHeader.CpnyID
	and		SOType.SOTypeID = SOHeader.SOTypeID

	Where	(SOType.Behavior = 'MO' or SOSched.LotSerialReq = 0) and SOSched.LotSerialEntered = 0
	And 	QtyOrd >= 0
GO
