USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_1052_PendCost_ClassVar]    Script Date: 12/21/2015 13:35:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
	Fetch ProductClass Pending Cost...
*/
Create Proc [dbo].[SCM_1052_PendCost_ClassVar]
    	@ComputerName     	VarChar(21),
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
  			(Case When PFOvhMatlRate <> 0 and @FixAmt <> 0
                              Then Round((PFOvhMatlRate + @FixAmt), @DecPlPrcCst)
                              Else Case When PFOvhMatlRate <> 0 and @FixPct <> 0
                                        Then Round((PFOvhMatlRate * (1 + (@FixPct/100))), @DecPlPrcCst)
                                        Else PFOvhMatlRate
                                        End
                              End) < 0 /*PFOvhMatlRate < 0 */
   		OR
             		(Case When PVOvhMatlRate <> 0 and @VarAmt <> 0
                              Then Round((PVOvhMatlRate + @VarAmt), @DecPlPrcCst)
                              Else Case When PVOvhMatlRate <> 0 and @VarPct <> 0
                                        Then Round((PVOvhMatlRate * (1 + (@VarPct/100))), @DecPlPrcCst)
                                        Else PVOvhMatlRate
					End
                              End) < 0 /*PVOvhMatlRate < 0 */
 		)
GO
