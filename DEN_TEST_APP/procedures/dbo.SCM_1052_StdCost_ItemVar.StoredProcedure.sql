USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_1052_StdCost_ItemVar]    Script Date: 12/21/2015 15:37:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
	Fetch Inventory Std Cost
*/

Create Proc [dbo].[SCM_1052_StdCost_ItemVar]
    	@ComputerName  	VarChar(21),
        @DirAmt         Float,               -- Amount
        @FixAmt         Float,               -- Fixed Amount
        @VarAmt         Float,               -- Variable Amount
        @DirPct         Float,               -- Percent
        @FixPct         Float,               -- Fixed Percent
        @VarPct         Float,               -- Variance Percent
        @DecPlPrcCst    SmallInt

As
	Set	NoCount On

	Select	Count(*)
	FROM Inventory(NoLock),IN10520_Wrk
        Where Inventory.InvtId = IN10520_Wrk.InvtId
                And IN10520_Wrk.ComputerName = @ComputerName
		AND
		   (
            		  (Case When @DirAmt <> 0
                               Then Round((DirStdCost + @DirAmt), @DecPlPrcCst)
                               Else Case When DirStdCost <> 0 and @Dirpct <> 0
                                         Then Round((DirStdCost * (1 + (@Dirpct/100))), @DecPlPrcCst)
                                         Else DirStdCost
                                    End
                               End ) < 0
			  OR
            		  (Case When @FixAmt <> 0
                                Then Round((FOvhStdCost + @FixAmt), @DecPlPrcCst)
                                Else Case When FOvhStdCost <> 0 and @Fixpct <> 0
                                          Then Round((FOvhStdCost * (1 + (@Fixpct/100))), @DecPlPrcCst)
                                          Else FOvhStdCost
                                     End
                           End ) < 0
		    	  OR
			  (Case When @VarAmt <> 0
                                Then Round((VOvhStdCost + @VarAmt), @DecPlPrcCst)
                                Else Case When VOvhStdCost <> 0 and @Varpct <> 0
                                          Then Round((VOvhStdCost * (1 + (@Varpct/100))), @DecPlPrcCst)
                                          Else VOvhStdCost
                                     End
                           End) < 0
			  OR
            		  (
			   (Case When @DirAmt <> 0
                                Then Round((DirStdCost + @DirAmt), @DecPlPrcCst)
                                Else Case When DirStdCost <> 0 and @Dirpct <> 0
                                          Then Round((DirStdCost * (1 + (@Dirpct/100))), @DecPlPrcCst)
                                          Else DirStdCost
                                     End
                           End)
                           + (Case When @FixAmt <> 0
                                Then Round((FOvhStdCost + @FixAmt), @DecPlPrcCst)
                                Else Case When FOvhStdCost <> 0 and @Fixpct <> 0
                                          Then Round((FOvhStdCost * (1 + (@Fixpct/100))), @DecPlPrcCst)
                                          Else FOvhStdCost
                                     End
                           End)
                           + (Case When @VarAmt <> 0
                                Then Round((VOvhStdCost + @VarAmt), @DecPlPrcCst)
                                Else Case When VOvhStdCost <> 0 and @Varpct <> 0
                                          Then Round((VOvhStdCost * (1 + (@Varpct/100))), @DecPlPrcCst)
                                          Else VOvhStdCost
                                     End
                           End)
			   ) < 0
		   )
GO
