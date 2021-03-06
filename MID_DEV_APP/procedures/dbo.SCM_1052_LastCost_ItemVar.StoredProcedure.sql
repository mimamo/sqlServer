USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_1052_LastCost_ItemVar]    Script Date: 12/21/2015 14:17:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
	Get Inventory records with -ve Last Cost update
*/

Create Proc [dbo].[SCM_1052_LastCost_ItemVar]
	@ComputerName   Varchar(21),	     -- Computer Name
        @DirAmt         Float,               -- Direct Amount
        @DirPct         Float,               -- Direct Percent
        @DirBox 	VarChar(1),          -- Direct Box
        @DecPlPrcCst    SmallInt
As

	Set	NoCount On

	Select	Count(*)
	FROM Inventory (NoLock),IN10520_Wrk
        Where Inventory.InvtId = IN10520_Wrk.InvtId
                And IN10520_Wrk.ComputerName = @ComputerName
		AND
		(
		   (Case When LastCost <> 0 and @DirBox = '1'
                         Then Case When @Dirpct <> 0
                                   Then Round((LastCost * (1 + (@Dirpct/100))), @DecPlPrcCst)
                                   Else Round((LastCost + @DirAmt), @DecPlPrcCst)
                              End
			 Else PDirStdCost /* LastCost = 0 or @DirBox <> '1' */
                      End) < 0  /* If PDirStdCost = 0 */
                   OR
    		    ((Case When LastCost <> 0 and @DirBox = '1'
                           Then Case When @Dirpct <> 0
                                     Then Round((LastCost * (1 + (@Dirpct/100))), @DecPlPrcCst)
                                     Else Round((LastCost + @DirAmt), @DecPlPrcCst)
                                End
			   Else PStdCost /* LastCost = 0 or @DirBox <> '1' */
                      End) + (PFOvhStdCost + PVOvhStdCost)) < 0 /* If PStdCost = 0 */

		)
GO
