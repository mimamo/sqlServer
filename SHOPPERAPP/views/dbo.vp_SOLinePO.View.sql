USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vp_SOLinePO]    Script Date: 12/21/2015 16:12:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create view [dbo].[vp_SOLinePO] as

	Select	SOLine.*
	From	SOLine

	join	SOHeader (nolock)
	on		SOHeader.CpnyID = SOLine.CpnyID 
	and		SOHeader.OrdNbr = SOLine.OrdNbr

	join	SOType (nolock)
	on		SOType.CpnyID = SOHeader.CpnyID
	and		SOType.SOTypeID = SOHeader.SOTypeID

	Where	SOLine.Status = 'O' 
	And		QtyOrd >= 0
	And		Behavior IN ('CS','INVC','WO','MO','RMSH','SO','WC')
	and 	exists(select * from SOSched where SOSched.CpnyID = SOLine.CpnyID and SOSched.OrdNbr = SOLine.OrdNbr and SOSched.LineRef = SOLine.LineRef and (SOType.Behavior = 'MO' or SOSched.LotSerialReq = 0) and SOSched.LotSerialEntered = 0)
GO
