package com.android.quieromas.fragment;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.quieromas.R;
import com.android.quieromas.activity.MainActivity;

public class AboutUsFragment extends BaseFragment {


    public AboutUsFragment() {
        // Required empty public constructor
    }


    public static AboutUsFragment newInstance() {
        AboutUsFragment fragment = new AboutUsFragment();
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void onResume() {
        super.onResume();
        ((MainActivity) getActivity()).setActionBarTitle("Sobre Quiero Más!");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_about_us, container, false);
    }



    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        TextView about = (TextView) view.findViewById(R.id.txt_about_text);
        about.setText("Lorem ipsum dolor sit amet, est in affert graece eligendi, usu at partiendo maiestatis persequeris. Cu dicant legendos nec, et cetero efficiendi pro, in tota dicant maluisset sed. Iudico omnium sapientem qui ea, no summo eripuit laoreet eum. His te alii eirmod intellegam, cu legere vivendo duo. Ad accusata temporibus intellegebat mei, no facilis laboramus vix. Sit stet abhorreant ne, magna imperdiet no mei.\n" +
                "\n" +
                "Causae feugiat qui at. Mel nihil laboramus theophrastus ut, et ius ferri ponderum fabellas, impedit omnesque suscipit eu mea. Qui te veri moderatius reprehendunt, at cum doming delicatissimi, te cum wisi impedit civibus. Sit ut velit nonumy consetetur, an eos diceret oportere.\n");

    }


}
