USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_1052_AvgCst_SiteVar]    Script Date: 12/21/2015 14:34:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
	Get all ItemSite record for AvgCost update with _ve calculated value.
*/

Create Proc [dbo].[SCM_1052_AvgCst_SiteVar]
        @ComputerName	Varchar(21),
	@CpnyID		Varchar(10),
        @DirAmt         Float,               	-- Direct Amount
        @DirPct         Float,               	-- Direct Percent
	@DirBox		VarChar (1),		-- Direct Box
        @DecPlPrcCst    SmallInt

As

Set NoCount ON

	Select	Count(*)
        From ItemSite (NoLock), IN10520_Wrk
        Where 	ItemSite.InvtId = IN10520_Wrk.InvtId
          And 	IN10520_Wrk.ComputerName = @ComputerName
	  And	ItemSite.CpnyID = @CpnyID
	  AND
		(
		  (Case When AvgCost <> 0 and @DirBox = '1'
                        Then Case When @Dirpct <> 0
				  Then Round((AvgCost * (1 + (@Dirpct/100))), @DecPlPrcCst)
				  Else Round((AvgCost + @DirAmt), @DecPlPrcCst)
			     End
			Else PDirStdCst
                   End) < 0 /* PDirStdCst < 0 */
		OR
                  ((Case When AvgCost <> 0 and @DirBox = '1'
                         Then Case When @Dirpct <> 0
                                   Then Round((AvgCost * (1 + (@Dirpct/100))), @DecPlPrcCst)
                                   Else Round((AvgCost + @DirAmt), @DecPlPrcCst)
                              End
			 Else PStdCst
                    End) + (PFOvhStdCst + PVOvhStdCst)) < 0 /* PStdCst < 0 */
		) -- End
GO
