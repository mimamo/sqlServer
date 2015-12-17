USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_1052_StdCost_ClassVar]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
	Fetch ProductClass Pending Cost...
*/
Create Proc [dbo].[SCM_1052_StdCost_ClassVar]
    	@ComputerName   VarChar(21),
        @FixAmt         Float,               -- Fixed Amount
        @VarAmt         Float,               -- Variable Amount
        @FixPct         Float,               -- Fixed Percent
        @VarPct         Float,               -- Variance Percent
        @DecPlPrcCst    SmallInt

As

Set NoCount ON

	Select	Count(*)
      	From ProductClass(NoLock), IN10520_Wrk
        Where @ComputerName = IN10520_Wrk.ComputerName
            	And ProductClass.ClassId = IN10520_Wrk.ClassId
		AND
		(
			(Case When CFOvhMatlRate <> 0 and @FixAmt <> 0
                              Then Round((CFOvhMatlRate + @FixAmt), @DecPlPrcCst)
                              Else Case When CFOvhMatlRate <> 0 and @FixPct <> 0
                                        Then Round((CFOvhMatlRate * (1 + (@FixPct/100))), @DecPlPrcCst)
                                        Else CFOvhMatlRate
                                   End
                         End) < 0 /* PFOvhMatlRate < 0 */
		OR
            		(Case When CVOvhMatlRate <> 0 and @VarAmt <> 0
                              Then Round((CVOvhMatlRate + @VarAmt), @DecPlPrcCst)
                              Else Case When CVOvhMatlRate <> 0 and @VarPct <> 0
                                        Then Round((CVOvhMatlRate * (1 + (@VarPct/100))), @DecPlPrcCst)
                                        Else CVOvhMatlRate
                                   End
                         End) < 0 /*PVOvhMatlRate < 0 */
		)
GO
