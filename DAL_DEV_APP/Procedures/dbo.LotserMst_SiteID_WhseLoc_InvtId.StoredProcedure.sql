USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotserMst_SiteID_WhseLoc_InvtId]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LotserMst_SiteID_WhseLoc_InvtId]
@parm1 varchar ( 10),
@parm2 varchar ( 10), 
@parm3 varchar ( 30),
@parm4 varchar ( 1) as

Declare @ExecStr as varchar (1000)
Declare @OrderByStr as varchar (100)

Set @OrderByStr = Case @parm4
					When 'E' Then 'Order by SiteID, WhseLoc, InvtID, Expdate, LotSerNbr'
					When 'L' Then 'Order by SiteID, WhseLoc, InvtID, LIFOdate desc, LotSerNbr desc'
					When 'F' Then 'Order by SiteID, WhseLoc, InvtID, RcptDate, LotSerNbr'
					Else 'Order by SiteID, WhseLoc, InvtID, LotSerNbr'
				End
Set @ExecStr = 'Select InvtId, QtyAlloc, QtyAvail, SiteId, WhseLoc, LotSerNbr from LotSerMst where SiteID = ' + '''' + @parm1 + '''' + ' and WhseLoc = ' + '''' + @parm2 + '''' + ' and InvtId = ' + '''' + @parm3 + '''' + ' and Status = ''A'' ' + rtrim(@OrderByStr)

Exec (@ExecStr)
GO
